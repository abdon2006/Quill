import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/theme/app_duration.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_text_style.dart';
import 'package:quill/core/theme/app_spacing.dart';

Widget applyButton({
  required BuildContext context,
  required bool isStateChanged,
  required ColorScheme theme,
  required bool isDark,
  required void Function() onTap,
}) {
  return AnimatedPositioned(
    duration: AppDuration.normal,
    curve: Curves.easeOutBack,
    bottom: isStateChanged ? 20.h : -120.h,
    left: 0.15.sw,
    right: 0.15.sw,
    child: IgnorePointer(
      ignoring: !isStateChanged,
      child: AnimatedOpacity(
        opacity: isStateChanged ? 1.0 : 0.0,
        duration: AppDuration.normal,
        child: Material(
          color: theme.secondary,
          borderRadius: AppRadius.xl,
          elevation: 8,
          shadowColor: theme.secondary.withValues(alpha: 0.3),
          child: InkWell(
            onTap: onTap,
            borderRadius: AppRadius.xl,
            child: Container(
              height: 55.h,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedAiBeautify,
                    color: isDark ? theme.onSurface : theme.surface,
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Text(
                    "Apply",
                    style: AppTextStyles.heading1(
                      context,
                    ).copyWith(color: isDark ? theme.onSurface : theme.surface),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
