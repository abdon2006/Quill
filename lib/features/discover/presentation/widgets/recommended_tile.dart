import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/router/app_router.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';
import 'package:quill/core/widgets/build_cover_placeholder.dart';
import 'package:quill/features/home/domain/entities/book_entity.dart';

class RecommendedBookTile extends StatelessWidget {
  final BookEntity book;

  const RecommendedBookTile({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: AppRadius.md,
        onTap: () => context.push(AppRoutes.bookDeatails, extra: book.id),
        child: Ink(
          padding: EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: theme.surface.withValues(alpha: 0.7),
            borderRadius: AppRadius.md,
            border: Border.all(color: theme.onSurface.withValues(alpha: 0.03)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. صورة الغلاف المصغرة
              ClipRRect(
                borderRadius: AppRadius.sm,
                child: Image.network(
                  book.coverImage,
                  width: 55.w,
                  height: 80.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      buildCoverPlaceholder(context),
                ),
              ),

              SizedBox(width: AppSpacing.md),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      book.title,
                      style: AppTextStyles.heading2(
                        context,
                      ).copyWith(fontWeight: FontWeight.w600),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      book.author,
                      style: AppTextStyles.bodyMedium(context).copyWith(
                        color: theme.onSurface.withValues(
                          alpha: 0.5,
                        ), // لون باهت للمؤلف
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              HugeIcon(
                icon: HugeIcons.strokeRoundedArrowRight01,
                color: theme.onSurface.withValues(alpha: 0.4),
                size: 24.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
