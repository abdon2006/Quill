import 'package:flutter/material.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';
import 'package:quill/features/home/presentation/widgets/DetailsScreen/build_section_tile.dart';

Widget buildAboutSection(BuildContext context, String aboutBook) {
  final theme = Theme.of(context).colorScheme;

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionTitle(context, eyebrow: 'THE STORY', title: 'About this book'),

        const SizedBox(height: AppSpacing.md),

        Text(
          aboutBook,
          style: AppTextStyles.heading2(context).copyWith(
            height: 1.65,
            color: theme.onSurface.withValues(alpha: 0.72),
          ),
        ),
      ],
    ),
  );
}
