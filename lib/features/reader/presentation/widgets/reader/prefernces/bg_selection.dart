import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quill/core/theme/app_colors.dart';
import 'package:quill/core/theme/app_duration.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';

Widget bgSelection({
  required BuildContext context,
  required ColorScheme theme,
  required String label,
  required Color bgColor,
  required void Function() onTap,
  required bool isSelected,
  required bool isDark,
}) {
  return Expanded(
    child: InkWell(
      onTap: onTap,
      child: AnimatedScale(
        duration: AppDuration.normal,
        curve: Curves.easeInOutCubic,
        scale: isSelected ? 1.03 : 1,
        child: AnimatedContainer(
          height: 50.h,
          duration: AppDuration.normal,
          curve: Curves.easeInOutCubic,
          padding: EdgeInsets.all(AppSpacing.md),
          margin: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          decoration: BoxDecoration(
            borderRadius: AppRadius.sm,
            color: bgColor,
            border: Border.all(
              color: isSelected
                  ? theme.secondary
                  : isDark
                  ? AppColors.darkTextMuted.withValues(alpha: 0.15)
                  : AppColors.lightTextMuted.withValues(alpha: 0.15),
              width: isSelected ? 1.2 : 1,
            ),
          ),
          child: Center(
            child: DefaultTextStyle(
              style: AppTextStyles.bodyMedium(context).copyWith(
                color: isSelected
                    ? theme.secondary
                    : isDark
                    ? AppColors.darkTextMuted.withValues(alpha: 0.5)
                    : AppColors.lightTextMuted.withValues(alpha: 0.5),
                fontSize: 16.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
              ),
              child: Text(label),
            ),
          ),
        ),
      ),
    ),
  );
}
