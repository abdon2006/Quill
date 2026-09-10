import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quill/core/theme/app_colors.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_shadows.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';

Widget milestoneNotch({
  required BuildContext context,
  required Animation<Offset> slide,
  required Animation<double> opacity,
  required ColorScheme theme,
  required String currentMessage,
  required int currentProgress,
}) => Positioned(
  left: 0,
  right: 0,
  top: MediaQuery.of(context).padding.top + AppSpacing.lg,
  child: SlideTransition(
    position: slide,
    child: FadeTransition(
      opacity: opacity,
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: theme.secondary,
            borderRadius: AppRadius.xl,
            boxShadow: AppShadows.elevated,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$currentProgress%',
                style: AppTextStyles.defaultReading(
                  context,
                ).copyWith(color: AppColors.darkTextPrimary),
              ),
              SizedBox(width: AppSpacing.sm),

              // خط فاصل صغير جداً
              Container(
                height: 12.h,
                width: 1.w,
                color: AppColors.lightTextMuted,
              ),

              SizedBox(width: AppSpacing.sm),
              Text(
                currentMessage,
                style: AppTextStyles.defaultReading(
                  context,
                ).copyWith(color: AppColors.darkTextPrimary),
              ),
            ],
          ),
        ),
      ),
    ),
  ),
);
