import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quill/core/theme/app_colors.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_shadows.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';
import 'package:quill/core/widgets/build_cover_placeholder.dart';
import 'package:quill/features/reader/data/models/local_book.dart';
import 'package:quill/features/reader/presentation/cubit/reader_preferences_state.dart';

class ReaderHeader extends StatelessWidget {
  final ReaderPreferencesState state;
  final int hours;
  final int mins;
  final LocalBook book;

  const ReaderHeader({
    super.key,
    required this.book,
    required this.hours,
    required this.mins,
    required this.state,
  });

  Color _getTextColor(ReaderPreferencesState state, BuildContext context) {
    return switch (state.theme) {
      ReaderTheme.dark => AppColors.darkTextPrimary,
      ReaderTheme.light => AppColors.lightTextPrimary,
      ReaderTheme.system =>
        state.bgColor == ReaderBgColor.dark
            ? AppColors.darkTextPrimary
            : AppColors.lightTextPrimary,
    };
  }

  Color _getMutedColor(ReaderPreferencesState state, BuildContext context) {
    return _getTextColor(state, context).withValues(alpha: 0.45);
  }

  @override
  Widget build(BuildContext context) {
    final textColor = _getTextColor(state, context);
    final mutedColor = _getMutedColor(state, context);
    final readingTime = hours > 0
        ? '$hours hr $mins min read'
        : '$mins min read';

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.xxl,
        vertical: AppSpacing.xl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 220.h,
            width: 155.w,
            decoration: BoxDecoration(
              borderRadius: AppRadius.lg,
              boxShadow: AppShadows.bookCover,
            ),
            child: ClipRRect(
              borderRadius: AppRadius.lg,
              child:
                  book.coverImagePath != null && book.coverImagePath!.isNotEmpty
                  ? Image.file(File(book.coverImagePath!), fit: BoxFit.cover)
                  : buildCoverPlaceholder(context),
            ),
          ),

          SizedBox(height: AppSpacing.xl),

          Container(
            width: 32.w,
            height: 1,
            color: textColor.withValues(alpha: 0.15),
          ),

          SizedBox(height: AppSpacing.lg),

          Text(
            book.title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.displayMedium(context).copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),

          SizedBox(height: AppSpacing.sm),

          // المؤلف
          Text(
            book.author,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium(context).copyWith(
              color: mutedColor,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.3,
            ),
          ),

          SizedBox(height: AppSpacing.lg),

          // وقت القراءة — pill هادي
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              borderRadius: AppRadius.xxl,
              color: textColor.withValues(alpha: 0.06),
            ),
            child: Text(
              readingTime,
              style: AppTextStyles.caption(context).copyWith(
                color: mutedColor,
                fontSize: 11.sp,
                letterSpacing: 0.5,
              ),
            ),
          ),

          SizedBox(height: AppSpacing.xxxl),
        ],
      ),
    );
  }
}
