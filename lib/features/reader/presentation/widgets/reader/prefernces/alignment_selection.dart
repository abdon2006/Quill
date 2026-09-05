
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/theme/app_colors.dart';
import 'package:quill/core/theme/app_duration.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';

Widget buildAlignmentSelection({
  required BuildContext context,
    required void Function() onTap,
    required bool isSelected,
    required ColorScheme theme,
    required String label,
    required List<List<dynamic>> icon,
    required bool isDark,
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
              color: theme.surface.withValues(alpha: 0.2),
              border: Border.all(
                color: isSelected
                    ? theme.secondary
                    : isDark
                    ? AppColors.darkTextMuted.withValues(alpha: 0.2)
                    : AppColors.lightTextMuted.withValues(alpha: 0.2),
                width: isSelected ? 1.2 : 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                HugeIcon(
                  icon: icon,
                  color: isSelected
                      ? theme.secondary
                      : theme.onSurface.withValues(alpha: 0.4),
                ),
                Text(
                  label,
                  style: AppTextStyles.bodyMedium(context).copyWith(
                    color: isSelected
                        ? theme.secondary
                        : theme.onSurface.withValues(alpha: 0.4),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
