

// ignore_for_file: use_build_context_synchronously, unused_field

import 'package:flutter/foundation.dart' as foundation show compute;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quill/core/theme/app_colors.dart';
import 'package:quill/core/theme/app_duration.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';
import 'package:quill/features/reader/presentation/cubit/reader_preferences_state.dart';
import 'package:quill/features/reader/presentation/screens/reader_screen.dart';
import 'package:quill/features/reader/presentation/widgets/reader/bottom_dock.dart';
import 'package:quill/features/reader/presentation/widgets/reader/milestone_notch.dart';
import 'package:quill/features/reader/presentation/widgets/reader/overlay_gradient.dart';
import 'package:quill/features/reader/presentation/widgets/reader/reader_header.dart';
import 'package:quill/features/reader/presentation/widgets/reader/text_animation.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ReaderSurface extends StatefulWidget {
  final List<String> paragraphs;
  final ReaderPreferencesState state;
  final ValueNotifier<bool> isBionicNotifier;

  final String bookTitle;
  final String bookAuthor;
  final double initialProgress;
  final String? coverImage;

  final void Function(int) updateProgress;
  final bool isFocusMode;
  final Color bgColor;
  final ReaderUiStates uiState;

  final void Function(int) sendCurrentPage;
  final void Function(int) sendTotalPages;
  final ValueNotifier<int> jumpToPageNotifier;

  const ReaderSurface({
    super.key,
    required this.paragraphs,
    required this.isBionicNotifier,
    required this.state,
    required this.updateProgress,
    required this.isFocusMode,
    required this.bgColor,
    required this.uiState,
    required this.initialProgress,
    required this.bookTitle,
    required this.bookAuthor,
    this.coverImage,
    required this.sendCurrentPage,
    required this.sendTotalPages,
    required this.jumpToPageNotifier,
  });

  @override
  State<ReaderSurface> createState() => _ReaderSurfaceState();
}

