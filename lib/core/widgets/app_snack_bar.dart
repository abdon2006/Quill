import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';

class AppSnackBar extends StatelessWidget {
  final String message;
  final String messageDisc;
  const AppSnackBar({
    super.key,
    required this.message,
    required this.messageDisc,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.xl,
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppSpacing.md),

            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.2),
              borderRadius: AppRadius.md,
            ),
            child: Center(
              child: HugeIcon(
                icon: HugeIcons.strokeRoundedWifiError01,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(message, style: AppTextStyles.heading1(context)),
              Text(messageDisc, style: AppTextStyles.caption(context)),
            ],
          ),
        ],
      ),
    );
  }
}
