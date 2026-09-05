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
import 'package:quill/features/reader/presentation/widgets/reader/prefernces/alignment_selection.dart';
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

  Widget _buildFontSizeSlider({required BuildContext context}) {
    final state = context.read<ReaderPreferencesCubit>().state;
    final theme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Font Size',
          style: AppTextStyles.heading1(
            context,
          ).copyWith(color: AppColors.lightTextMuted),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            HugeIcon(icon: HugeIcons.strokeRoundedTextFont, size: 14.sp),
            Expanded(
              child: SliderTheme(
                data: SliderThemeData(
                  trackHeight: 2,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 16),
                  thumbColor: theme.secondary,
                  activeTrackColor: theme.secondary,
                  inactiveTrackColor: theme.onSurface.withValues(alpha: 0.08),
                  overlayColor: theme.secondary.withValues(alpha: 0.1),
                ),
                child: Slider(
                  activeColor: theme.secondary,
                  inactiveColor: theme.onSurface.withValues(alpha: 0.1),
                  min: 14,
                  max: 24,
                  value: state.fontSize,
                  onChanged: (double val) => setState(() {
                    context.read<ReaderPreferencesCubit>().setFontSize(val);
                  }),
                ),
              ),
            ),

            HugeIcon(icon: HugeIcons.strokeRoundedTextFont, size: 24.sp),

            const SizedBox(width: AppSpacing.sm),
            DefaultTextStyle(
              style: AppTextStyles.caption(
                context,
              ).copyWith(fontSize: 20, color: theme.secondary),
              child: Text('${state.fontSize.toInt()}px'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLineSpacingSlider({required BuildContext context}) {
    final state = context.read<ReaderPreferencesCubit>().state;
    final theme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Line Spacing',
          style: AppTextStyles.heading1(
            context,
          ).copyWith(color: AppColors.lightTextMuted),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            HugeIcon(
              icon: HugeIcons.strokeRoundedParagraphSpacing,
              size: 16.sp,
            ),
            Expanded(
              child: SliderTheme(
                data: SliderThemeData(
                  trackHeight: 2,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 16),
                  thumbColor: theme.secondary,
                  activeTrackColor: theme.secondary,
                  inactiveTrackColor: theme.onSurface.withValues(alpha: 0.08),
                  overlayColor: theme.secondary.withValues(alpha: 0.1),
                ),
                child: Slider(
                  activeColor: theme.secondary,
                  inactiveColor: theme.onSurface.withValues(alpha: 0.1),
                  min: 1.2,
                  max: 2.4,
                  value: state.lineSpacing,
                  onChanged: (double val) => setState(() {
                    context.read<ReaderPreferencesCubit>().setLineSpacing(val);
                  }),
                ),
              ),
            ),

            const SizedBox(width: AppSpacing.sm),
            Text(
              '${state.lineSpacing.toStringAsFixed(1)}px',
              style: AppTextStyles.caption(
                context,
              ).copyWith(fontSize: 20, color: theme.secondary),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAlignmentSection({required BuildContext context}) {
    void handleAlignmentTap(int i) {
      return switch (i) {
        0 => setState(
          () => context.read<ReaderPreferencesCubit>().setIsJustified(true),
        ),
        1 => setState(
          () => context.read<ReaderPreferencesCubit>().setIsJustified(false),
        ),
        _ => throw UnimplementedError(),
      };
    }

    final theme = Theme.of(context).colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final state = context.read<ReaderPreferencesCubit>().state;
    final List<Map<String, dynamic>> alignmentData = [
      {
        'label': "Justified",
        'icon': HugeIcons.strokeRoundedTextAlignJustifyCenter,
        'isJustified': true,
      },
      {
        'label': "Left",
        'icon': HugeIcons.strokeRoundedTextAlignLeft,
        'isJustified': false,
      },
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Alignment',
          style: AppTextStyles.heading1(
            context,
          ).copyWith(color: AppColors.lightTextMuted),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: List.generate(2, (i) {
            final item = alignmentData[i];
            return buildAlignmentSelection(
              onTap: () => handleAlignmentTap(i),
              isSelected: item['isJustified'] == state.isJustified,
              theme: theme,
              label: item['label'],
              icon: item['icon'],
              isDark: isDark,
              context: context,
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
      child: Stack(
        children: [
          SingleChildScrollView(
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
                const SizedBox(height: AppSpacing.xl),
                _buildFontSizeSlider(context: context),
                const SizedBox(height: AppSpacing.xl),
                _buildLineSpacingSlider(context: context),
                const SizedBox(height: AppSpacing.xl),
                _buildAlignmentSection(context: context),
                const SizedBox(height: 200),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Container(
                height: 60.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [theme.surface.withValues(alpha: 0), theme.surface],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
