import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/theme/app_colors.dart';
import 'package:quill/core/theme/app_duration.dart';
import 'package:quill/core/theme/app_icons.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_shadows.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';

// ignore: must_be_immutable
class BuildThemeSection extends StatefulWidget {
  int selectedTheme;
  final ValueChanged<int> onSelectTheme;
  BuildThemeSection({
    super.key,
    required this.selectedTheme,
    required this.onSelectTheme,
  });

  @override
  State<BuildThemeSection> createState() => _BuildThemeSectionState();
}

class _BuildThemeSectionState extends State<BuildThemeSection> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Appearance',
          style: AppTextStyles.defaultReading(context).copyWith(
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: AppSpacing.sm),
          child: Row(
            children: [
              Text('Theme', style: AppTextStyles.heading1(context)),

              Spacer(),
              SizedBox(
                width: 200.w,
                child: _themeChipsControl(
                  theme: theme,
                  selectedTheme: widget.selectedTheme,
                  onChangeTheme: (index) {
                    setState(() {
                      widget.selectedTheme = index;
                      widget.onSelectTheme(index);
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Widget _themeChipsControl({
  required ColorScheme theme,
  required int selectedTheme,
  required ValueChanged<int> onChangeTheme,
}) {
  final List<List<List<dynamic>>> themeData = [
    HugeIcons.strokeRoundedComponent,
    AppIcons.sun,
    AppIcons.moon,
  ];
  return LayoutBuilder(
    builder: (context, constraints) {
      final itemWidth = constraints.maxWidth / themeData.length;
      return Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 50.h,
            padding: EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              borderRadius: AppRadius.md,
              color: theme.surface,
            ),
          ),
          AnimatedPositioned(
            width: itemWidth,
            left: selectedTheme * itemWidth,
            duration: AppDuration.normal,
            curve: Curves.easeInOutCubic,
            child: Container(
              height: 50.h,
              decoration: BoxDecoration(
                borderRadius: AppRadius.md,
                color: theme.secondary,
                boxShadow: AppShadows.card,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(themeData.length, (i) {
              bool isSelected = selectedTheme == i;
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onChangeTheme(i),
                child: SizedBox(
                  height: 50.h,
                  width: itemWidth,
                  child: AnimatedContainer(
                    duration: AppDuration.normal,
                    curve: Curves.easeInOutCubic,
                    child: Center(
                      child: HugeIcon(
                        icon: themeData[i],
                        color: isSelected
                            ? theme.onPrimary
                            : theme.onSurface.withValues(alpha: 0.3),
                      ),
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
