import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quill/core/router/app_router.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_shadows.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';
import 'package:quill/core/widgets/app_button.dart';

class EmptyServerBook extends StatelessWidget {
  const EmptyServerBook({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppRadius.xxl,
        boxShadow: AppShadows.card,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: AppSpacing.sm),
          Text(
            '✦',
            style: AppTextStyles.symbol(context),
          ),
          SizedBox(height: AppSpacing.sm),

          Text(
            'You haven\'t added any books to your Wishlist.',
            style: AppTextStyles.heading2(context),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            'Bring a story here and make\nthis space yours.',
            style: AppTextStyles.bodyMedium(
              context,
            ).copyWith(color: colors.onSurface.withValues(alpha: 0.5)),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.md),
          AppButton.secondary(
            text: 'Browse Books',
            onPressed: () => context.go(AppRoutes.discover),
          ),
        ],
      ),
    );
  }
}
