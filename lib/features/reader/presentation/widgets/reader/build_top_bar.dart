import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/theme/app_icons.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';

class BuildTopBar extends StatefulWidget {
  final String title;
  const BuildTopBar({super.key, required this.title});

  @override
  State<BuildTopBar> createState() => _BuildTopBarState();
}

class _BuildTopBarState extends State<BuildTopBar> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: AppRadius.xl,
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => context.pop(),
            customBorder: CircleBorder(),
            child: Container(
              padding: EdgeInsets.all(AppSpacing.sm),
              child: HugeIcon(icon: AppIcons.back),
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Text(
              widget.title,
              overflow: TextOverflow.fade,
              style: AppTextStyles.heading2(context),
            ),
          ),
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
      ),
    );
  }
}
