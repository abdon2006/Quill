import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/features/home/domain/entities/book_entity.dart';

class TrendingBookCard extends StatelessWidget {
  final void Function() onTap;
  final BookEntity book;

  const TrendingBookCard({super.key, required this.book, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140.w,
        decoration: BoxDecoration(
          borderRadius: AppRadius.md,
          border: Border.all(
            color: theme.onSurface.withValues(alpha: 0.05),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: AppRadius.md,
          child: Image.network(
            book.coverImage,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: theme.onSurface.withValues(alpha: 0.1),
              child: const Center(child: Icon(Icons.book)),
            ),
          ),
        ),
      ),
    );
  }
}
