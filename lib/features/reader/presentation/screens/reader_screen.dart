import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/states/ErrorStates/app_error.dart';
import 'package:quill/core/theme/app_assets.dart';
import 'package:quill/core/theme/app_colors.dart';
import 'package:quill/core/theme/app_duration.dart';
import 'package:quill/core/theme/app_icons.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';
import 'package:quill/features/home/domain/entities/book_entity.dart';
import 'package:quill/features/library/presentation/widgets/staggerd_animation.dart';
import 'package:quill/features/reader/data/models/local_book.dart';
import 'package:quill/features/reader/domain/usecases/params/reader_book_params.dart';
import 'package:quill/features/reader/domain/usecases/params/update_book_params.dart';
import 'package:quill/features/reader/presentation/bloc/reader_bloc.dart';
import 'package:quill/features/reader/presentation/bloc/reader_event.dart';
import 'package:quill/features/reader/presentation/bloc/reader_state.dart';
import 'package:quill/features/reader/presentation/cubit/reader_preferences_cubit.dart';
import 'package:quill/features/reader/presentation/cubit/reader_preferences_state.dart';
import 'package:quill/features/reader/presentation/widgets/reader/prefernces/build_bottom_actions.dart';
import 'package:quill/features/reader/presentation/widgets/reader/build_top_bar.dart';
import 'package:quill/features/reader/presentation/widgets/reader/prefernces/reader_preferences_sheet.dart';
import 'package:quill/features/reader/presentation/widgets/reader/reader_surface.dart';
import 'package:quill/features/reader/presentation/widgets/reader/text_animation.dart';
import 'package:skeletonizer/skeletonizer.dart';

enum ReaderUiStates {
  idle,
  controlsVisible,
  bionicFadeIn,
  bionicMode,
  bionicFadeOut,
  focusTransitionIn,
  focusTransitionOut,
  focusMode,
  focusExitReveal,
  applyPreferences,
}

class ReaderScreen extends StatefulWidget {
  final ReaderBookParams bookId;
  const ReaderScreen({super.key, required this.bookId});

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  List<String> _paragraphs = [];
  final ValueNotifier<bool> _isBionicEnabled = ValueNotifier(false);
  ReaderUiStates _uiState = ReaderUiStates.controlsVisible;
  Timer? _uiHideTimer;

  /// Books
  BookEntity? _serverBook;
  LocalBook? _book;

  /// variable for local progress
  double? _currentProgress;

  /// ReaderBloc Instance To Update The Local Progress on Dispose
  late final ReaderBloc _bloc;

  /// Errors
  bool _bookError = false;
  bool _readerError = false;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<ReaderBloc>();
    context.read<ReaderPreferencesCubit>().loadPreferences();
    _startHideTimer();

