import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quill/core/theme/app_colors.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';

Widget bottomDock({
  required BuildContext context,
  required bool isDockExpanded,
  required ColorScheme theme,
  required String dockMessage,
}) => Positioned(
  left: 50.w,
  right: 50.w,
  bottom: 0,
  child: AnimatedOpacity(
    duration: Duration(milliseconds: 650),
    curve: Curves.easeInOutCubic,
    opacity: isDockExpanded ? 1 : 0.7,
    child: AnimatedContainer(
      height: isDockExpanded ? 42.h : 4.h,
      duration: Duration(milliseconds: 650),
      curve: Curves.easeInOutCubic,
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
      padding: EdgeInsets.symmetric(
        vertical: AppSpacing.md,
        horizontal: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: theme.secondary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.sp)),
      ),

      child: Center(
        child: AnimatedDefaultTextStyle(
          duration: Duration(milliseconds: 650),
          curve: Curves.easeInOutCubic,
          style: AppTextStyles.heading2(
            context,
          ).copyWith(color: AppColors.darkTextPrimary, fontSize: 16.sp),
          child: Text(dockMessage),
        ),
      ),
    ),
  ),
);