class _ReaderSurfaceState extends State<ReaderSurface>
    with SingleTickerProviderStateMixin {
  BionicCache? _cache;
  bool _cacheReady = false;
  int? initialCell;
  CellCache? _pages;

  bool _cacheError = false;
  bool _pagesError = false;

  bool isAnimationReady = false;
  String _currentMessage = '';
  int _currentMilestonePercentage = 0;
  final Map<int, String> _milestones = {
    10: 'Settling into the story',
    25: "The journey unfolds",
    50: "Deep in the narrative",
    75: "Getting closer to the truth",
    90: "The final stretch",
    100: "A journey completed",
  };
  final Map<int, String> _achievedMilestones = {};
  late AnimationController _animationController;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;

  final ItemScrollController scrollController = ItemScrollController();
  final ItemPositionsListener listener = ItemPositionsListener.create();

  void _startMilestoneAnimation({
    required String message,
    required int progress,
  }) async {
    setState(() {
      _currentMessage = message;
      _currentMilestonePercentage = progress;
    });
    _animationController.forward();
    await Future.delayed(AppDuration.cue);
    if (mounted) _animationController.reverse();
  }

  void _initMilestones() {
    final savedPrgress = widget.initialProgress;
    for (final i in _milestones.keys) {
      if (savedPrgress >= i) _achievedMilestones[i] = _milestones[i]!;
    }
  }

  @override
  void didUpdateWidget(covariant ReaderSurface oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state.scrollMode != widget.state.scrollMode &&
        widget.state.scrollMode == ReaderScrollMode.scroll) {
      widget.updateProgress((initialCell! / _cache!.cellCount * 100).ceil());
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          scrollController.scrollTo(
            index: initialCell!,
            duration: AppDuration.readerGlow,
            curve: Curves.easeInOutCubic,
          );
        }
      });
    }

    if (oldWidget.state.fontSize != widget.state.fontSize ||
        oldWidget.state.lineSpacing != widget.state.lineSpacing) {
      if (widget.state.scrollMode == ReaderScrollMode.pages) {
        _loadPages(widget.state.fontSize);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: AppDuration.readerGlow,
    );
    _slide = Tween<Offset>(begin: Offset(0, -2), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutCubic,
        reverseCurve: Curves.easeInQuart,
      ),
    );
    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn,
      ),
    );

    _initMilestones();

    
    widget.jumpToPageNotifier.addListener(_handleScrollJump);

    listener.itemPositions.addListener(() {
      final positions = listener.itemPositions.value;
      if (positions.isEmpty || _cache == null) return;

      final minIndex = positions
          .where((p) => p.itemTrailingEdge > 0)
          .map((p) => p.index)
          .reduce((a, b) => a < b ? a : b);

      final currentCell = (minIndex - 1).clamp(0, _cache!.cellCount - 1);

      initialCell = currentCell;
      final progress = (currentCell / _cache!.cellCount * 100).ceil();

      for (var i in _milestones.entries) {
        final target = i.key;
        final message = i.value;
        if (progress >= target && !_achievedMilestones.containsKey(target)) {
          _achievedMilestones[target] = message;
          _startMilestoneAnimation(message: message, progress: target);
        }
      }

      
      if (_pages != null) {
        final pageIndex = _pages!.pages.indexWhere(
          (p) => p.contains(currentCell),
        );
        if (pageIndex != -1) widget.sendCurrentPage(pageIndex);
      }

      widget.updateProgress(progress);
    });

    _loadCache();
  }

  
  void _handleScrollJump() {
    if (widget.state.scrollMode == ReaderScrollMode.scroll) {
      final targetPage = widget.jumpToPageNotifier.value;
      if (targetPage != -1 &&
          _pages != null &&
          targetPage < _pages!.pages.length) {
        final targetCell = _pages!.pages[targetPage].first;
        scrollController.scrollTo(
          index: targetCell + 1, 
          duration: AppDuration.readerGlow,
          curve: Curves.easeInOutCubic,
        );
      }
    }
  }

  Future<void> _loadCache() async {
    if (widget.paragraphs.isEmpty) {
      setState(() => _cacheError = true);
      return;
    }
    final cache = await BionicCache.compute(widget.paragraphs);

    if (!mounted) return;
    setState(() {
      _cache = cache;
      _cacheReady = true;
    });

    final savedIndex = (widget.initialProgress / 100 * _cache!.cellCount)
        .toInt();
    setState(() => initialCell = savedIndex);

    await _loadPages();

    await Future.delayed(AppDuration.micro);
    if (!mounted) return;

    if (widget.state.scrollMode == ReaderScrollMode.scroll) {
      scrollController.scrollTo(
        index: savedIndex,
        duration: AppDuration.readerGlow,
        curve: Curves.easeInOutCubic,
      );
    }
  }

  Future<void> _loadPages([double? newFontSize]) async {
    if (_cache == null || _cache!.cellCount == 0) {
      setState(() => _pagesError = true);
      return;
    }
    setState(() => _pages = null);
    await Future.delayed(AppDuration.frame);

    final textScalar = MediaQuery.textScalerOf(context).scale(1.0);
    final safeArea = MediaQuery.of(context).padding;
    final pageHeight =
        MediaQuery.of(context).size.height -
        safeArea.top -
        safeArea.bottom -
        (AppSpacing.lg * 2);

    final pageWidth = MediaQuery.of(context).size.width - (AppSpacing.xxl * 2);

    final params = PageLayoutParams(
      cellText: _cache!._cellTexts,
      pageHeight: pageHeight,
      pageWidth: pageWidth,
      fontSize: (newFontSize ?? widget.state.fontSize),
      lineSpacing: widget.state.lineSpacing,
      textScalarFactor: textScalar,
      fontFamily: widget.state.fontFamily.fontName,
      isBold: widget.state.isBold,
      isItalic: widget.state.isItalic,
      isJustified: widget.state.isJustified,
    );

    final result = await CellCache.compute(params);

    if (!mounted) return;

    if (result.extraCells.isNotEmpty) {
      _cache!._addExtraCells(result.extraCells);
    }

    setState(() => _pages = result.cache);

    
    widget.sendTotalPages(result.cache.pages.length);

    await Future.delayed(AppDuration.micro);
  }

  @override
  Widget build(BuildContext context) {
    final cellCount = _cache?.cellCount ?? 0;
    final theme = Theme.of(context).colorScheme;
    return Stack(
      children: [
        AnimatedSwitcher(
          duration: Duration.zero,
          child: widget.state.scrollMode == ReaderScrollMode.scroll
              ? AnimatedSwitcher(
                  duration: AppDuration.slow,
                  child: _pages != null
                      ? AnimatedOpacity(
                          key: const ValueKey('scroll_list_view'),
                          duration: AppDuration.slow,
                          opacity: _pages != null ? 1 : 0,
                          child: ScrollablePositionedList.builder(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.xxl,
                            ),
                            addAutomaticKeepAlives: false,
                            addRepaintBoundaries: true,
                            itemScrollController: scrollController,
                            itemPositionsListener: listener,
                            itemCount: cellCount + 1,
                            itemBuilder: (context, i) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppSpacing.lg,
                                ),
                                child: i == 0
                                    ? Column(
                                        children: [
                                          SizedBox(height: 70.h),
                                          ReaderHeader(
                                            state: widget.state,
                                            title: widget.bookTitle,
                                            author: widget.bookAuthor,
                                            coverImage: widget.coverImage,
                                          ),
                                        ],
                                      )
                                    : _BionicCell(
                                        text: _cache!.cellText(i - 1),
                                        isBionicNotifier:
                                            widget.isBionicNotifier,
                                        cache: _cache!,
                                        index: i - 1,
                                        ready: _cacheReady,
                                        state: widget.state,
                                      ),
                              );
                            },
                          ),
                        )
                      : TextAnimation(
                          key: const ValueKey('text_animation'),
                          callBack: () {},
                          messages: const [
                            'just one step...',
                            'getting Book Ready For You...',
                            'Writing The Last Words...',
                            'Book Is Ready Now.',
                          ],
                        ),
                )
              : AnimatedSwitcher(
                  duration: AppDuration.slow,
                  child: _pages == null
                      ? widget.uiState == ReaderUiStates.applyPreferences
                            ? null
                            : TextAnimation(
                                key: const ValueKey('loading_animation'),
                                callBack: () {},
                                messages: const [
                                  'just one step...',
                                  'getting Book Ready For You...',
                                  'Writing The Last Words...',
                                  'Book Is Ready Now.',
                                ],
                              )
                      : CellPageView(
                          key: ValueKey(_pages),
                          state: widget.state,
                          cache: _pages!,
                          bionicCache: _cache!,
                          isBionicNotifier: widget.isBionicNotifier,
                          totalCells: cellCount,
                          updateOnSwipe: (int progress) =>
                              widget.updateProgress(progress),
                          initialCellIndex: initialCell!,
                          onPageChanged: (int newCell) => initialCell = newCell,
                          isFocusMode: widget.isFocusMode,
                          sendCurrentPage: (int page) =>
                              widget.sendCurrentPage(page),
                          sendTotalPages: (int totalPages) =>
                              widget.sendTotalPages(totalPages),
                          jumpToPageNotifier: widget.jumpToPageNotifier,
                        ),
                ),
        ),

        
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: AnimatedOpacity(
            opacity: widget.isFocusMode ? 1.0 : 0.0,
            duration: AppDuration.normal,
            child: overlayGradient(
              theme: theme,
              isTop: false,
              bgColor: widget.bgColor,
            ),
          ),
        ),

        
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          child: AnimatedOpacity(
            opacity: widget.isFocusMode ? 1.0 : 0.0,
            duration: AppDuration.normal,
            child: overlayGradient(
              theme: theme,
              isTop: true,
              bgColor: widget.bgColor,
            ),
          ),
        ),

        if (widget.state.scrollMode == ReaderScrollMode.scroll)
          milestoneNotch(
            context: context,
            slide: _slide,
            opacity: _opacity,
            theme: theme,
            currentMessage: _currentMessage,
            currentProgress: _currentMilestonePercentage,
          ),
      ],
    );
  }
}

