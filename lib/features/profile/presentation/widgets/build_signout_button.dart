import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/theme/app_colors.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';

class BuildSignoutButton extends StatelessWidget {
  const BuildSignoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: theme.error.withValues(alpha: 0.07),
            borderRadius: AppRadius.xl,
          ),
          padding: EdgeInsets.all(AppSpacing.sm),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  borderRadius: AppRadius.md,
                  color: theme.error.withValues(alpha: 0.1),
                ),
                child: Center(
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedLogout02,
                    color: isDark ? AppColors.darkError : AppColors.lightError,
                  ),
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Sign out', style: AppTextStyles.heading1(context)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
