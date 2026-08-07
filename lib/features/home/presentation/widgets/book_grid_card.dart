import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quill/core/theme/app_colors.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_shadows.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BookGridCard extends StatelessWidget {
  final String bookCover;
  final String bookTitle;
  final String bookAuthor;
  final VoidCallback? onTap;

  const BookGridCard({
    super.key,
    required this.bookCover,
    required this.bookTitle,
    required this.bookAuthor,
    this.onTap,
  });

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
                child: Skeleton.leaf(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: AppRadius.xl,
                      boxShadow: AppShadows.bookCover,
                    ),
                    child: ClipRRect(
                      borderRadius: AppRadius.xl,
                      child: Image.network(bookCover, fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                bookTitle,
                style: AppTextStyles.heading2(context),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                bookAuthor,

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
