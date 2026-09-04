import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/theme/app_colors.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';
import 'package:quill/features/reader/presentation/cubit/reader_preferences_cubit.dart';
import 'package:quill/features/reader/presentation/cubit/reader_preferences_state.dart';
import 'package:quill/features/reader/presentation/widgets/reader/prefernces/bg_selection.dart';
import 'package:quill/features/reader/presentation/widgets/reader/prefernces/build_font_badge.dart';
import 'package:quill/features/reader/presentation/widgets/reader/prefernces/theme_selection.dart';

class ReaderPreferencesSheet extends StatefulWidget {
  const ReaderPreferencesSheet({super.key});

  @override
  State<ReaderPreferencesSheet> createState() => _ReaderPreferencesSheetState();
}

class _ReaderPreferencesSheetState extends State<ReaderPreferencesSheet> {
  Widget _buildThemeSection({required BuildContext context}) {
    final theme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final List<Map<String, dynamic>> themeSelectionData = [
      {
        'label': 'System',
        'bgColor': isDark
            ? AppColors.darkBgSurfaceAlt
            : AppColors.lightBgPrimary,
        'fgColor': theme.onSurface,
        'theme': ReaderTheme.system,
        'icon': HugeIcons.strokeRoundedComponent,
      },
      {
        'label': 'Light',
        'bgColor': isDark
            ? theme.onSurface
            : theme.onSurface.withValues(alpha: 0.05),
        'fgColor': isDark ? theme.surface : theme.onSurface,
        'theme': ReaderTheme.light,
        'icon': HugeIcons.strokeRoundedSun01,
      },
      {
        'label': 'Dark',
        'bgColor': isDark ? AppColors.darkBgPrimary : AppColors.darkBgSurface,
        'fgColor': isDark ? theme.onSurface : theme.surface,
        'theme': ReaderTheme.dark,
        'icon': HugeIcons.strokeRoundedMoon01,
      },
    ];
    VoidCallback handleOnTap(int i) {
      return switch (i) {
        0 => () => setState(
          () => context.read<ReaderPreferencesCubit>().setTheme(
            ReaderTheme.system,
          ),
        ),

        1 => () => setState(
          () => context.read<ReaderPreferencesCubit>().setTheme(
            ReaderTheme.light,
          ),
        ),

        2 => () => setState(
          () =>
              context.read<ReaderPreferencesCubit>().setTheme(ReaderTheme.dark),
        ),
        int() => throw UnimplementedError(),
      };
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Theme',
          style: AppTextStyles.heading1(
            context,
          ).copyWith(color: AppColors.lightTextMuted),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: List.generate(3, (i) {
            final item = themeSelectionData[i];
            final state = context.read<ReaderPreferencesCubit>().state;
            bool isSelected = item['theme'] == state.theme;
            return themeSelection(
              context: context,
              theme: theme,
              label: item['label'],
              borderColor: isSelected ? theme.secondary : theme.surface,
              bgColor: item['bgColor'],
              fgColor: item['fgColor'],
              icon: item['icon'],
              isSelected: isSelected,
              onTap: handleOnTap(i),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildIndicator(ColorScheme theme) {
    return Container(
      width: 36.w,
      height: 4.h,
      decoration: BoxDecoration(
        color: theme.onSurface.withValues(alpha: 0.15),
        borderRadius: AppRadius.lg,
      ),
    );
  }

  Widget _buildBgSelection({
    required BuildContext context,
    required ColorScheme theme,
  }) {
    VoidCallback handleOnTap(int i) {
      return switch (i) {
        0 => () => setState(
          () => context.read<ReaderPreferencesCubit>().setBgColor(
            ReaderBgColor.warm,
          ),
        ),
        1 => () => setState(
          () => context.read<ReaderPreferencesCubit>().setBgColor(
            ReaderBgColor.cream,
          ),
        ),
        2 => () => setState(
          () => context.read<ReaderPreferencesCubit>().setBgColor(
            ReaderBgColor.white,
          ),
        ),
        3 => () => setState(
          () => context.read<ReaderPreferencesCubit>().setBgColor(
            ReaderBgColor.dark,
          ),
        ),
        _ => throw UnimplementedError(),
      };
    }

    final List<Map<String, dynamic>> bgSelectionData = [
      {
        'label': 'Warm', 'color': AppColors.warm, 'value': ReaderBgColor.warm,
        // 'fgColor' :
      },
      {
        'label': 'Cream',
        'color': AppColors.cream,
        'value': ReaderBgColor.cream,
        // 'fgColor' :
      },
      {
        'label': 'White',
        'color': AppColors.white,
        'value': ReaderBgColor.white,
        // 'fgColor' :
      },
      {
        'label': 'Dark', 'color': AppColors.dark, 'value': ReaderBgColor.dark,
        // 'fgColor' :
      },
    ];
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Background',
          style: AppTextStyles.heading1(
            context,
          ).copyWith(color: AppColors.lightTextMuted),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: List.generate(4, (i) {
            final item = bgSelectionData[i];
            final state = context.read<ReaderPreferencesCubit>().state;
            bool isSelected = state.bgColor == item['value'];
            return bgSelection(
              context: context,
              theme: theme,
              label: item['label'],
              bgColor: item['color'],
              onTap: handleOnTap(i),
              isDark: isDark,
              isSelected: isSelected,
            );
          }),
        ),
      ],
    );
  }

  Widget _buildFontSection({
    required BuildContext context,
    required ColorScheme theme,
  }) {
    VoidCallback handleOnTap(int i) {
      return switch (i) {
        0 => () => setState(
          () => context.read<ReaderPreferencesCubit>().setFontFamily(
            ReaderFontFamily.plusJakartaSans,
          ),
        ),
        1 => () => setState(
          () => context.read<ReaderPreferencesCubit>().setFontFamily(
            ReaderFontFamily.lora,
          ),
        ),
        2 => () => setState(
          () => context.read<ReaderPreferencesCubit>().setFontFamily(
            ReaderFontFamily.merriweather,
          ),
        ),
        int() => throw UnimplementedError(),
      };
    }

    final isDark = theme.brightness == Brightness.dark;
    final List<Map<String, dynamic>> fontsData = [
      {
        'label': 'Jakarta',
        'value': ReaderFontFamily.plusJakartaSans,
        'font': ReaderFontFamily.plusJakartaSans.fontName,
      },
      {
        'label': 'Lora',
        'value': ReaderFontFamily.lora,
        'font': ReaderFontFamily.lora.fontName,
      },
      {
        'label': 'Merri',
        'value': ReaderFontFamily.merriweather,
        'font': ReaderFontFamily.merriweather.fontName,
      },
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Font',
          style: AppTextStyles.heading1(
            context,
          ).copyWith(color: AppColors.lightTextMuted),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: List.generate(fontsData.length, (i) {
            final state = context.read<ReaderPreferencesCubit>().state;
            final item = fontsData[i];
            bool isSelected = state.fontFamily == item['value'];
            return buildFontBadge(
              onTap: handleOnTap(i),
              context: context,
              isSelected: isSelected,
              theme: theme,
              label: item['label'],
              isDark: isDark,
              fontFamily: item['font'],
            );
          }),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.xxl,
      ),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildIndicator(theme),
          const SizedBox(height: AppSpacing.xxl),
          _buildThemeSection(context: context),
          const SizedBox(height: AppSpacing.xl),
          _buildBgSelection(context: context, theme: theme),
          const SizedBox(height: AppSpacing.xl),
          _buildFontSection(context: context, theme: theme),
        ],
      ),
    );
  }
}
