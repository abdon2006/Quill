import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/theme/app_colors.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_shadows.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';

enum ToastType { error, success }

class AppToast extends StatelessWidget {
  final String label;
  final String subLabel;
  final ToastType type;
  const AppToast({
    super.key,
    required this.label,
    required this.subLabel,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    return SafeArea(
      child: IntrinsicHeight(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.lg,
          ),
          decoration: BoxDecoration(
            borderRadius: AppRadius.xl,
            boxShadow: AppShadows.bottomNav,
            color: type == ToastType.error
                ? isDark
                      ? AppColors.darkError
                      : AppColors.lightError
                : isDark
                ? AppColors.darkSuccess
                : AppColors.lightGreen,
          ),
          child: Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: theme.surface.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: HugeIcon(
                      icon: type == ToastType.success
                          ? HugeIcons.strokeRoundedTick01
                          : HugeIcons.strokeRoundedWifiError01,
                      color: theme.onPrimary,
                    ),
                  ),
                ),

                SizedBox(width: AppSpacing.md),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: AppTextStyles.heading1(
                        context,
                      ).copyWith(color: theme.onPrimary),
                    ),
                    SizedBox(height: AppSpacing.xs),
                    Text(subLabel, style: AppTextStyles.caption(context)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
