import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';
import 'package:quill/features/home/domain/entities/book_entity.dart';

class BookListTile extends StatelessWidget {
  final BookEntity book;
  const BookListTile({super.key, required this.book});
  String timeAgo(DateTime createdAt) {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()} weeks ago';
    return '${(diff.inDays / 30).floor()} months ago';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final createdAgo = timeAgo(book.createdAt);
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppSpacing.md,
        horizontal: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        borderRadius: AppRadius.xl,
        color: theme.colorScheme.surface,
      ),
      child: Row(
        children: [
          Container(
            height: 70.h,
            decoration: BoxDecoration(borderRadius: AppRadius.xs),
            child: ClipRRect(
              borderRadius: AppRadius.xs,
              child: Image.network(book.coverImage),
            ),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.title,
                  style: AppTextStyles.bodyMedium(
                    context,
                  ).copyWith(fontWeight: FontWeight.bold),
                ),
                Text(book.author, style: AppTextStyles.caption(context)),
                Text(createdAgo, style: AppTextStyles.caption(context)),
              ],
            ),
          ),
          HugeIcon(icon: HugeIcons.strokeRoundedArrowRight01),
        ],
      ),
    );
  }
}
