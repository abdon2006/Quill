import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';

Widget buildImageSourceChoice(
  ColorScheme theme,
  List<List<dynamic>> icon,
  void Function()? onTap,
  String label,
  BuildContext context,
) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      InkWell(
        onTap: onTap,
        hoverColor: theme.primary,
        borderRadius: AppRadius.xl,
        child: Container(
          padding: EdgeInsets.all(AppSpacing.xxl),
          decoration: BoxDecoration(
            borderRadius: AppRadius.xl,
            color: theme.primary.withValues(alpha: 0.1),
          ),
          child: Center(
            child: HugeIcon(
              icon: icon,
              size: AppSpacing.xxxl,
              color: theme.primary,
            ),
          ),
        ),
      ),
      SizedBox(height: AppSpacing.xs),
      Text(label, style: AppTextStyles.heading2(context)),
    ],
  );
}
