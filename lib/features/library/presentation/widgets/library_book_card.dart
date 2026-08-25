import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/theme/app_colors.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_shadows.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';
import 'package:quill/features/library/data/models/library_book_display_model.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LibraryBookCard extends StatelessWidget {
  final LibraryBookDisplayModel book;
  final VoidCallback onTap;
  const LibraryBookCard({super.key, required this.book, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: AppRadius.xl,
                boxShadow: AppShadows.bookCover,
              ),
              child: Skeleton.leaf(
                child: ClipRRect(
                  borderRadius: AppRadius.xl,
                  child: Image.network(
                    book.coverImage ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stack) => Container(
                      color: theme.surface,
                      child: Center(
                        child: HugeIcon(
                          icon: HugeIcons.strokeRoundedLibrary,
                          size: 42.sp,
                          color: isDark
                              ? AppColors.darkTextMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.sm),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Skeleton.leaf(
                  child: Text(
                    book.title,
                    style: AppTextStyles.heading2(context),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  book.author,

                  style: AppTextStyles.bodyMedium(
                    context,
                  ).copyWith(color: theme.onSurface.withValues(alpha: 0.3)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                book.pages != null && book.currentPage != null
                    ? Skeleton.ignore(
                        child: Row(
                          children: [
                            Expanded(
                              child: LinearProgressIndicator(
                                value: 0.7,
                                borderRadius: AppRadius.xl,
                                valueColor: AlwaysStoppedAnimation(
                                  theme.primary,
                                ),
                                backgroundColor: theme.surface,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              '70 %',
                              style: AppTextStyles.caption(context).copyWith(
                                color: theme.onSurface.withValues(alpha: 0.3),
                              ),
                            ),
                          ],
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
