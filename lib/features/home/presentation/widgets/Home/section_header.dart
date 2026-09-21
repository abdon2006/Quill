import 'package:flutter/material.dart';
import 'package:quill/core/theme/app_radius.dart';
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.heading1(
                  context,
                ).copyWith(fontWeight: FontWeight.bold),
              ),
            ),

            if (viewAllOnTap != null) ...[
              SizedBox(width: AppSpacing.sm),
              GestureDetector(
                onTap: viewAllOnTap,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: AppRadius.xl,
                    color: theme.colorScheme.secondary.withValues(alpha: 0.1),
                  ),
                  child: Center(
                    child: Text(
                      'View All',
                      style: AppTextStyles.caption(
                        context,
                      ).copyWith(color: theme.colorScheme.primary),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),

        if (subTitle != null) ...[
          SizedBox(height: AppSpacing.xs),
          Text(
            subTitle!,
            style: AppTextStyles.bodyMedium(context).copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
        ],
      ],
    );
  }
}
