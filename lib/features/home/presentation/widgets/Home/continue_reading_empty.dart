import 'package:flutter/material.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_shadows.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';
import 'package:quill/core/widgets/app_button.dart';
import 'package:quill/features/library/presentation/widgets/import_book_bottom_sheet.dart';

class ContinueReadingEmpty extends StatelessWidget {
  final VoidCallback onImport;
  const ContinueReadingEmpty({super.key, required this.onImport});

  void _openImportSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      // ─────────────────────────────
      builder: (_) => const ImportBookBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
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
            style: TextStyle(
              fontSize: 32,
              color: colors.primary.withValues(alpha: 0.4),
            ),
          ),
          SizedBox(height: AppSpacing.sm),

          Text(
            'Your reading corner is waiting.',
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
            text: 'Import a book',
            onPressed: () => _openImportSheet(context),
          ),
        ],
      ),
    );
  }
}
