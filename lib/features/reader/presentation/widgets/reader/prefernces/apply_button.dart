import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/theme/app_duration.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_shadows.dart';
import 'package:quill/core/theme/app_text_style.dart';

Widget applyButton({
  required BuildContext context,
  required bool isStateChanged,
  required ColorScheme theme,
  required bool isDark,
  required void Function() onTap
}) {
  return Positioned(
    bottom: 0.h,
    left: 80.w,
    right: 80.w,
    child: AnimatedSlide(
      curve: Curves.easeInOutCubic,
      duration: AppDuration.slow,
      offset: isStateChanged ? Offset(0, 0) : Offset(0, 2),
      child: AnimatedOpacity(
        opacity: isStateChanged ? 1.0 : 0.0,
        duration: AppDuration.slow,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Container(
              height: 60.h,
              decoration: BoxDecoration(
                color: theme.secondary,
                borderRadius: AppRadius.xl,
                boxShadow: AppShadows.bottomNav,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedAiBeautify,
                    color: isDark ? theme.onSurface : theme.surface,
                  ),
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
