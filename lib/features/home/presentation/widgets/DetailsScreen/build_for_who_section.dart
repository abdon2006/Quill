import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';

Widget buildForWhoSection(BuildContext context , String fowWho) {
    final theme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Container(
        padding: AppSpacing.cardPadding,
        decoration: BoxDecoration(
          color: theme.surface.withValues(alpha: 0.75),
          borderRadius: AppRadius.xl,
          border: Border.all(color: theme.onSurface.withValues(alpha: 0.05)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42.w,
              height: 42.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.primary.withValues(alpha: 0.10),
              ),
              child: Center(
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedUserMultiple02,
                  color: theme.primary,
                  size: 20.sp,
                ),
              ),
            ),

            const SizedBox(width: AppSpacing.md),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('For who', style: AppTextStyles.heading2(context)),

                  const SizedBox(height: AppSpacing.xs),

                  Text(
                   fowWho,
                    style: AppTextStyles.heading2(context).copyWith(
                      height: 1.5,
                      color: theme.onSurface.withValues(alpha: 0.62),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
