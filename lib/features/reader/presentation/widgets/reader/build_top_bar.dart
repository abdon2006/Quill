import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/theme/app_icons.dart';
import 'package:quill/core/theme/app_spacing.dart';

class BuildTopBar extends StatefulWidget {
  const BuildTopBar({super.key});

  @override
  State<BuildTopBar> createState() => _BuildTopBarState();
}

class _BuildTopBarState extends State<BuildTopBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () => context.pop(),
          customBorder: CircleBorder(),
          child: Container(
            padding: EdgeInsets.all(AppSpacing.sm),
            child: HugeIcon(icon: AppIcons.back),
          ),
        ),
        Spacer(),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            customBorder: CircleBorder(),
            child: Container(
              padding: EdgeInsets.all(AppSpacing.sm),
              child: HugeIcon(icon: AppIcons.bookmark),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            customBorder: CircleBorder(),
            child: Container(
              padding: EdgeInsets.all(AppSpacing.sm),
              child: HugeIcon(icon: HugeIcons.strokeRoundedMoreVertical),
            ),
          ),
        ),
      ],
    );
  }
}
