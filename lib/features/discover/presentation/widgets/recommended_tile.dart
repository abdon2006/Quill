import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:quill/core/router/app_router.dart';
import 'package:quill/core/theme/app_colors.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';
import 'package:quill/core/widgets/build_cover_placeholder.dart';
import 'package:quill/features/home/domain/entities/book_entity.dart';

class RecommendedBookTile extends StatelessWidget {
  final BookEntity book;
  final String searchText;
  final ValueChanged<String>? onSave;

  const RecommendedBookTile({
    super.key,
    required this.book,
    this.searchText = '',
    this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    bool isNormal = true;
    bool isInTitle = false;
    int? firstIndex;

    if (searchText.isNotEmpty) {
      isNormal = false;
      final firstIndexTitle = book.title.toLowerCase().indexOf(
        searchText.toLowerCase(),
      );
      if (firstIndexTitle < 0) {
        final firstIndexAuthor = book.author.toLowerCase().indexOf(
          searchText.toLowerCase(),
        );
        if (firstIndexAuthor < 0) {
          isNormal = true;
        } else {
          firstIndex = firstIndexAuthor;
        }
      } else {
        firstIndex = firstIndexTitle;
        isInTitle = true;
      }
    }

    final theme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 130.h,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            top: 30.h,
            bottom: 0,
            left: 0,
            right: 0,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: AppRadius.md,
                onTap: () {
                  context.push(AppRoutes.bookDeatails, extra: book);
                  if (onSave != null) onSave!(searchText);
                },
                child: Ink(
                  decoration: BoxDecoration(
                    color: theme.primary.withValues(alpha: 0.1),
                    borderRadius: AppRadius.md,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            bottom: 15.h,
            left: 15.w,
            right: 15.w,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AspectRatio(
                  aspectRatio: 2 / 3,
                  child: ClipRRect(
                    borderRadius: AppRadius.sm,
                    child: Image.network(
                      book.coverImage,
                      width: 75.w,
                      height: 115.h,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          buildCoverPlaceholder(context),
                    ),
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        isNormal || !isInTitle
                            ? Text(
                                book.title,
                                style: AppTextStyles.heading2(
                                  context,
                                ).copyWith(fontWeight: FontWeight.w600),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )
                            : RichText(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: book.title.substring(0, firstIndex),
                                      style: AppTextStyles.heading2(
                                        context,
                                      ).copyWith(fontWeight: FontWeight.w600),
                                    ),
                                    TextSpan(
                                      text: book.title.substring(
                                        firstIndex!,
                                        firstIndex + searchText.length,
                                      ),
                                      style: AppTextStyles.heading2(context)
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: theme.secondary,
                                          ),
                                    ),
                                    TextSpan(
                                      text: book.title.substring(
                                        firstIndex + searchText.length,
                                      ),
                                      style: AppTextStyles.heading2(
                                        context,
                                      ).copyWith(fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                        SizedBox(height: 6.h),
                        Row(
                          children: [
                            Expanded(
                              child: isNormal || isInTitle
                                  ? Text(
                                      book.author,
                                      style: AppTextStyles.bodyMedium(context)
                                          .copyWith(
                                            color: theme.onSurface.withValues(
                                              alpha: 0.5,
                                            ),
                                          ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  : RichText(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: book.author.substring(
                                              0,
                                              firstIndex,
                                            ),
                                            style:
                                                AppTextStyles.bodyMedium(
                                                  context,
                                                ).copyWith(
                                                  color: theme.onSurface
                                                      .withValues(alpha: 0.5),
                                                ),
                                          ),
                                          TextSpan(
                                            text: book.author.substring(
                                              firstIndex!,
                                              firstIndex + searchText.length,
                                            ),
                                            style:
                                                AppTextStyles.bodyMedium(
                                                  context,
                                                ).copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  color: theme.secondary,
                                                ),
                                          ),
                                          TextSpan(
                                            text: book.author.substring(
                                              firstIndex + searchText.length,
                                            ),
                                            style:
                                                AppTextStyles.bodyMedium(
                                                  context,
                                                ).copyWith(
                                                  color: theme.onSurface
                                                      .withValues(alpha: 0.5),
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Iconsax.star1,
                                  size: 14.sp,
                                  color: AppColors.darkGold,
                                ),
                                const SizedBox(width: AppSpacing.xs),
                                Text(
                                  '${book.ratingAverage}',
                                  style: AppTextStyles.caption(context)
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.sp,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