    if (widget.bookId.localId == null) {
      context.read<ReaderBloc>().add(
        FetchServerBookEvent(bookId: widget.bookId.serverId!),
      );
    } else {
      context.read<ReaderBloc>().add(
        FetchLocalBookEvent(bookId: widget.bookId.localId!),
      );
    }
  }

  @override
  void dispose() {
    if (_book != null && _currentProgress != null) {
      _bloc.add(
        UpdateBookEvent(
          params: UpdateBookParams(
            bookId: _book!.isarId,
            title: _book!.title,
            author: _book!.author,
            currentPage: _currentProgress!.toInt(),
            coverImagePath: _book!.coverImagePath ?? '',
            isCoverImageChange: false,
          ),
        ),
      );
    }
    if (_serverBook != null && _currentProgress != null) {
      _bloc.add(
        UpdateServerProgressEvent(
          progress: _currentProgress!,
          bookId: widget.bookId.serverId!,
          totalChunks: _serverBook!.totalChunks,
        ),
      );
    }
    _isBionicEnabled.dispose();
    _uiHideTimer?.cancel();
    super.dispose();
  }

  void _startBionicFadeIn() {
    if (_isBionicEnabled.value != true) _isBionicEnabled.value = true;
  }

  void _startBionicFadeOut() {
    if (_isBionicEnabled.value != false) _isBionicEnabled.value = false;
  }

  void _handleBionicMode() {
    if (_isBionicEnabled.value == true) {
      _startBionicFadeOut();
    } else {
      _startBionicFadeIn();
    }
  }

  void _startHideTimer() {
    _uiHideTimer?.cancel();
    _uiHideTimer = Timer(const Duration(seconds: 4), () {
      if (!mounted) return;

      setState(() {
        if (_uiState == ReaderUiStates.controlsVisible) {
          _uiState = ReaderUiStates.idle;
        } else if (_uiState == ReaderUiStates.focusExitReveal) {
          _uiState = ReaderUiStates.focusMode;
        }
      });
    });
  }

  void _handleTap() {
    setState(() {
      switch (_uiState) {
        case ReaderUiStates.idle:
          _bookError || _readerError
              ? null
              : _uiState = ReaderUiStates.controlsVisible;
          _startHideTimer();
          break;
        case ReaderUiStates.controlsVisible:
          _uiState = ReaderUiStates.idle;
          _uiHideTimer?.cancel();
          break;
        case ReaderUiStates.focusMode:
          _uiState = ReaderUiStates.focusExitReveal;
          _startHideTimer();
          break;
        case ReaderUiStates.focusExitReveal:
          _uiState = ReaderUiStates.focusMode;
          _uiHideTimer?.cancel();
          break;
        case ReaderUiStates.focusTransitionIn:
          break;
        case ReaderUiStates.focusTransitionOut:
          break;
        case ReaderUiStates.bionicFadeIn:
          break;
        case ReaderUiStates.bionicMode:
          break;
        case ReaderUiStates.bionicFadeOut:
          break;
        case ReaderUiStates.applyPreferences:
          break;
      }
    });
  }

  bool _handleScroll(UserScrollNotification notification) {
    if (_uiState == ReaderUiStates.controlsVisible) {
      setState(() {
        _uiState = ReaderUiStates.idle;
        _uiHideTimer?.cancel();
      });
    }
    return false;
  }

  void _startFocusTransition() {
    setState(() {
      _uiState = ReaderUiStates.focusTransitionIn;
      _uiHideTimer?.cancel();
    });
  }

  void _startFocusOutTransition() {
    setState(() {
      _uiState = ReaderUiStates.focusTransitionOut;
      _uiHideTimer?.cancel();
    });
  }

  void _startEditAnimation() async {
    setState(() => _uiState = ReaderUiStates.applyPreferences);
  }

  void _openPreferencesSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<ReaderPreferencesCubit>(),
        child: ReaderPreferencesSheet(onApply: () => _startEditAnimation()),
      ),
    );
  }

  Color _getReaderBgColor(ReaderPreferencesState state) {
    return switch (state.theme) {
      ReaderTheme.light => AppColors.lightBgPrimary,
      ReaderTheme.dark => AppColors.darkBgPrimary,
      ReaderTheme.system => switch (state.bgColor) {
        ReaderBgColor.cream => AppColors.cream,
        ReaderBgColor.warm => AppColors.warm,
        ReaderBgColor.white => AppColors.white,
        ReaderBgColor.dark => AppColors.dark,
      },
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final bool showControls = _uiState == ReaderUiStates.controlsVisible;
    final bool showExitHint = _uiState == ReaderUiStates.focusExitReveal;

    return BlocBuilder<ReaderPreferencesCubit, ReaderPreferencesState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: _handleTap,
          child: Scaffold(
            backgroundColor: _getReaderBgColor(state),
            body: SafeArea(
              child: Stack(
                children: [
                  /// Bloc Listener
                  BlocListener<ReaderBloc, ReaderState>(
                    listener: (context, state) {
                      if (state is FetchLocalBookSuccess) {
                        if (state.book.paragraphs.isEmpty) {
                          setState(() {
                            _uiState = ReaderUiStates.idle;
                            _bookError = true;
                          });
                        } else {
                          setState(() {
                            _paragraphs = state.book.paragraphs;
                            _book = state.book;
                            _currentProgress = state.book.progress.toDouble();
                          });
                        }
                      }
                      if (state is FetchServerBookSuccess) {
                        setState(() {
                          _serverBook = state.book;
                          _paragraphs = state.paragraphs;
                        });

                        /// عشان نتاكد ان الكتاب جه مالسيرفر الاول initState مكتبناش الريكويست دي في ال
                        context.read<ReaderBloc>().add(
                          FetchProgressEvent(
                            bookId: widget.bookId.serverId!,
                            totalChunks: _serverBook!.totalChunks,
                          ),
                        );
                      }
                      if (state is FetchProgressSuccess) {
                        setState(() => _currentProgress = state.progress);
                      }
                      if (state is ReaderFailure) {
                        setState(() {
                          _readerError = true;
                          _uiState = ReaderUiStates.idle;
                        });
                      }
                    },
                    child: SizedBox(),
                  ),

                  BlocBuilder<ReaderBloc, ReaderState>(
                    builder: (context, state) {
                      bool isLoading = state is ReaderLoading;
                      return AnimatedSwitcher(
                        duration: AppDuration.slow,
                        child: isLoading
                            ? buildSkeletonizerReaderEffect()
                            : SizedBox(key: ValueKey('sized box')),
                      );
                    },
                  ),

                  /// Reader Surface
                  NotificationListener<UserScrollNotification>(
                    onNotification: _handleScroll,
                    child: _paragraphs.isEmpty || _currentProgress == null
                        ? SizedBox.shrink()
                        : ReaderSurface(
                            paragraphs: _paragraphs,
                            bookTitle: _book?.title ?? _serverBook?.title ?? '',
                            bookAuthor:
                                _book?.author ?? _serverBook?.author ?? '',
                            coverImage:
                                _book?.coverImagePath ??
                                _serverBook?.coverImage,
                            initialProgress: _currentProgress!,
                            bgColor: _getReaderBgColor(state),
                            uiState: _uiState,
                            isBionicNotifier: _isBionicEnabled,
                            state: state,
                            updateProgress: (double progress) {
                              _currentProgress = progress;
                              print(' Progress : ${progress.round()}');
                            },
                            isFocusMode:
                                _uiState == ReaderUiStates.focusExitReveal ||
                                _uiState == ReaderUiStates.focusMode,
                          ),
                  ),

                  // 3. Top Bar
                  Positioned(
                    top: 10.h,
                    left: 20.w,
                    right: 20.w,
                    child: IgnorePointer(
                      ignoring: !showControls,
                      child: AnimatedSlide(
                        curve: Curves.easeInOutCubic,
                        duration: AppDuration.slow,
                        offset: showControls ? Offset.zero : Offset(0, -1),
                        child: AnimatedOpacity(
                          opacity: showControls ? 1.0 : 0.0,
                          duration: AppDuration.slow,
                          child: BuildTopBar(
                            bookTitle: _book?.title ?? _serverBook?.title ?? '',
                            bookAuthor:
                                _book?.author ?? _serverBook?.author ?? '',
                            state: state,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // 4. Bottom Actions
                  Positioned(
                    bottom: 10.h,
                    left: 20.w,
                    right: 20.w,
                    child: IgnorePointer(
                      ignoring: !showControls,
                      child: AnimatedSlide(
                        curve: Curves.easeInOutCubic,
                        duration: AppDuration.slow,
                        offset: showControls ? Offset.zero : Offset(0, 1),
                        child: AnimatedOpacity(
                          opacity: showControls ? 1.0 : 0.0,
                          duration: AppDuration.slow,
                          child: BuildBottomActions(
                            callBack: (int i) {
                              if (i == 0) _openPreferencesSheet();
                              if (i == 1) _startFocusTransition();
                              if (i == 3) _handleBionicMode();
                            },
                            state: state,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // 5. Exit Focus Hint (Tiny Control)
                  Positioned(
                    bottom: 40.h,
                    left: 0,
                    right: 0,
                    child: IgnorePointer(
                      ignoring: !showExitHint,
                      child: AnimatedOpacity(
                        opacity: showExitHint ? 1.0 : 0.0,
                        duration: AppDuration.normal,
                        child: Center(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: _startFocusOutTransition,

                              borderRadius: AppRadius.xxl,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppSpacing.lg,
                                  vertical: AppSpacing.sm,
                                ),
                                decoration: BoxDecoration(
                                  color: _getReaderBgColor(state),
                                  borderRadius: AppRadius.xxl,
                                  border: Border.all(
                                    color: theme.onSurface.withValues(
                                      alpha: 0.1,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    HugeIcon(
                                      icon: HugeIcons.strokeRoundedMoon02,
                                      size: 18.sp,
                                      color: theme.secondary,
                                    ),
                                    SizedBox(width: AppSpacing.sm),
                                    Text(
                                      "Exit Focus",
                                      style: AppTextStyles.bodyMedium(
                                        context,
                                      ).copyWith(color: theme.secondary),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  /// transition Overlay
                  AnimatedSwitcher(
                    duration: AppDuration.readerGlow,
                    switchInCurve: Curves.easeIn,
                    switchOutCurve: Curves.easeOut,
                    child: switch (_uiState) {
                      ReaderUiStates.focusTransitionIn => TextAnimation(
                        key: const ValueKey('focus_in_animation'),
                        callBack: () {
                          setState(() {
                            _uiState = ReaderUiStates.focusMode;
                          });
                        },
                        messages: const [
                          'Clearing the noise.',
                          'Slowing down.',
                          'Just you. And the story.',
                        ],
                      ),
                      ReaderUiStates.focusTransitionOut => TextAnimation(
                        key: const ValueKey('focus_out_animation'),
                        callBack: () => setState(() {
                          _uiState = ReaderUiStates.controlsVisible;
                          _startHideTimer();
                        }),
                        messages: const [
                          'Leaving the pages.',
                          'Hold onto the feeling.',
                          'See you soon.',
                        ],
                      ),
                      ReaderUiStates.applyPreferences => TextAnimation(
                        key: ValueKey("Preferences"),
                        callBack: () =>
                            setState(() => _uiState = ReaderUiStates.idle),
                        messages: const ['applying Your Own Preferences...'],
                      ),
                      ReaderUiStates.idle => SizedBox(),
                      ReaderUiStates.controlsVisible => SizedBox(),
                      ReaderUiStates.bionicFadeIn => SizedBox(),
                      ReaderUiStates.bionicMode => SizedBox(),
                      ReaderUiStates.bionicFadeOut => SizedBox(),
                      ReaderUiStates.focusMode => SizedBox(),
                      ReaderUiStates.focusExitReveal => SizedBox(),
                    },
                  ),

                  /// Error State for Bloc reader Failure
                  if (_readerError)
                    AnimatedOpacity(
                      opacity: _readerError ? 1 : 0,
                      duration: AppDuration.slow,
                      curve: Curves.easeInOutCubic,
                      child: StaggerdAnimation(
                        index: 0,
                        child: AppError(
                          title: "Couldn't Open Your Book",
                          subtitle:
                              "Something went wrong while loading. Please try again.",
                          image: AppAssets.bookWithGlasses,
                          // textColor: _getTextColor(state, context),
                        ),
                      ),
                    ),

                  /// Back Button appears in every error state
                  if (_bookError || _readerError)
                    Positioned(
                      top: 10.h,
                      left: 20.w,
                      child: _errorBackButton(context: context, theme: theme),
                    ),

                  /// Error State for empty paragraphs
                  if (_bookError)
                    AnimatedOpacity(
                      opacity: _bookError ? 1 : 0,
                      duration: AppDuration.slow,
                      curve: Curves.easeInOutCubic,
                      child: StaggerdAnimation(
                        index: 0,
                        child: AppError(
                          title: "This Book Has No Content",
                          subtitle:
                              "We couldn't read any text from this file. It may be unsupported or corrupted.",
                          image: AppAssets.bookWithGlasses,
                          // textColor: _getTextColor(state, context),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget _errorBackButton({
  required BuildContext context,
  required ColorScheme theme,
}) => Material(
  color: Colors.transparent,
  child: InkWell(
    onTap: () => context.pop(),
    customBorder: CircleBorder(),
    child: Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.secondary.withValues(alpha: 0.1),
      ),
      padding: EdgeInsets.all(AppSpacing.sm),
      child: HugeIcon(
        icon: AppIcons.back,
        color: theme.secondary.withValues(alpha: 0.7),
        // getIconsFgColor(state: state, context: context, theme: theme),
      ),
    ),
  ),
);

Widget buildSkeletonizerReaderEffect() => Skeletonizer(
  enabled: true,
  effect: ShimmerEffect(),
  child: ListView.builder(
    key: const ValueKey('loading'),
    physics: const NeverScrollableScrollPhysics(),
    padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxl, vertical: 100.h),
    itemCount: 15,
    itemBuilder: (context, index) {
      return Padding(
        padding: EdgeInsets.only(bottom: AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ' *
                  2,
              style: TextStyle(fontSize: 16.sp, height: 1.8),
            ),
            Text(
              'Ut enim ad minim veniam, quis nostrud exercitation.',
              style: TextStyle(fontSize: 16.sp, height: 1.8),
            ),
          ],
        ),
      );
    },
  ),
);
