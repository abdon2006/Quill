import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/theme/app_colors.dart';
import 'package:quill/core/theme/app_duration.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';
import 'package:quill/features/reader/presentation/cubit/reader_preferences_cubit.dart';
import 'package:quill/features/reader/presentation/cubit/reader_preferences_state.dart';
import 'package:quill/features/reader/presentation/widgets/reader/prefernces/alignment_selection.dart';
import 'package:quill/features/reader/presentation/widgets/reader/prefernces/apply_button.dart';
import 'package:quill/features/reader/presentation/widgets/reader/prefernces/bg_selection.dart';
import 'package:quill/features/reader/presentation/widgets/reader/prefernces/build_font_badge.dart';
import 'package:quill/features/reader/presentation/widgets/reader/prefernces/theme_selection.dart';

class ReaderPreferencesSheet extends StatefulWidget {
  const ReaderPreferencesSheet({super.key});

  @override
  State<ReaderPreferencesSheet> createState() => _ReaderPreferencesSheetState();
}

class _ReaderPreferencesSheetState extends State<ReaderPreferencesSheet> {
  late ReaderPreferencesState _tempState;
  @override
  void initState() {
    super.initState();
    _tempState = context.read<ReaderPreferencesCubit>().state;
  }

  Widget _buildPreview({required ColorScheme theme}) {
    ReaderPreferencesState state = _tempState;
    final isDark = theme.brightness == Brightness.dark;
    return AnimatedContainer(
      duration: AppDuration.slow,
      curve: Curves.easeInOutCubic,
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        border: Border.all(
          color: isDark
              ? state.bgColor == ReaderBgColor.dark
                    ? theme.onSurface.withValues(alpha: 0.2)
                    : theme.surface
              : state.bgColor == ReaderBgColor.white
              ? theme.onSurface.withValues(alpha: 0.2)
              : theme.surface,
        ),
        borderRadius: AppRadius.xl,
        color: switch (state.bgColor) {
          ReaderBgColor.cream => AppColors.cream,
          ReaderBgColor.warm => AppColors.warm,
          ReaderBgColor.white => AppColors.white,
          ReaderBgColor.dark => AppColors.dark,
        },
      ),
      child: AnimatedDefaultTextStyle(
        duration: AppDuration.normal,
        curve: Curves.easeInOutCubic,
        textAlign: state.isJustified ? TextAlign.justify : TextAlign.start,
        style: AppTextStyles.defaultReading(context).copyWith(
          fontFamily: switch (state.fontFamily) {
            ReaderFontFamily.plusJakartaSans =>
              ReaderFontFamily.plusJakartaSans.fontName,
            ReaderFontFamily.lora => ReaderFontFamily.lora.fontName,
            ReaderFontFamily.merriweather =>
              ReaderFontFamily.merriweather.fontName,
          },
          color: isDark
              ? state.bgColor == ReaderBgColor.dark
                    ? theme.onSurface
                    : theme.surface
              : switch (state.bgColor) {
                  ReaderBgColor.warm => theme.onSurface,
                  ReaderBgColor.cream => theme.onSurface,
                  ReaderBgColor.white => theme.onSurface,
                  ReaderBgColor.dark => theme.surface,
                },
          height: _tempState.lineSpacing,
          fontSize: _tempState.fontSize,
          fontWeight: _tempState.isBold ? FontWeight.bold : FontWeight.normal,
          fontStyle: _tempState.isItalic ? FontStyle.italic : FontStyle.normal,
        ),
        child: Text(
          'The sun sets slowly over the quiet hills, casting a warm golden glow across the valley below.',
        ),
      ),
    );
  }

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
          () => _tempState = _tempState.copyWith(theme: ReaderTheme.system),
        ),

        1 => () => setState(
          () => _tempState = _tempState.copyWith(theme: ReaderTheme.light),
        ),

        2 => () => setState(
          () => _tempState = _tempState.copyWith(theme: ReaderTheme.dark),
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
            bool isSelected = item['theme'] == _tempState.theme;
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
          () => _tempState = _tempState.copyWith(bgColor: ReaderBgColor.warm),
        ),
        1 => () => setState(
          () => _tempState = _tempState.copyWith(bgColor: ReaderBgColor.cream),
        ),
        2 => () => setState(
          () => _tempState = _tempState.copyWith(bgColor: ReaderBgColor.white),
        ),
        3 => () => setState(
          () => _tempState = _tempState.copyWith(bgColor: ReaderBgColor.dark),
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
            bool isSelected = _tempState.bgColor == item['value'];
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
          () => _tempState = _tempState.copyWith(
            fontFamily: ReaderFontFamily.plusJakartaSans,
          ),
        ),
        1 => () => setState(
          () => _tempState = _tempState.copyWith(
            fontFamily: ReaderFontFamily.lora,
          ),
        ),
        2 => () => setState(
          () => _tempState = _tempState.copyWith(
            fontFamily: ReaderFontFamily.merriweather,
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
            final item = fontsData[i];
            bool isSelected = _tempState.fontFamily == item['value'];
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

  Widget _buildFontCustomization({required ColorScheme theme}) {
    bool isBold = _tempState.isBold;
    bool isItalic = _tempState.isItalic;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () => setState(
            () => _tempState = _tempState.copyWith(isBold: !_tempState.isBold),
          ),
          child: AnimatedScale(
            scale: isBold ? 1.03 : 1,
            duration: AppDuration.normal,
            curve: Curves.easeInOutCubic,
            child: AnimatedContainer(
              duration: AppDuration.normal,
              curve: Curves.easeInOutCubic,
              margin: EdgeInsets.all(AppSpacing.sm),
              padding: EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                borderRadius: AppRadius.lg,
                border: Border.all(
                  color: isBold
                      ? theme.secondary
                      : theme.onSurface.withValues(alpha: 0.1),
                ),
              ),
              child: HugeIcon(
                size: AppSpacing.xl,
                color: isBold
                    ? theme.secondary
                    : theme.onSurface.withValues(alpha: 0.3),
                icon: HugeIcons.strokeRoundedTextBold,
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () => setState(
            () => _tempState = _tempState.copyWith(
              isItalic: !_tempState.isItalic,
            ),
          ),
          child: AnimatedScale(
            scale: isItalic ? 1.03 : 1,
            duration: AppDuration.normal,
            curve: Curves.easeInOutCubic,
            child: AnimatedContainer(
              duration: AppDuration.normal,
              curve: Curves.easeInOutCubic,
              margin: EdgeInsets.all(AppSpacing.sm),
              padding: EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                borderRadius: AppRadius.lg,
                border: Border.all(
                  color: isItalic
                      ? theme.secondary
                      : theme.onSurface.withValues(alpha: 0.1),
                ),
              ),
              child: HugeIcon(
                size: AppSpacing.xl,
                color: isItalic
                    ? theme.secondary
                    : theme.onSurface.withValues(alpha: 0.3),
                icon: HugeIcons.strokeRoundedTextItalic,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFontSizeSlider({required BuildContext context}) {
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
                  value: _tempState.fontSize,
                  onChanged: (double val) => setState(
                    () => _tempState = _tempState.copyWith(fontSize: val),
                  ),
                ),
              ),
            ),

            HugeIcon(icon: HugeIcons.strokeRoundedTextFont, size: 24.sp),

            const SizedBox(width: AppSpacing.sm),
            DefaultTextStyle(
              style: AppTextStyles.caption(
                context,
              ).copyWith(fontSize: 20, color: theme.secondary),
              child: Text('${_tempState.fontSize.toInt()}px'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLineSpacingSlider({required BuildContext context}) {
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
                  value: _tempState.lineSpacing,
                  onChanged: (double val) => setState(
                    () => _tempState = _tempState.copyWith(lineSpacing: val),
                  ),
                ),
              ),
            ),

            const SizedBox(width: AppSpacing.sm),
            Text(
              '${_tempState.lineSpacing.toStringAsFixed(1)}px',
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
          () => _tempState = _tempState.copyWith(isJustified: true),
        ),
        1 => setState(
          () => _tempState = _tempState.copyWith(isJustified: false),
        ),
        _ => throw UnimplementedError(),
      };
    }

    final theme = Theme.of(context).colorScheme;
    final isDark = theme.brightness == Brightness.dark;
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
              isSelected: item['isJustified'] == _tempState.isJustified,
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

  Widget _buildScrollSelectionChip({required ColorScheme theme}) {
    final List<Map<String, dynamic>> chipsData = [
      {
        'label': 'Scroll',
        'value': ReaderScrollMode.scroll,
        'icon': HugeIcons.strokeRoundedCarouselVertical,
      },
      {
        'label': 'Pages',
        'value': ReaderScrollMode.pages,
        'icon': HugeIcons.strokeRoundedBookOpenText,
      },
    ];
    int selectedIndex = _tempState.scrollMode == ReaderScrollMode.scroll
        ? 0
        : 1;
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = constraints.maxWidth / 2;
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 50.h,
              padding: EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                borderRadius: AppRadius.xxl,
                color: theme.onSurface.withValues(alpha: 0.1),
              ),
            ),
            AnimatedPositioned(
              width: itemWidth,
              left: selectedIndex * itemWidth,
              duration: AppDuration.normal,
              curve: Curves.easeInOutCubic,
              child: Container(
                height: 50.h,
                decoration: BoxDecoration(
                  borderRadius: AppRadius.xxl,
                  color: theme.secondary,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(2, (i) {
                final item = chipsData[i];
                bool isSelected = _tempState.scrollMode == item['value'];
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    setState(() {
                      selectedIndex = i;
                      switch (i) {
                        case 0:
                          _tempState = _tempState.copyWith(
                            scrollMode: ReaderScrollMode.scroll,
                          );
                          break;
                        case 1:
                          _tempState = _tempState.copyWith(
                            scrollMode: ReaderScrollMode.pages,
                          );
                          break;
                        default:
                      }
                    });
                  },
                  child: AnimatedContainer(
                    duration: AppDuration.normal,
                    curve: Curves.easeInOutCubic,
                    width: itemWidth,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          HugeIcon(
                            icon: item['icon'],
                            color: isSelected
                                ? isDark
                                      ? theme.onSurface
                                      : theme.surface
                                : theme.onSurface.withValues(alpha: 0.5),
                          ),
                          const SizedBox(width: AppSpacing.lg),
                          AnimatedDefaultTextStyle(
                            duration: AppDuration.normal,
                            curve: Curves.easeInOutCubic,
                            style: AppTextStyles.heading2(context).copyWith(
                              color: isSelected
                                  ? isDark
                                        ? theme.onSurface
                                        : theme.surface
                                  : theme.onSurface.withValues(alpha: 0.5),
                            ),
                            child: Text(item['label']),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final originalState = context.read<ReaderPreferencesCubit>().state;
    bool isStateChanged = _tempState != originalState;
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
          Column(
            children: [
              _buildIndicator(theme),
              const SizedBox(height: AppSpacing.xxl),
              _buildPreview(theme: theme),
              const SizedBox(height: AppSpacing.xl),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildThemeSection(context: context),
                      const SizedBox(height: AppSpacing.xl),
                      _buildBgSelection(context: context, theme: theme),
                      const SizedBox(height: AppSpacing.xl),
                      _buildFontSection(context: context, theme: theme),
                      _buildFontCustomization(theme: theme),
                      const SizedBox(height: AppSpacing.xl),
                      _buildFontSizeSlider(context: context),
                      const SizedBox(height: AppSpacing.xl),
                      _buildLineSpacingSlider(context: context),
                      const SizedBox(height: AppSpacing.xl),
                      _buildAlignmentSection(context: context),
                      const SizedBox(height: AppSpacing.xl),
                      _buildScrollSelectionChip(theme: theme),
                      SizedBox(height: isStateChanged ? 80.h : AppSpacing.xxxl),
                    ],
                  ),
                ),
              ),
            ],
          ),

          /// linear fade
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
          applyButton(
            context: context,
            isStateChanged: isStateChanged,
            theme: theme,
            isDark: isDark,
            onTap: () {
              context.read<ReaderPreferencesCubit>().applynewTheme(_tempState);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
