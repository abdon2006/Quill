import 'package:flutter/material.dart';
import 'package:quill/core/theme/app_colors.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? subTitle;
  final void Function()? viewAllOnTap;
  const SectionHeader({
    super.key,
    required this.title,
    this.subTitle,
    this.viewAllOnTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.heading1(
                context,
              ).copyWith(fontWeight: FontWeight.bold),
            ),
            if (subTitle != null)
              Text(
                subTitle!,
                style: AppTextStyles.bodyMedium(
                  context,
                ).copyWith(color: AppColors.lightTextMuted),
              ),
          ],
        ),
        Spacer(),
        if (viewAllOnTap != null)
          GestureDetector(
            onTap: viewAllOnTap,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Center(
                child: Text(
                  'View All',
                  style: AppTextStyles.label(
                    context,
                  ).copyWith(color: theme.colorScheme.primary),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