class _BionicCell extends StatelessWidget {
  final String text;
  final ValueNotifier<bool> isBionicNotifier;
  final BionicCache cache;
  final int index;
  final bool ready;
  final ReaderPreferencesState state;

  const _BionicCell({
    required this.text,
    required this.isBionicNotifier,
    required this.cache,
    required this.index,
    required this.ready,
    required this.state,
  });

  Color _getTextColor(ReaderPreferencesState state) {
    return switch (state.theme) {
      ReaderTheme.dark => AppColors.darkTextPrimary,
      ReaderTheme.light => AppColors.lightTextPrimary,
      ReaderTheme.system =>
        state.bgColor == ReaderBgColor.dark
            ? AppColors.darkTextPrimary
            : AppColors.lightTextPrimary,
    };
  }

  @override
  Widget build(BuildContext context) {
    final normalStyle = AppTextStyles.defaultReading(context).copyWith(
      color: _getTextColor(state),
      fontSize: state.fontSize,
      height: state.lineSpacing,
      fontStyle: state.isItalic ? FontStyle.italic : FontStyle.normal,
      fontWeight: state.isBold ? FontWeight.bold : FontWeight.normal,
      fontFamily: switch (state.fontFamily) {
        ReaderFontFamily.plusJakartaSans =>
          ReaderFontFamily.plusJakartaSans.fontName,
        ReaderFontFamily.lora => ReaderFontFamily.lora.fontName,
        ReaderFontFamily.merriweather => ReaderFontFamily.merriweather.fontName,
      },
    );
    final boldStyle = normalStyle.copyWith(fontWeight: FontWeight.w800);

    return ValueListenableBuilder<bool>(
      valueListenable: isBionicNotifier,
      builder: (context, isBionic, _) {
        final spans = cache.spansFor(index, normalStyle, boldStyle);
        return AnimatedSwitcher(
          duration: AppDuration.normal,
          child: (!isBionic || !ready)
              ? Text(
                  key: const ValueKey('Standard'),
                  text,
                  style: normalStyle,
                  textAlign: state.isJustified
                      ? TextAlign.justify
                      : TextAlign.start,
                )
              : RichText(
                  key: const ValueKey('Bionic'),
                  textAlign: state.isJustified
                      ? TextAlign.justify
                      : TextAlign.start,
                  text: TextSpan(children: spans),
                ),
        );
      },
    );
  }
}


