import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/theme/app_duration.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';

Widget themeSelection({
  required BuildContext context,
  required ColorScheme theme,
  required String label,
  required Color borderColor,
  required Color bgColor,
  required Color fgColor,
  required List<List<dynamic>> icon,
  required void Function() onTap,
  required bool isSelected,
}) {
  return Expanded(
    child: InkWell(
      onTap: onTap,
      child: AnimatedScale(
        duration: AppDuration.normal,
        curve: Curves.easeInOutCubic,
        scale: isSelected ? 1.02 : 1,
        child: AnimatedContainer(
          duration: AppDuration.normal,
          curve: Curves.easeInOutCubic,
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.md,
          ),
          margin: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          decoration: BoxDecoration(
            borderRadius: AppRadius.sm,
            color: bgColor,
            border: Border.all(color: borderColor, width: 1.5),
          ),
          child: Column(
            children: [
              HugeIcon(icon: icon, color: fgColor),
              Text(
                label,
                style: AppTextStyles.bodyMedium(
                  context,
                ).copyWith(color: fgColor, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
