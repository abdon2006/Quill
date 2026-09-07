import 'package:flutter/foundation.dart' as foundation show compute;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quill/core/theme/app_colors.dart';
import 'package:quill/core/theme/app_duration.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';
import 'package:quill/features/reader/data/models/local_book.dart';
import 'package:quill/features/reader/presentation/cubit/reader_preferences_state.dart';
import 'package:quill/features/reader/presentation/widgets/reader/reader_header.dart';
import 'package:quill/features/reader/presentation/widgets/reader/text_animation.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ReaderSurface extends StatefulWidget {
  final List<String> paragraphs;
  final ReaderPreferencesState state;
  final ValueNotifier<bool> isBionicNotifier;
  final LocalBook book;
  final void Function(double) updateProgress;

  const ReaderSurface({
    super.key,
    required this.paragraphs,
    required this.isBionicNotifier,
    required this.book,
    required this.state,
    required this.updateProgress,
  });

  @override
  State<ReaderSurface> createState() => _ReaderSurfaceState();
}

class _ReaderSurfaceState extends State<ReaderSurface> {
  BionicCache? _cache;
  bool _cacheReady = false;
  bool _visible = false;
  CellCache? _pages;
  final ItemScrollController scrollController = ItemScrollController();
  final ItemPositionsListener listener = ItemPositionsListener.create();

  @override
  void initState() {
    super.initState();
    listener.itemPositions.addListener(() {
      final positions = listener.itemPositions.value;
      if (positions.isEmpty || _cache == null) return;
      final minIndex = positions
          .where((p) => p.itemTrailingEdge > 0)
          .map((p) => p.index)
          .reduce((a, b) => a < b ? a : b);
      final currentCell = (minIndex - 1).clamp(0, _cache!.cellCount - 1);
      final progress = currentCell / _cache!.cellCount * 100;
      widget.updateProgress(progress);
    });
    _loadCache();
  }

  Future<void> _loadCache() async {
    print('----------- load cache Called --------------');
    final cache = await BionicCache.compute(widget.paragraphs);

    if (!mounted) return;
    setState(() {
      _cache = cache;
      _cacheReady = true;
    });
    await _loadPages();

    await Future.delayed(const Duration(milliseconds: 50));
    if (!mounted) return;
    final savedIndex = (widget.book.progress / 100 * _cache!.cellCount).toInt();
    scrollController.scrollTo(
      index: savedIndex,
      duration: AppDuration.readerGlow,
      curve: Curves.easeInOutCubic,
    );
    setState(() => _visible = true);
  }

  Future<void> _loadPages() async {
    print('----------- load PAges Called --------------');
    final pages = await CellCache.compute(
      PageLayoutParams(
        cellText: _cache!._cellTexts,
        pageHeight: MediaQuery.heightOf(context),
        pageWidth: MediaQuery.widthOf(context) - AppSpacing.xxl,
        fontSize: widget.state.fontSize,
        lineSpacing: widget.state.lineSpacing,
      ),
    );
    if (!mounted) return;
    setState(() => _pages = pages);
    await Future.delayed(const Duration(milliseconds: 50));
  }

  @override
  Widget build(BuildContext context) {
    final cellCount = _cache?.cellCount ?? 0;
    final wordCount = cellCount * 140;
    final minutes = (wordCount / 200).toInt();
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    return Stack(
      children: [
        AnimatedSwitcher(
          duration: AppDuration.slow,
          child: widget.state.scrollMode == ReaderScrollMode.scroll
              ? ScrollablePositionedList.builder(
                  key: ValueKey(widget.state.scrollMode),
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                  addAutomaticKeepAlives: false,
                  addRepaintBoundaries: true,

                  itemScrollController: scrollController,
                  itemPositionsListener: listener,
                  itemCount: cellCount + 1,
                  itemBuilder: (context, i) {
                    return AnimatedOpacity(
                      duration: AppDuration.slow,
                      opacity: !_visible ? 0 : 1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.lg,
                        ),
                        child: i == 0
                            ? Column(
                                children: [
                                  SizedBox(height: 70.h),
                                  ReaderHeader(
                                    book: widget.book,
                                    hours: hours,
                                    mins: mins,
                                    state: widget.state,
                                  ),
                                ],
                              )
                            : _BionicCell(
                                text: _cache!.cellText(i - 1),
                                isBionicNotifier: widget.isBionicNotifier,
                                cache: _cache!,
                                index: i - 1,
                                ready: _cacheReady,
                                state: widget.state,
                              ),
                      ),
                    );
                  },
                )
              : _pages == null
              ? const SizedBox.shrink()
              : CellPageView(
                  state: widget.state,
                  cache: _pages!,
                  bionicCache: _cache!,
                  isBionicNotifier: widget.isBionicNotifier,
                  totalCells: cellCount,
                  updateOnSwipe: (double progress) =>
                      widget.updateProgress(progress),
                ),
        ),

        if (!_cacheReady)
          TextAnimation(
            callBack: () {},
            messages: ['just one step..', 'Book Ready For You'],
          ),
      ],
    );
  }
}

