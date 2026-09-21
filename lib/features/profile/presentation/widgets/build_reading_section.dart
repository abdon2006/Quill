import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/router/app_router.dart';
import 'package:quill/core/theme/app_colors.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';
import 'package:quill/features/profile/presentation/widgets/build_section.dart';

class BuildReadingSection extends StatelessWidget {
  final void Function() onPreferencesOpened;
  const BuildReadingSection({super.key, required this.onPreferencesOpened});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Reading',
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
                title: 'ReaderPreference',
                subTitle: 'Font, spacing , theme',
                icon: HugeIcons.strokeRoundedBookOpen02,
                onTap: () => onPreferencesOpened(),
              ),
              Divider(
                color: isDark
                    ? AppColors.darkTextMuted.withValues(alpha: 0.1)
                    : AppColors.lightTextMuted.withValues(alpha: 0.1),
              ),
              buildSection(
                  theme: theme,
                  context: context,
                  title: 'Dashboard',
                  subTitle: 'books Completed , streaks',
                  icon: HugeIcons.strokeRoundedDashboardSquare02,
                  onTap: () => context.push(AppRoutes.dashboard),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
