import 'package:equatable/equatable.dart';
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
  int? initialCell;
  CellCache? _pages;
  final ItemScrollController scrollController = ItemScrollController();
  final ItemPositionsListener listener = ItemPositionsListener.create();

  @override
  void didUpdateWidget(covariant ReaderSurface oldWidget) {
    super.didUpdateWidget(oldWidget);

    // لما اليوزر يبدل من pages لـ scroll — نحفظ الموقع ونروح ليه
    if (oldWidget.state.scrollMode != widget.state.scrollMode &&
        widget.state.scrollMode == ReaderScrollMode.scroll) {
      widget.updateProgress(initialCell! / _cache!.cellCount * 100);
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

    // لما الـ fontSize أو lineSpacing يتغير — نعيد بناء الصفحات
    if (oldWidget.state.fontSize != widget.state.fontSize ||
        oldWidget.state.lineSpacing != widget.state.lineSpacing) {
      if (widget.state.scrollMode == ReaderScrollMode.pages) {
        print('🔄 Font size or line spacing changed — rebuilding pages...');
        _loadPages(widget.state.fontSize);
      }
    }
  }

  @override
  void initState() {
    super.initState();

    // السماع للـ scroll position وتحديث التقدم
    listener.itemPositions.addListener(() {
      final positions = listener.itemPositions.value;
      if (positions.isEmpty || _cache == null) return;

      final minIndex = positions
          .where((p) => p.itemTrailingEdge > 0)
          .map((p) => p.index)
          .reduce((a, b) => a < b ? a : b);

      final currentCell = (minIndex - 1).clamp(0, _cache!.cellCount - 1);
      print('📍 Scroll mode — current cell: $currentCell');

      initialCell = currentCell;
      final progress = currentCell / _cache!.cellCount * 100;
      widget.updateProgress(progress);
    });

    _loadCache();
  }

  Future<void> _loadCache() async {
    print('📚 Loading BionicCache...');
    final cache = await BionicCache.compute(widget.paragraphs);

    if (!mounted) return;
    setState(() {
      _cache = cache;
      _cacheReady = true;
    });

    print('✅ BionicCache loaded — total cells: ${_cache!.cellCount}');

    // حساب الخلية الابتدائية من التقدم المحفوظ
    final savedIndex = (widget.book.progress / 100 * _cache!.cellCount).toInt();
    setState(() => initialCell = savedIndex);
    print('📍 Restored initial cell from progress: $initialCell');

    await _loadPages();

    await Future.delayed(const Duration(milliseconds: 50));
    if (!mounted) return;

    if (widget.state.scrollMode == ReaderScrollMode.scroll) {
      scrollController.scrollTo(
        index: savedIndex,
        duration: AppDuration.readerGlow,
        curve: Curves.easeInOutCubic,
      );
    }

    setState(() => _visible = true);
  }

  Future<void> _loadPages([double? newFontSize]) async {
    if (_cache == null) return;
    setState(() => _pages = null);

    print('📄 Building pages layout...');

    final textScalar = MediaQuery.textScalerOf(context).scale(1.0);
    final safeArea = MediaQuery.of(context).padding;
    final pageHeight =
        MediaQuery.of(context).size.height -
        safeArea.top -
        safeArea.bottom -
        (AppSpacing.lg * 2);

    final pageWidth = MediaQuery.of(context).size.width - (AppSpacing.xxl * 2);

    print('📐 Page dimensions — height: $pageHeight, width: $pageWidth');
    print('🔤 textScaleFactor: $textScalar');

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

    // لو في extra cells من الـ splitting — نضيفها للـ BionicCache
    if (result.extraCells.isNotEmpty) {
      print('✂️ Adding ${result.extraCells.length} split cells to BionicCache');
      _cache!._addExtraCells(result.extraCells);
    }

    setState(() => _pages = result.cache);
    print('✅ Pages built — total pages: ${result.cache.pages.length}');

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
          duration: Duration.zero,
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
              ? const Center(child: CircularProgressIndicator())
              : CellPageView(
                  key: ValueKey(
                    KeyParamsForCellView(
                      fontSize: widget.state.fontSize,
                      lineSpacing: widget.state.lineSpacing,
                      scrollMode: widget.state.scrollMode,
                    ),
                  ),
                  state: widget.state,
                  cache: _pages!,
                  bionicCache: _cache!,
                  isBionicNotifier: widget.isBionicNotifier,
                  totalCells: cellCount,
                  updateOnSwipe: (double progress) =>
                      widget.updateProgress(progress),
                  initialCellIndex: initialCell!,
                  onPageChanged: (int newCell) => initialCell = newCell,
                ),
        ),

        if (!_visible)
          TextAnimation(
            callBack: () {},
            messages: ['just one step..', 'Book Ready For You'],
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
  final void Function(double) updateOnSwipe;
  final int initialCellIndex;
  final void Function(int) onPageChanged;

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
  });

  @override
  State<CellPageView> createState() => _CellPageViewState();
}

