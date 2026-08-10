  import 'package:flutter/material.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';
import 'package:quill/features/home/presentation/widgets/DetailsScreen/build_section_tile.dart';

Widget buildTopicsSection(BuildContext context , List<String> categories) {
    final theme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionTitle(context, eyebrow: 'EXPLORE', title: 'Topics'),

          const SizedBox(height: AppSpacing.md),

          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children:categories.map((category) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  borderRadius: AppRadius.xxl,
                  color: theme.primary.withValues(alpha: 0.10),
                  border: Border.all(
                    color: theme.primary.withValues(alpha: 0.16),
                  ),
                ),
                child: Text(
                  category,
                  style: AppTextStyles.caption(
                    context,
                  ).copyWith(color: theme.primary),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }