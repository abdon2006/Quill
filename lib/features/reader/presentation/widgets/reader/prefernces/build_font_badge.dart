import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quill/core/theme/app_colors.dart';
import 'package:quill/core/theme/app_duration.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';

Widget buildFontBadge({
  required void Function() onTap,
  required BuildContext context,
  required bool isSelected,
  required ColorScheme theme,
  required String label,
  required bool isDark,
  required String fontFamily,
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
          padding: EdgeInsets.all(AppSpacing.sm),
          margin: EdgeInsets.symmetric(horizontal: AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: AppRadius.md,
            color: isSelected
                ? theme.secondary
                : isDark
                ? theme.onSurface.withValues(alpha: 0.02)
                : theme.onSurface.withValues(alpha: 0.05),
          ),
          child: Center(
            child: DefaultTextStyle(
              style: AppTextStyles.bodyMedium(context).copyWith(
                fontFamily: fontFamily,
                color: isSelected
                    ? isDark
                          ? theme.onSurface
                          : theme.surface
                    : isDark
                    ? AppColors.darkTextMuted
                    : AppColors.lightTextMuted,
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
