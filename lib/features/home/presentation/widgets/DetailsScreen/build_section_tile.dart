  import 'package:flutter/material.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';

Widget sectionTitle(
    BuildContext context, {
    required String eyebrow,
    required String title,
  }) {
    final theme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eyebrow,
          style: AppTextStyles.caption(context).copyWith(
            color: theme.primary,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.4,
          ),
        ),

        const SizedBox(height: AppSpacing.xs),

        Text(title, style: AppTextStyles.heading2(context)),
      ],
    );
  }