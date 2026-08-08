import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';

class AppError extends StatelessWidget {
  final String title;
  final VoidCallback onRetry;
  const AppError({super.key, required this.title, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        HugeIcon(
          icon: HugeIcons.strokeRoundedWifiError01,
          size: AppSpacing.xxxl,
          color: theme.colorScheme.primary,
        ),
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyLarge(
            context,
          ).copyWith(color: theme.colorScheme.onSurface),
        ),
        // Text(subTitle, textAlign: TextAlign.center),
      ],
    );
  }
}
