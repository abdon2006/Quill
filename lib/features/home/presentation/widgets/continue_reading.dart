import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/theme/app_colors.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_shadows.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';

class ContinueReading extends StatelessWidget {
  final VoidCallback ontap;
  const ContinueReading({super.key, required this.ontap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: ontap,
      child: Container(
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          borderRadius: AppRadius.xxl,
          color: theme.colorScheme.surface,
          boxShadow: AppShadows.card,
        ),
        child: Row(
          children: [
            Container(
              height: 140,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: AppRadius.xl,
                boxShadow: AppShadows.continueReadingBook,
              ),
              child: ClipRRect(
                borderRadius: AppRadius.xl,
                child: Image.network(
                  'https://images.unsplash.com/photo-1544947950-fa07a98d237f?q=80&w=800&auto=format&fit=crop',
                  fit: BoxFit.cover,
                ),
              ),
            ),

            SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Current Book",
                    style: AppTextStyles.label(
                      context,
                    ).copyWith(color: theme.colorScheme.primary),
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    'Milk & Honey',
                    style: AppTextStyles.heading2(context),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Homer',
                    style: AppTextStyles.bodyMedium(
                      context,
                    ).copyWith(color: AppColors.lightTextMuted),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: 0.7,
                          borderRadius: AppRadius.xl,
                          valueColor: AlwaysStoppedAnimation(
                            theme.colorScheme.primary,
                          ),
                          backgroundColor: AppColors.lightBgSurfaceAlt,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        '70 %',
                        style: AppTextStyles.caption(
                          context,
                        ).copyWith(color: AppColors.lightTextMuted),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
              ),
              child: Center(
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedArrowRight01,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
