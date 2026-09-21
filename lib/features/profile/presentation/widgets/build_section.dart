import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';

Widget buildSection({
  required ColorScheme theme,
  required BuildContext context,
  required String title,
  required String subTitle,
  required List<List<dynamic>> icon,
  required void Function() onTap,
}) => Material(
  color: Colors.transparent,
  child: InkWell(
    borderRadius: AppRadius.xl,
    hoverColor: theme.secondary.withValues(alpha: 0.02),
    splashColor: theme.secondary.withValues(alpha: 0.02),
    onTap: onTap,
    child: Ink(
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              borderRadius: AppRadius.md,
              color: theme.secondary.withValues(alpha: 0.1),
            ),
            child: Center(
              child: HugeIcon(icon: icon, color: theme.secondary),
            ),
          ),
          SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: AppTextStyles.heading1(context)),
              Text(subTitle, style: AppTextStyles.caption(context)),
            ],
          ),
          Spacer(),
          HugeIcon(icon: HugeIcons.strokeRoundedArrowRight01),
        ],
      ),
    ),
  ),
);
