import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';
import 'package:quill/core/widgets/app_button.dart';

class PagesSliderSheet extends StatefulWidget {
  final int currentPage;
  final int totalPages;
  final void Function(int) onGoToPage;

  const PagesSliderSheet({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onGoToPage,
  });

  @override
  State<PagesSliderSheet> createState() => _PagesSliderSheetState();
}

class _PagesSliderSheetState extends State<PagesSliderSheet> {
  late double _selectedPage;

  @override
  void initState() {
    super.initState();
    _selectedPage = widget.currentPage.toDouble();
    if (widget.currentPage == 0) setState(() => _selectedPage = 1);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final progress = ((_selectedPage - 1) / (widget.totalPages - 1) * 100)
        .toInt()
        .clamp(0, 100);

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.xxl,
      ),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 36.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: theme.onSurface.withValues(alpha: 0.15),
                borderRadius: AppRadius.lg,
              ),
            ),
          ),
          SizedBox(height: AppSpacing.xxl),
          Text('Go to page', style: AppTextStyles.displayLarge(context)),
          SizedBox(height: AppSpacing.sm),
          Text(
            'Drag to jump anywhere in the book',
            style: AppTextStyles.caption(
              context,
            ).copyWith(color: theme.onSurface.withValues(alpha: 0.5)),
          ),
          SizedBox(height: AppSpacing.xxl),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${_selectedPage.toInt()}',
                style: AppTextStyles.displayLarge(
                  context,
                ).copyWith(fontSize: 40.sp, color: theme.secondary),
              ),
              SizedBox(width: AppSpacing.sm),
              Text(
                'of ${widget.totalPages}',
                style: AppTextStyles.bodyMedium(
                  context,
                ).copyWith(color: theme.onSurface.withValues(alpha: 0.5)),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.xl),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 2,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 16),
              thumbColor: theme.secondary,
              activeTrackColor: theme.secondary,
              inactiveTrackColor: theme.onSurface.withValues(alpha: 0.08),
              overlayColor: theme.secondary.withValues(alpha: 0.1),
            ),
            child: Slider(
              min: 1,
              max: widget.totalPages.toDouble(),
              value: _selectedPage,
              onChanged: (val) => setState(() => _selectedPage = val),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '1',
                style: AppTextStyles.caption(
                  context,
                ).copyWith(color: theme.onSurface.withValues(alpha: 0.5)),
              ),
              Text(
                '$progress% read',
                style: AppTextStyles.caption(
                  context,
                ).copyWith(color: theme.onSurface.withValues(alpha: 0.5)),
              ),
              Text(
                '${widget.totalPages}',
                style: AppTextStyles.caption(
                  context,
                ).copyWith(color: theme.onSurface.withValues(alpha: 0.5)),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.xxl),
          AppButton.primary(
            text: 'Go',
            onPressed: () {
              widget.onGoToPage(_selectedPage.toInt());
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
