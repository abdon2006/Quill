import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';
import 'package:quill/features/library/data/models/library_book_display_model.dart';

Widget buildFileInfo(BuildContext context, LibraryBookDisplayModel book) {
  final theme = Theme.of(context).colorScheme;

  final progress =
      (book.pages != null && book.currentPage != null && book.pages! > 0)
      ? book.currentPage! / book.pages!
      : 0.0;

  final progressLabel = '${(progress * 100).toStringAsFixed(0)}%';

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
    child: Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: theme.surface.withValues(alpha: 0.72),
        borderRadius: AppRadius.lg,
        border: Border.all(color: theme.onSurface.withValues(alpha: 0.06)),
      ),
      child: Column(
        children: [
          // Cover image row
          Row(
            children: [
              Container(
                width: 38.w,
                height: 38.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.primary.withValues(alpha: 0.08),
                ),
                child: Center(
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedImage01,
                    color: theme.primary,
                    size: 18.sp,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  'Book Cover',
                  style: AppTextStyles.bodyMedium(context),
                ),
              ),
              GestureDetector(
                onTap: () {
                  // TODO: pick image
                },
                child: Text(
                  'Change',
                  style: AppTextStyles.bodyMedium(
                    context,
                  ).copyWith(color: theme.primary),
                ),
              ),
            ],
          ),

          if (book.pages != null && book.currentPage != null) ...[
            const SizedBox(height: AppSpacing.lg),
            Divider(color: theme.onSurface.withValues(alpha: 0.06)),
            const SizedBox(height: AppSpacing.lg),

            // Progress row
            Row(
              children: [
                Container(
                  width: 38.w,
                  height: 38.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.primary.withValues(alpha: 0.08),
                  ),
                  child: Center(
                    child: HugeIcon(
                      icon: HugeIcons.strokeRoundedBookOpen02,
                      color: theme.primary,
                      size: 18.sp,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reading Progress',
                        style: AppTextStyles.bodyMedium(context),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Row(
                        children: [
                          Expanded(
                            child: LinearProgressIndicator(
                              value: progress,
                              borderRadius: AppRadius.xl,
                              valueColor: AlwaysStoppedAnimation(theme.primary),
                              backgroundColor: theme.onSurface.withValues(
                                alpha: 0.08,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            progressLabel,
                            style: AppTextStyles.caption(context).copyWith(
                              color: theme.onSurface.withValues(alpha: 0.4),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    ),
  );
}