class _CellPageViewState extends State<CellPageView> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.cache.pages.indexWhere(
      (page) => page.contains(widget.initialCellIndex),
    );
    if (currentIndex < 0) currentIndex = 0;
    print(
      '📖 CellPageView init — starting at Cell: ${widget.initialCellIndex}',
    );
    print('📖 CellPageView init — starting at page: $currentIndex');
    print('📊 Total pages: ${widget.cache.pages.length}');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! < 0) {
          // سوايب لليسار — الصفحة الجاية
          if (currentIndex < widget.cache.pages.length - 1) {
            setState(() => currentIndex++);
            final firstCell = widget.cache.pages[currentIndex].first;
            final progress = (firstCell / widget.totalCells) * 100;
            print(
              '➡️ Next page: $currentIndex — first cell: $firstCell — progress: $progress%',
            );
            widget.updateOnSwipe(progress);
            widget.onPageChanged(firstCell);
          }
        } else {
          // سوايب لليمين — الصفحة السابقة
          if (currentIndex > 0) {
            setState(() => currentIndex--);
            final firstCell = widget.cache.pages[currentIndex].first;
            print('⬅️ Prev page: $currentIndex — first cell: $firstCell');
            widget.onPageChanged(firstCell);
          }
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
        child: AnimatedSwitcher(
          duration: AppDuration.normal,
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
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

// ─────────────────────────────────────────────
// BionicCache
// ─────────────────────────────────────────────

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

  /// يضيف cells جديدة ناتجة من splitting — بيتنادى بعد _buildPageView
  void _addExtraCells(List<String> extras) {
    for (final text in extras) {
      _cellTexts.add(text);
      _fragments.add(_processChunk(text));
      print(
        '➕ Extra split cell added: "${text.substring(0, text.length.clamp(0, 40))}..."',
      );
    }
    print('📦 BionicCache now has ${_cellTexts.length} cells');
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

/// نتيجة بناء الصفحات — فيها الصفحات + الـ cells الجديدة من الـ splitting
class PageLayoutResult {
  final CellCache cache;
  final List<String> extraCells; // cells اتضافت من تقسيم cells كبيرة

  const PageLayoutResult({required this.cache, required this.extraCells});
}

/// بيبني الصفحات ويقسم الـ cells اللي أكبر من الـ pageHeight
List<Object> _buildPageView(PageLayoutParams params) {
  print('🏗️ _buildPageView started — total cells: ${params.cellText.length}');
  print('📐 pageHeight: ${params.pageHeight}, pageWidth: ${params.pageWidth}');

  final List<List<int>> pages = [];
  final List<String> extraCells = []; // النصوص المضافة من الـ splitting
  List<int> currentPage = [];
  double currentHeight = 0;

  // نبدأ بنسخة قابلة للتعديل من الـ cells
  final allCells = List<String>.from(params.cellText);
  int i = 0;

  while (i < allCells.length) {
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

    print(
      '📏 Cell $i — height: $cellHeight — "${allCells[i].substring(0, allCells[i].length.clamp(0, 40))}..."',
    );

    // لو الـ cell نفسها أكبر من الـ pageHeight — نقسمها
    if (cellHeight > params.pageHeight) {
      print(
        '✂️ Cell $i is too tall ($cellHeight > ${params.pageHeight}) — splitting...',
      );

      final words = allCells[i].split(' ');
      final half = words.length ~/ 2;
      final firstHalf = words.sublist(0, half).join(' ');
      final secondHalf = words.sublist(half).join(' ');

      print(
        '✂️ First half: "${firstHalf.substring(0, firstHalf.length.clamp(0, 40))}..."',
      );
      print(
        '✂️ Second half: "${secondHalf.substring(0, secondHalf.length.clamp(0, 40))}..."',
      );

      // بنستبدل الـ cell الحالية بالنص الأول
      allCells[i] = firstHalf;

      // بنضيف النص التاني كـ cell جديدة بعدها مباشرةً
      allCells.insert(i + 1, secondHalf);
      extraCells.add(secondHalf);

      print('📦 Total cells after split: ${allCells.length}');

      // نعيد قياس الـ cell المعدلة
      continue;
    }

    // لو الصفحة الحالية هتتجاوز الـ pageHeight — ابدأ صفحة جديدة
    if (currentPage.isNotEmpty &&
        currentHeight + cellHeight > params.pageHeight) {
      print(
        '📄 Page ${pages.length} complete — cells: $currentPage — height: $currentHeight',
      );
      pages.add(currentPage);
      currentPage = [];
      currentHeight = 0;
    }

    currentPage.add(i);
    currentHeight += cellHeight;
    i++;
  }

  if (currentPage.isNotEmpty) {
    print('📄 Last page — cells: $currentPage — height: $currentHeight');
    pages.add(currentPage);
  }

  print(
    '✅ _buildPageView done — ${pages.length} pages, ${extraCells.length} extra cells',
  );
  return [pages, extraCells];
}

class CellCache {
  final List<List<int>> pages;
  const CellCache({required this.pages});

  static Future<PageLayoutResult> compute(PageLayoutParams params) async {
    print('⚙️ CellCache.compute called');
    // _buildPageView بترجع List عشان تعدي الاتنين من الـ isolate
    final result = _buildPageView(params);
    final pages = result[0] as List<List<int>>;
    final extraCells = result[1] as List<String>;
    print(
      '✅ CellCache.compute done — ${pages.length} pages, ${extraCells.length} extra cells',
    );
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

class KeyParamsForCellView extends Equatable {
  final double fontSize;
  final double lineSpacing;
  final ReaderScrollMode scrollMode;

  const KeyParamsForCellView({
    required this.fontSize,
    required this.lineSpacing,
    required this.scrollMode,
  });

  @override
  List<Object?> get props => [fontSize, lineSpacing, scrollMode];
}
