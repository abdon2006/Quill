import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/theme/app_colors.dart';
import 'package:quill/core/theme/app_spacing.dart';

Widget buildRulesRow(String text, bool isMet, bool isDark, bool isPristine) {
  return Row(
    children: [
      HugeIcon(
        // لو متحقق: صح، لو لسه مبدأش: دايرة فاضية، لو كتب وغلط: علامة X
        icon: isMet
            ? HugeIcons.strokeRoundedTick02
            : (isPristine
                  ? HugeIcons.strokeRoundedRecord
                  : HugeIcons.strokeRoundedCancel01),
        color: isPristine
            ? (isDark
                  ? AppColors.lightTextMuted.withValues(alpha: 0.5)
                  : AppColors.lightTextMuted)
            : (isMet
                  ? (isDark ? AppColors.darkSuccess : AppColors.lightGreen)
                  : (isDark ? AppColors.darkError : AppColors.lightError)),
        size: AppSpacing.md,
      ),
      SizedBox(width: AppSpacing.sm),
      Text(
        text,
        textAlign: TextAlign.start,
        style: TextStyle(
          color: isPristine
              ? isDark
                    ? AppColors.lightTextMuted.withValues(alpha: 0.5)
                    : AppColors.lightTextMuted
              : isMet
              ? isDark
                    ? AppColors.darkSuccess
                    : AppColors.lightGreen
              : isDark
              ? AppColors.darkError
              : AppColors.lightError,
        ),
      ),
    ],
  );
}
