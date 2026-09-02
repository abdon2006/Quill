import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_shadows.dart';
import 'package:quill/core/theme/app_spacing.dart';

class BuildBottomActions extends StatefulWidget {
  final void Function(int) callBack;
  const BuildBottomActions({super.key, required this.callBack});

  @override
  State<BuildBottomActions> createState() => _BuildBottomActionsState();
}

class _BuildBottomActionsState extends State<BuildBottomActions> {
  final List controlsData = [
    {'label': 'Font', 'icon': HugeIcons.strokeRoundedTextFont},
    {'label': 'Focus', 'icon': HugeIcons.strokeRoundedMoon02},
    {'label': 'Explain', 'icon': HugeIcons.strokeRoundedSparkles},
    {'label': 'Save', 'icon': HugeIcons.strokeRoundedBookmark02},
  ];
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      decoration: BoxDecoration(
        boxShadow: AppShadows.bottomNav,
        color: theme.surface,
        borderRadius: AppRadius.xxl,
        // border: Border.all(color: theme.primary),
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
                3 => () {},
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
                      color: theme.primary,
                    ),
                    Text(item['label']),
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
