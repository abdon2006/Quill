import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/theme/app_colors.dart';
import 'package:quill/core/theme/app_duration.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';
import 'package:quill/core/widgets/premium_background.dart';
import 'package:quill/features/home/presentation/bloc/home_bloc.dart';
import 'package:quill/features/home/presentation/bloc/home_event.dart';
import 'package:quill/features/reader/domain/usecases/params/reader_book_params.dart';
import 'package:quill/features/reader/presentation/bloc/reader_bloc.dart';
import 'package:quill/features/reader/presentation/bloc/reader_event.dart';
import 'package:quill/features/reader/presentation/bloc/reader_state.dart';
import 'package:quill/features/reader/presentation/widgets/reader/build_bottom_actions.dart';
import 'package:quill/features/reader/presentation/widgets/reader/build_top_bar.dart';
import 'package:quill/features/reader/presentation/widgets/reader/reader_surface.dart';
import 'package:quill/features/reader/presentation/widgets/reader/text_animation.dart';

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
  String _bookTitle = '';
  ReaderUiStates _uiState = ReaderUiStates.controlsVisible;
  Timer? _uiHideTimer;

  @override
  void initState() {
    super.initState();
    _startHideTimer();

    if (widget.bookId.localId == null) {
      context.read<HomeBloc>().add(
        GetBookByIdEvent(bookId: widget.bookId.serverId!),
      );
    } else {
      context.read<ReaderBloc>().add(
        FetchLocalBookEvent(bookId: widget.bookId.localId!),
      );
    }
  }

  @override
  void dispose() {
    _isBionicEnabled.dispose();
    _uiHideTimer?.cancel();
    super.dispose();
  }

  void _startBionicFadeIn() {
    print('----- Bionic ON -------');
    if (_isBionicEnabled.value != true) _isBionicEnabled.value = true;
  }

  void _startBionicFadeOut() {
    print('----- Bionic OFF -------');
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
          _uiState = ReaderUiStates.controlsVisible;
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBgPrimary : AppColors.lightBgPrimary;
    final bool showControls = _uiState == ReaderUiStates.controlsVisible;
    final bool isFocusDeep =
        _uiState == ReaderUiStates.focusMode ||
        _uiState == ReaderUiStates.focusExitReveal;
    final bool showExitHint = _uiState == ReaderUiStates.focusExitReveal;

    return PremiumAuroraBackground(
      child: GestureDetector(
        onTap: _handleTap,
        child: Scaffold(
          backgroundColor: isFocusDeep ? Colors.transparent : bgColor,
          body: SafeArea(
            child: Stack(
              children: [
                BlocListener<ReaderBloc, ReaderState>(
                  listener: (context, state) {
                    if (state is FetchLocalBookSuccess && _paragraphs.isEmpty) {
                      setState(() {
                        _paragraphs = state.book.paragraphs;
                        _bookTitle = state.book.title;
                      });
                    }
                  },
                  child: SizedBox(),
                ),
                // BlocBuilder<HomeBloc, HomeState>(
                //   builder: (context, state) {
                //     if (state is GetBookByIdSuccess) {
                //       return ListView(
                //         padding: EdgeInsets.symmetric(
                //           horizontal: AppSpacing.xxl,
                //           vertical: AppSpacing.xl,
                //         ),
                //         children: [],
                //       );
                //     }
                //     return const SizedBox();
                //   },
                // ),
                NotificationListener<UserScrollNotification>(
                  onNotification: _handleScroll,
                  child: _paragraphs.isEmpty
                      ? SizedBox()
                      : ReaderSurface(
                          paragraphs: _paragraphs,
                          isBionicNotifier: _isBionicEnabled,
                        ),
                ),

                // 3. Top Bar
                Positioned(
                  top: 10.h,
                  left: 20.w,
                  right: 20.w,
                  child: IgnorePointer(
                    ignoring: !showControls,
                    child: AnimatedOpacity(
                      opacity: showControls ? 1.0 : 0.0,
                      duration: AppDuration.normal,
                      child: BuildTopBar(title: _bookTitle),
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
                    child: AnimatedOpacity(
                      opacity: showControls ? 1.0 : 0.0,
                      duration: AppDuration.normal,
                      child: BuildBottomActions(
                        callBack: (int i) {
                          if (i == 1) _startFocusTransition();
                          if (i == 3) _handleBionicMode();
                        },
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
                                color: theme.surface.withValues(alpha: 0.9),
                                borderRadius: AppRadius.xxl,
                                border: Border.all(
                                  color: theme.onSurface.withValues(alpha: 0.1),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  HugeIcon(
                                    icon: HugeIcons.strokeRoundedMoon02,
                                    size: 18.sp,
                                    color: theme.primary,
                                  ),
                                  SizedBox(width: AppSpacing.sm),
                                  Text(
                                    "Exit Focus",
                                    style: AppTextStyles.bodyMedium(
                                      context,
                                    ).copyWith(color: theme.primary),
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
                  child: _uiState == ReaderUiStates.focusTransitionIn
                      ? TextAnimation(
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
                        )
                      : _uiState == ReaderUiStates.focusTransitionOut
                      ? TextAnimation(
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
                        )
                      : const SizedBox.shrink(key: ValueKey('empty_box')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
