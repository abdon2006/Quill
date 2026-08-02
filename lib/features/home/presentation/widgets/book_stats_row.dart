import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/theme/app_colors.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';

class BookStatsRow extends StatelessWidget {
  final int pages;
  final String lang;
  final double rating;
  const BookStatsRow({
    super.key,
    required this.pages,
    required this.lang,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildColumn(
          'Pages',
          Text("$pages", style: AppTextStyles.heading2(context)),
          context,
        ),
        _buildDevider(),

        _buildColumn(
          'Language',
          Text(lang, style: AppTextStyles.heading2(context)),
          context,
        ),

        _buildDevider(),

        _buildColumn(
          'Rating',
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('$rating', style: AppTextStyles.heading2(context)),
              SizedBox(width: AppSpacing.xs),
              HugeIcon(
                icon: HugeIcons.strokeRoundedStar,
                color: AppColors.darkGold,
                size: 16.sp,
              ),
            ],
          ),
          context,
        ),
      ],
    );
  }
}

Widget _buildColumn(String label, Widget sub, BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [Text(label), sub],
  );
}

Widget _buildDevider() {
  return Container(
    height: 30.h,
    width: 0.5.w,
    decoration: BoxDecoration(
      color: AppColors.lightTextMuted.withValues(alpha: 0.3),
      borderRadius: AppRadius.xl,
    ),
  );
}