/// A single render cell (small, capped at ~140 words). Applies the bionic
/// RichText only when the toggle is on AND the cell is one of the few visible;
/// otherwise it shows a fast plain Text.
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
    // final isDark = Theme.of(context).brightness == Brightness.dark;
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
                  key: ValueKey('Standard'),
                  text,
                  style: normalStyle,
                  textAlign: state.isJustified
                      ? TextAlign.justify
                      : TextAlign.start,
                )
              : RichText(
                  key: ValueKey('Bionic'),
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

const int _cellMaxWords = 140;

List<(String, bool)> _processChunk(String text) {
  print('----------- _processChunk Called by processBookBatch --------------');
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
  print(
    '----------- _chunkIntoCells Called by processBookBatch --------------',
  );
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
  print('----------- processBookBatch Called by compute --------------');

  final result = <(String, List<(String, bool)>)>[];
  for (final p in paragraphs) {
    print('----------- Now in Paragraph : $p --------------');
    for (final cell in _chunkIntoCells(p)) {
      print('----------- Now in Cell : $cell --------------');
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
    print('----------- compute Method Called --------------');
    final rows = await foundation.compute(_processBookBatch, paragraphs);
    print('----------- result of the all computes : $rows -----------------');
    final texts = List<String>.generate(rows.length, (i) => rows[i].$1);
    print('----------- text of the all computes : $texts -----------------');

    final fragments = List<List<(String, bool)>?>.generate(
      rows.length,
      (i) => rows[i].$2,
    );
    print(
      '----------- fargments of the all computes : $fragments -----------------',
    );

    return BionicCache._(texts, fragments);
  }

  int get cellCount => _cellTexts.length;

  String cellText(int index) => _cellTexts[index];

  List<TextSpan>? spansFor(int index, TextStyle normal, TextStyle bold) {
    print(' =================== spans for called ===================');
    final fragments = _fragments[index];
    if (fragments == null) return null;
    return fragments
        .map((e) => TextSpan(text: e.$1, style: e.$2 ? bold : normal))
        .toList();
  }
}

List<List<int>> _buildPageView(PageLayoutParams params) {
  print('============== build Page View Called =================');
  final List<List<int>> pages = [];
  List<int> currentPage = [];
  double currentHeight = 0;
  for (int i = 0; i < params.cellText.length; i++) {
    final painter = TextPainter(
      text: TextSpan(
        text: params.cellText[i],
        style: TextStyle(fontSize: params.fontSize, height: params.lineSpacing),
      ),
      textDirection: TextDirection.ltr,
    );
    painter.layout(maxWidth: params.pageWidth);
    final cellHeight = painter.height;
    print(
      '-------- now applying text painter on cell num  : $i , cellHeight : $cellHeight content : ${params.cellText[i]}',
    );
    if (currentPage.isNotEmpty &&
        currentHeight + cellHeight > params.pageHeight) {
      pages.add(currentPage);
      currentPage = [];
      currentHeight = 0;
    }

    currentPage.add(i);
    currentHeight += cellHeight;
    print(
      '------- now currentPAge Contents : $currentPage , with Height  : $currentHeight',
    );
  }

  if (currentPage.isNotEmpty) pages.add(currentPage);
  return pages;
}

class CellPageView extends StatefulWidget {
  final CellCache cache;
  final BionicCache bionicCache;
  final ReaderPreferencesState? state;
  final ValueNotifier<bool> isBionicNotifier;
  final int totalCells;
  final void Function(double) updateOnSwipe;
  const CellPageView({
    super.key,
    this.state,
    required this.cache,
    required this.bionicCache,
    required this.isBionicNotifier,
    required this.totalCells,
    required this.updateOnSwipe,
  });

  @override
  State<CellPageView> createState() => _CellPageViewState();
}

class _CellPageViewState extends State<CellPageView> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! < 0) {
          if (currentIndex < widget.cache.pages.length - 1) {
            setState(() => currentIndex++);
            double progress =
                (widget.cache.pages[currentIndex].first / widget.totalCells) *
                100;
            print(
              ' ------------- current Page Cells : ${widget.cache.pages[currentIndex]} ------------- ',
            );
            print(
              '------------- num of pages = ${widget.cache.pages.length} ------------- ',
            );
            print(
              ' ------------- total cells : ${widget.totalCells} ------------- ',
            );
            print(
              ' ------------- the firts cell in the page is ${widget.cache.pages[currentIndex].first} ------------- ',
            );
            print(' ------------- current Progress : $progress -------------');
            widget.updateOnSwipe(progress);
          }
        } else {
          print(
            ' ------------- current Page Cells : ${widget.cache.pages[currentIndex]} ------------- ',
          );
          print(
            '------------- num of pages = ${widget.cache.pages.length} ------------- ',
          );
          print(
            ' ------------- total cells : ${widget.totalCells} ------------- ',
          );
          print(
            ' ------------- the firts cell in the page is ${widget.cache.pages[currentIndex].first} ------------- ',
          );
          if (currentIndex > 0) setState(() => currentIndex--);
        }
      },
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: AppSpacing.xl),
        child: AnimatedSwitcher(
          duration: AppDuration.normal,
          child: Column(
            key: ValueKey(currentIndex),

            children: widget.cache.pages[currentIndex]
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
          ),
        ),
      ),
    );
  }
}

class CellCache {
  final List<List<int>> pages;
  const CellCache({required this.pages});

  static Future<CellCache> compute(PageLayoutParams params) async {
    print('----------- pages compute called -----------------');
    final pages = _buildPageView(params);
    print('================result of the compute is pags : $pages');
    return CellCache(pages: pages);
  }
}

class PageLayoutParams {
  final List<String> cellText;
  final double pageHeight;
  final double pageWidth;
  final double fontSize;
  final double lineSpacing;

  const PageLayoutParams({
    required this.cellText,
    required this.pageHeight,
    required this.pageWidth,
    required this.fontSize,
    required this.lineSpacing,
  });
}
