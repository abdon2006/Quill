import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/theme/app_colors.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';
import 'package:quill/features/profile/presentation/widgets/build_section.dart';

class BuildImportSection extends StatelessWidget {
  const BuildImportSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Library',
          style: AppTextStyles.defaultReading(context).copyWith(
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          ),
        ),
        SizedBox(height: AppSpacing.sm),

        Container(
          padding: EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            borderRadius: AppRadius.xl,
            color: theme.surface,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildSection(
                theme: theme,
                context: context,
                title: 'Storage & Imports',
                subTitle: 'Your uploaded books',
                icon: HugeIcons.strokeRoundedDatabase,
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
