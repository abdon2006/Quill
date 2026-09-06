import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/theme/app_colors.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_shadows.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';
import 'package:quill/features/reader/presentation/cubit/reader_preferences_state.dart';

class BuildBottomActions extends StatefulWidget {
  final ReaderPreferencesState state;
  final void Function(int) callBack;
  const BuildBottomActions({
    super.key,
    required this.callBack,
    required this.state,
  });

  @override
  State<BuildBottomActions> createState() => _BuildBottomActionsState();
}

class _BuildBottomActionsState extends State<BuildBottomActions> {
  Color getBgColor(ReaderPreferencesState state, BuildContext context) {
    return switch (state.theme) {
      ReaderTheme.light => AppColors.lightBgSurface,
      ReaderTheme.dark => AppColors.darkBgSurface,
      ReaderTheme.system => Theme.of(context).colorScheme.surface,
    };
  }

  Color _getTextColor(ReaderPreferencesState state, BuildContext context) {
    return switch (state.theme) {
      ReaderTheme.dark => AppColors.darkTextMuted,
      ReaderTheme.light => AppColors.lightTextMuted,
      ReaderTheme.system =>
        Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkTextMuted
            : AppColors.lightTextMuted,
    };
  }

  final List controlsData = [
    {'label': 'Font', 'icon': HugeIcons.strokeRoundedTextFont},
    {'label': 'Focus', 'icon': HugeIcons.strokeRoundedMoon02},
    {'label': 'Explain', 'icon': HugeIcons.strokeRoundedSparkles},
    {'label': 'Bionic', 'icon': HugeIcons.strokeRoundedTextFont},
  ];
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      decoration: BoxDecoration(
        boxShadow: AppShadows.bottomNav,
        color: getBgColor(widget.state, context),
        borderRadius: AppRadius.xxl,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(4, (i) {
          final item = controlsData[i];
          return Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: theme.primary.withValues(alpha: 0.15),
              highlightColor: theme.primary.withValues(alpha: 0.08),
              customBorder: CircleBorder(),
              onTap: switch (i) {
                0 => () => widget.callBack(0),
                1 => () => widget.callBack(1),
                2 => () {},
                3 => () => widget.callBack(3),
                int() => throw UnimplementedError(),
              },
              child: Container(
                padding: EdgeInsets.all(AppSpacing.md),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    HugeIcon(
                      icon: item['icon'],
                      size: 20.sp,
                      color: theme.secondary,
                    ),
                    Text(
                      item['label'],
                      style: AppTextStyles.caption(context).copyWith(
                        color: _getTextColor(widget.state, context),
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
