import 'dart:io';

import 'package:flutter/foundation.dart' as foundation show compute;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quill/core/theme/app_duration.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_shadows.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';
import 'package:quill/core/widgets/build_cover_placeholder.dart';
import 'package:quill/features/reader/data/models/local_book.dart';
import 'package:quill/features/reader/presentation/widgets/reader/reader_header.dart';
import 'package:quill/features/reader/presentation/widgets/reader/text_animation.dart';

class ReaderSurface extends StatefulWidget {
  final List<String> paragraphs;
  final ValueNotifier<bool> isBionicNotifier;
  final LocalBook book;

  const ReaderSurface({
    super.key,
    required this.paragraphs,
    required this.isBionicNotifier,
    required this.book,
  });

  @override
  State<ReaderSurface> createState() => _ReaderSurfaceState();
}

class _ReaderSurfaceState extends State<ReaderSurface> {
  BionicCache? _cache;
  bool _cacheReady = false;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    _loadCache();
  }

  Future<void> _loadCache() async {
    final cache = await BionicCache.compute(widget.paragraphs);

    if (!mounted) return;
    setState(() {
      _cache = cache;
      _cacheReady = true;
    });
    await Future.delayed(const Duration(milliseconds: 50));
    if (!mounted) return;
    setState(() => _visible = true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final cellCount = _cache?.cellCount ?? 0;
    final wordCount = cellCount * 140;
    final minutes = (wordCount / 200).toInt();
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    return Stack(
      children: [
        ListView.builder(
          addAutomaticKeepAlives: false,
          addRepaintBoundaries: true,
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
          itemCount: cellCount + 1,
          itemBuilder: (context, i) {
            return AnimatedOpacity(
              duration: AppDuration.slow,
              opacity: !_visible ? 0 : 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                child: i == 0
                    ? ReaderHeader(book: widget.book, hours: hours, mins: mins)
                    : _BionicCell(
                        text: _cache!.cellText(1),
                        isBionicNotifier: widget.isBionicNotifier,
                        cache: _cache!,
                        index: 1,
                        ready: _cacheReady,
                      ),
              ),
            );
          },
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

  const _BionicCell({
    required this.text,
    required this.isBionicNotifier,
    required this.cache,
    required this.index,
    required this.ready,
  });

  @override
  Widget build(BuildContext context) {
    final normalStyle = AppTextStyles.defaultReading(
      context,
    ).copyWith(height: 1.8);
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
                  textAlign: TextAlign.justify,
                )
              : RichText(
                  key: ValueKey('Bionic'),
                  textAlign: TextAlign.justify,
                  text: TextSpan(children: spans),
                ),
        );
      },
    );
  }
}

/// split('\n\n') علي حسب  paragraph اتضح بقا ان اصلا المشكلة كانت في استحراج النص من الاول احنا كنا بنقسم كل
/// مرة واحدة process وده كان بيعمل مشكلة كبيرة ان دلوقتي بقا البراجرافا هو واحد بس وفيه الاف الكلمات وبتتعرض وبيتعملها
/// فقولنا هنقسم الباراجراف الواحد ده لخلايا اولما نيي نعرض ونحلل هنتعامل مع الخلايا دي بس
/// والحد الاقصي للخلية هيبقي 140 كلمة
const int _cellMaxWords = 140;

///  tuples بتاخد الخلية الواحدة وترجع ليست من ال process دي بقا يا معلم الفانكشن اللي بتتعمل ال
/// ده اللي بيقول النص ده بودل ولا لا  bool ال  (String , bool) بيبقي جزأين tuple كل
/// hello زي كده
/// ("hel", true) — bold
/// ("lo", false) — normal
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

/// Splits arbitrary text into word-capped cells (whole words, never split in
/// the middle), so a giant stored paragraph becomes many small render cells.
/// بتاخد النص الكبير وتقطعه للخلاليا اللي فولنا عليها كل خلية 140 كلمة
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

/// Runs chunking + bionic processing for the WHOLE book in a single isolate
/// call. Returns a flat list of (cellText, fragmentSpans) pairs.
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

/// In-memory cache of flattened cells and their bionic spans. Cells are the
/// ListView items; only visible cells build RichText, so a huge single stored
/// paragraph never lays out in full.
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

  List<TextSpan>? spansFor(int index, TextStyle normal, TextStyle bold) {
    final fragments = _fragments[index];
    if (fragments == null) return null;
    return fragments
        .map((e) => TextSpan(text: e.$1, style: e.$2 ? bold : normal))
        .toList();
  }
}
