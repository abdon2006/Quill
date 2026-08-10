import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_shadows.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';

class BookCoverHeader extends StatelessWidget {
  final String bookCover;
  final String bookTitle;
  const BookCoverHeader({
    super.key,
    required this.bookCover,
    required this.bookTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 250.h,
          width: 160.w,
          margin: EdgeInsets.symmetric(vertical: AppSpacing.lg),
          decoration: BoxDecoration(
            borderRadius: AppRadius.xl,
            boxShadow: AppShadows.bookCover,
          ),
          child: ClipRRect(
            borderRadius: AppRadius.xl,
            child: Image.network(bookCover, fit: BoxFit.cover),
          ),
        ),
        Text(
          bookTitle,
          style: AppTextStyles.displayMedium(context),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
