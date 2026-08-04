import 'package:flutter/material.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';

Widget buildAuthScreens(BuildContext context, Widget textFields, String label) {
  return SafeArea(
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
            child: Text(
              textAlign: TextAlign.start,
              label,
              style: AppTextStyles.displayLarge(context),
            ),
          ),
          textFields,
        ],
      ),
    ),
  );
}
