import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quill/core/theme/app_colors.dart';
import 'package:quill/core/theme/app_duration.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';

class DiscoverFilteredChips extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelectedCategory;
  const DiscoverFilteredChips({
    super.key,
    required this.onSelectedCategory,
    required this.selectedIndex,
  });

  @override
  State<DiscoverFilteredChips> createState() => _DiscoverFilteredChipsState();
}

class _DiscoverFilteredChipsState extends State<DiscoverFilteredChips> {
  final List<String> _categories = [
    'All',
    'Fiction',
    'Philosophy',
    'Science',
    'Self-Improvement',
    'Poetry',
  ];
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    return SizedBox(
      height: 40.h,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, i) {
          final item = _categories[i];
          bool isSelected = widget.selectedIndex == i;
          return InkWell(
            borderRadius: AppRadius.xxl,
            onTap: () => widget.onSelectedCategory(i),
            child: Ink(
              child: AnimatedScale(
                duration: AppDuration.slow,
                curve: Curves.easeInOutCubic,
                scale: isSelected ? 0.97 : 1,
                child: AnimatedContainer(
                  duration: AppDuration.normal,
                  curve: Curves.easeInOutCubic,
                  padding: EdgeInsets.symmetric(
                    vertical: AppSpacing.md,
                    horizontal: AppSpacing.lg,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? theme.secondary : theme.surface,
                    borderRadius: AppRadius.xxl,
                  ),
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: AppDuration.slow,
                      curve: Curves.easeInOutCubic,

                      style: AppTextStyles.bodyMedium(context).copyWith(
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? theme.surface
                            : isDark
                            ? AppColors.darkTextMuted
                            : AppColors.lightTextMuted,
                      ),
                      child: Text(item),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => SizedBox(width: AppSpacing.sm),

        itemCount: _categories.length,
      ),
    );
  }
}
