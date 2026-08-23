import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/theme/app_colors.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_shadows.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';

class ContinueReading extends StatelessWidget {
  final VoidCallback onTap;

  const ContinueReading({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.xxl,
        child: Ink(
          padding: AppSpacing.cardPadding,
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: AppRadius.xxl,
            boxShadow: AppShadows.card,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 90.w,
                child: AspectRatio(
                  aspectRatio: 0.68,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: AppRadius.xl,
                      boxShadow: AppShadows.continueReadingBook,
                    ),
                    child: ClipRRect(
                      borderRadius: AppRadius.xl,
                      child: Image.network(
                        'https://images.unsplash.com/photo-1544947950-fa07a98d237f?q=80&w=800&auto=format&fit=crop',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) {
                          return Container(
                            color: colors.surfaceContainerHighest,
                            alignment: Alignment.center,
                            child: HugeIcon(
                              icon: HugeIcons.strokeRoundedBook01,
                              color: colors.onSurface.withValues(alpha: 0.35),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(width: AppSpacing.lg),

              // ─────────────────────────────
              // Book Information
              // ─────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CONTINUE READING',
                      style: AppTextStyles.label(
                        context,
                      ).copyWith(color: colors.primary, letterSpacing: 1.1),
                    ),

                    SizedBox(height: AppSpacing.xs),

                    Text(
                      'Milk & Honey',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.heading2(context),
                    ),

                    SizedBox(height: AppSpacing.xs),

                    Text(
                      'Rupi Kaur',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyMedium(
                        context,
                      ).copyWith(color: AppColors.lightTextMuted),
                    ),

                    SizedBox(height: AppSpacing.lg),

                    // Progress
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: AppRadius.xl,
                            child: LinearProgressIndicator(
                              value: 0.7,
                              minHeight: 5,
                              backgroundColor: colors.onSurface.withValues(
                                alpha: 0.08,
                              ),
                              valueColor: AlwaysStoppedAnimation(
                                colors.primary,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: AppSpacing.sm),

                        Text(
                          '70%',
                          style: AppTextStyles.caption(context).copyWith(
                            color: colors.onSurface.withValues(alpha: 0.55),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: AppSpacing.xs),

                    Text(
                      'A little more to go.',
                      style: AppTextStyles.caption(context).copyWith(
                        color: colors.onSurface.withValues(alpha: 0.45),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: AppSpacing.sm),

              // ─────────────────────────────
              // Continue Arrow
              // ─────────────────────────────
              Container(
                padding: EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.primary.withValues(alpha: 0.08),
                ),
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedArrowRight01,
                  size: 20,
                  color: colors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