class CellPageView extends StatefulWidget {
  final CellCache cache;
  final BionicCache bionicCache;
  final ReaderPreferencesState? state;
  final ValueNotifier<bool> isBionicNotifier;
  final int totalCells;
  final void Function(int) updateOnSwipe;
  final int initialCellIndex;
  final void Function(int) onPageChanged;
  final bool isFocusMode;
  final void Function(int) sendCurrentPage;
  final void Function(int) sendTotalPages;
  final ValueNotifier<int> jumpToPageNotifier;

  const CellPageView({
    super.key,
    this.state,
    required this.cache,
    required this.bionicCache,
    required this.isBionicNotifier,
    required this.totalCells,
    required this.updateOnSwipe,
    required this.initialCellIndex,
    required this.onPageChanged,
    required this.isFocusMode,
    required this.sendCurrentPage,
    required this.sendTotalPages,
    required this.jumpToPageNotifier,
  });

  @override
  State<CellPageView> createState() => _CellPageViewState();
}

class _CellPageViewState extends State<CellPageView>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  int? _outgoingIndex;
  bool _nextIsForward = true;
  String _dockMessage = '';
  int _totalParts = 5;
  int _currentPart = 1;
  bool _isDockExpanded = false;
  late AnimationController _controller;
  late Animation<Offset> _inAnimation;
  late Animation<Offset> _outAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDuration.quickShift,
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _outgoingIndex = null);
        _controller.reset();
      }
    });

    currentIndex = widget.cache.pages.indexWhere(
      (page) => page.contains(widget.initialCellIndex),
    );
    if (currentIndex < 0) currentIndex = 0;

    widget.jumpToPageNotifier.addListener(_handlePageJump);
    _initDockCalculations();
    _handleMilestoneOnSwipe(_currentPart);
    widget.sendCurrentPage(currentIndex);
    widget.sendTotalPages(widget.cache.pages.length);
  }

  int _calculateProgress(int pageIndex) {
    if (pageIndex == widget.cache.pages.length - 1) {
      return 100;
    }
    final firstCell = widget.cache.pages[pageIndex].first;
    return ((firstCell / widget.totalCells) * 100).ceil();
  }

  void _initDockCalculations() {
    final pagesLength = widget.cache.pages.length;
    _totalParts = (pagesLength > 50 ? 10 : 5);
    _currentPart = _calculatePart();
  }

  int _calculatePart() {
    final pagesLength = widget.cache.pages.length;
    if (pagesLength <= 1) return 1;
    double percent = currentIndex / (pagesLength - 1);
    int part = (percent * _totalParts).ceil();
    return part == 0 ? 1 : part;
  }

  void _handleMilestoneOnSwipe(int part) async {
    setState(() {
      _dockMessage = 'Part $part of $_totalParts';
      _isDockExpanded = true;
    });
    await Future.delayed(AppDuration.ambient);
    if (mounted) setState(() => _isDockExpanded = false);
  }

  void _goToPage(bool isNext) {
    if (_outgoingIndex != null) return;
    if (isNext && currentIndex >= widget.cache.pages.length - 1) return;
    if (!isNext && currentIndex <= 0) return;

    final nextIndex = isNext ? currentIndex + 1 : currentIndex - 1;

    setState(() {
      _nextIsForward = isNext;
      _outgoingIndex = currentIndex;
      currentIndex = nextIndex;

      
      
      _inAnimation =
          Tween<Offset>(
            begin: isNext ? const Offset(0.05, 0) : const Offset(-0.05, 0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
          );

      _outAnimation =
          Tween<Offset>(
            begin: Offset.zero,
            end: isNext ? const Offset(-0.05, 0) : const Offset(0.05, 0),
          ).animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
          );
    });

    final firstCell = widget.cache.pages[currentIndex].first;
    final progress = _calculateProgress(currentIndex);
    widget.updateOnSwipe(progress);
    widget.onPageChanged(firstCell);
    widget.sendCurrentPage(currentIndex);

    final int newPart = _calculatePart();
    if (newPart != _currentPart) {
      _currentPart = newPart;
      _handleMilestoneOnSwipe(newPart);
    }

    _controller.forward();
  }

  Widget _buildPageContent(int index) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      children: widget.cache.pages[index]
          .map(
            (i) => _BionicCell(
              text: widget.bionicCache.cellText(i),
              isBionicNotifier: widget.isBionicNotifier,
              cache: widget.bionicCache,
              index: i,
              ready: true,
              state: widget.state!,
            ),
          )
          .toList(),
    );
  }

  @override
  void dispose() {
    widget.jumpToPageNotifier.removeListener(_handlePageJump);
    super.dispose();
  }

  void _handlePageJump() {
    final targetPage = widget.jumpToPageNotifier.value;
    if (targetPage == -1 || targetPage == currentIndex) return;

    if (targetPage >= 0 && targetPage < widget.cache.pages.length) {
      setState(() {
        currentIndex = targetPage;
        _outgoingIndex = null;
      });

      final firstCell = widget.cache.pages[currentIndex].first;
      final progress = _calculateProgress(currentIndex);

      widget.updateOnSwipe(progress);
      widget.onPageChanged(firstCell);
      widget.sendCurrentPage(currentIndex);

      final int newPart = _calculatePart();
      if (newPart != _currentPart) {
        _currentPart = newPart;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Stack(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity! < 0) {
              _goToPage(true);
            } else {
              _goToPage(false);
            }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
            child: Stack(
              children: [
                
                if (_outgoingIndex != null)
                  SlideTransition(
                    position: _outAnimation,
                    child: FadeTransition(
                      opacity: Tween<double>(begin: 1, end: 0).animate(
                        CurvedAnimation(
                          parent: _controller,
                          curve: Curves.easeOut, 
                        ),
                      ),
                      child: _buildPageContent(_outgoingIndex!),
                    ),
                  ),
                
                SlideTransition(
                  position: _outgoingIndex != null
                      ? _inAnimation
                      : AlwaysStoppedAnimation(Offset.zero),
                  child: FadeTransition(
                    opacity: _outgoingIndex != null
                        ? Tween<double>(begin: 0, end: 1).animate(
                            CurvedAnimation(
                              parent: _controller,
                              curve: Curves.easeOut,
                            ),
                          )
                        : const AlwaysStoppedAnimation(1.0),
                    child: _buildPageContent(currentIndex),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (!widget.isFocusMode)
          bottomDock(
            context: context,
            isDockExpanded: _isDockExpanded,
            theme: theme,
            dockMessage: _dockMessage,
          ),
      ],
    );
  }
}

const int _cellMaxWords = 140;

List<(String, bool)> _processChunk(String text) {
  final matches = RegExp(r'\b\w+\b').allMatches(text);
  int lastMatchEnd = 0;
  final List<(String, bool)> result = [];
  for (final match in matches) {
    if (match.start > lastMatchEnd) {
      result.add((text.substring(lastMatchEnd, match.start), false));
    }
    final word = match.group(0)!;
    final len = word.length;
    final splitIndex = len <= 3 ? 1 : (len <= 7 ? (len ~/ 2) : (len ~/ 3));
    result.add((word.substring(0, splitIndex), true));
    result.add((word.substring(splitIndex), false));
    lastMatchEnd = match.end;
  }
  if (lastMatchEnd < text.length) {
    result.add((text.substring(lastMatchEnd), false));
  }
  return result;
}

List<String> _chunkIntoCells(String text) {
  final words = text.split(' ');
  final cells = <String>[];
  for (var start = 0; start < words.length; start += _cellMaxWords) {
    final end = (start + _cellMaxWords > words.length)
        ? words.length
        : start + _cellMaxWords;
    cells.add(words.sublist(start, end).join(' '));
  }
  return cells.isEmpty ? [text] : cells;
}

List<(String, List<(String, bool)>)> _processBookBatch(
  List<String> paragraphs,
) {
  final result = <(String, List<(String, bool)>)>[];
  for (final p in paragraphs) {
    for (final cell in _chunkIntoCells(p)) {
      result.add((cell, _processChunk(cell)));
    }
  }
  return result;
}

class BionicCache {
  final List<String> _cellTexts;
  final List<List<(String, bool)>?> _fragments;

  BionicCache._(this._cellTexts, this._fragments);

  static Future<BionicCache> compute(List<String> paragraphs) async {
    final rows = await foundation.compute(_processBookBatch, paragraphs);
    final texts = List<String>.generate(rows.length, (i) => rows[i].$1);
    final fragments = List<List<(String, bool)>?>.generate(
      rows.length,
      (i) => rows[i].$2,
    );
    return BionicCache._(texts, fragments);
  }

  int get cellCount => _cellTexts.length;
  String cellText(int index) => _cellTexts[index];

  void _addExtraCells(List<String> extras) {
    for (final text in extras) {
      _cellTexts.add(text);
      _fragments.add(_processChunk(text));
    }
  }

  List<TextSpan>? spansFor(int index, TextStyle normal, TextStyle bold) {
    if (index >= _fragments.length) return null;
    final fragments = _fragments[index];
    if (fragments == null) return null;
    return fragments
        .map((e) => TextSpan(text: e.$1, style: e.$2 ? bold : normal))
        .toList();
  }
}

class PageLayoutResult {
  final CellCache cache;
  final List<String> extraCells;

  const PageLayoutResult({required this.cache, required this.extraCells});
}

Future<List<Object>> _buildPageView(PageLayoutParams params) async {
  final List<List<int>> pages = [];
  final List<String> extraCells = [];
  List<int> currentPage = [];
  double currentHeight = 0;

  final allCells = List<String>.from(params.cellText);
  int i = 0;

  final stopwatch = Stopwatch()..start();

  while (i < allCells.length) {
    if (stopwatch.elapsedMilliseconds > 8) {
      await Future.delayed(Duration.zero);
      stopwatch.reset();
    }

    final painter = TextPainter(
      text: TextSpan(
        text: allCells[i],
        style: TextStyle(
          fontSize: params.fontSize,
          height: params.lineSpacing,
          fontFamily: params.fontFamily,
          fontWeight: params.isBold ? FontWeight.bold : FontWeight.normal,
          fontStyle: params.isItalic ? FontStyle.italic : FontStyle.normal,
        ),
      ),
      textAlign: params.isJustified ? TextAlign.justify : TextAlign.start,
      textScaler: TextScaler.linear(params.textScalarFactor),
      textDirection: TextDirection.ltr,
    );
    painter.layout(maxWidth: params.pageWidth);
    final cellHeight = painter.height;

    if (cellHeight > params.pageHeight) {
      final words = allCells[i].split(' ');
      final half = words.length ~/ 2;
      final firstHalf = words.sublist(0, half).join(' ');
      final secondHalf = words.sublist(half).join(' ');

      allCells[i] = firstHalf;

      allCells.insert(i + 1, secondHalf);
      extraCells.add(secondHalf);

      continue;
    }

    if (currentPage.isNotEmpty &&
        currentHeight + cellHeight > params.pageHeight) {
      pages.add(currentPage);
      currentPage = [];
      currentHeight = 0;
    }

    currentPage.add(i);
    currentHeight += cellHeight;
    i++;
  }

  if (currentPage.isNotEmpty) {
    pages.add(currentPage);
  }

  return [pages, extraCells];
}

class CellCache {
  final List<List<int>> pages;
  const CellCache({required this.pages});

  static Future<PageLayoutResult> compute(PageLayoutParams params) async {
    final result = await _buildPageView(params);
    final pages = result[0] as List<List<int>>;
    final extraCells = result[1] as List<String>;
    return PageLayoutResult(
      cache: CellCache(pages: pages),
      extraCells: extraCells,
    );
  }
}

class PageLayoutParams {
  final List<String> cellText;
  final double pageHeight;
  final double pageWidth;
  final double fontSize;
  final double lineSpacing;
  final double textScalarFactor;
  final String fontFamily;
  final bool isBold;
  final bool isItalic;
  final bool isJustified;

  const PageLayoutParams({
    required this.cellText,
    required this.pageHeight,
    required this.pageWidth,
    required this.fontSize,
    required this.lineSpacing,
    required this.textScalarFactor,
    required this.fontFamily,
    required this.isBold,
    required this.isItalic,
    required this.isJustified,
  });
}
