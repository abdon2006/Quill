import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quill/core/theme/app_colors.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_shadows.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';
import 'package:quill/features/home/domain/entities/book_entity.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BookGridCard extends StatelessWidget {
  final BookEntity book;
  final VoidCallback? onTap;

  const BookGridCard({super.key, this.onTap, required this.book});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        child: SizedBox(
          width: 130.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: AppRadius.xl,
                    boxShadow: AppShadows.bookCover,
                  ),
                  child: ClipRRect(
                    borderRadius: AppRadius.xl,
                    child: Image.network(
                      book.coverImage,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Skeleton.leaf(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: AppRadius.xl,
                                color: Colors.grey[200],
                              ),
                            ),
                          ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
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
                ).copyWith(color: AppColors.lightTextMuted),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
