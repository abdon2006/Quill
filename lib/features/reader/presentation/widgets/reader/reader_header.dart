import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_shadows.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';
import 'package:quill/core/widgets/build_cover_placeholder.dart';
import 'package:quill/features/reader/data/models/local_book.dart';

class ReaderHeader extends StatelessWidget {
  final int hours;
  final int mins;
  final LocalBook book;
  const ReaderHeader({
    super.key,
    required this.book,
    required this.hours,
    required this.mins,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: AppRadius.xl,
        color: theme.surface,
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  overflow: TextOverflow.ellipsis,
                  book.title,
                  style: AppTextStyles.heading1(
                    context,
                  ).copyWith(color: theme.primary),
                ),
                Text(
                  overflow: TextOverflow.ellipsis,
                  book.author,
                  style: AppTextStyles.caption(
                    context,
                  ).copyWith(fontSize: 12.sp),
                ),

                Text(
                  hours > 0 ? '$hours hr $mins min read' : '$mins min read',
                  style: AppTextStyles.caption(
                    context,
                  ).copyWith(fontSize: 12.sp),
                ),
              ],
            ),
          ),
          Container(
            height: 150.h,
            width: 100.w,
            margin: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            decoration: BoxDecoration(borderRadius: AppRadius.md),

            child: ClipRRect(
              borderRadius: AppRadius.md,
              child:
                  book.coverImagePath != null && book.coverImagePath!.isNotEmpty
                  ? Image.file(File(book.coverImagePath!), fit: BoxFit.cover)
                  : buildCoverPlaceholder(context),
            ),
          ),
        ],
      ),
    );
  }
}
