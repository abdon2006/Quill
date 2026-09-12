import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';
import 'package:toastification/toastification.dart';

void appToast({
  required BuildContext context,
  required String label,
  required String description,
  required ColorScheme theme,
  required List<List<dynamic>> icon,
  int? secondes,
  bool? isBlur,
}) {
  toastification.show(
    context: context,
    type: ToastificationType.success,
    style: ToastificationStyle.flat,
    title: Text(label, style: AppTextStyles.heading1(context)),
    description: Text(description, style: AppTextStyles.caption(context)),
    alignment: Alignment.topCenter,
    borderSide: BorderSide(color: Colors.transparent),
    autoCloseDuration: Duration(seconds: secondes ?? 3),
    borderRadius: AppRadius.xl,
    backgroundColor: theme.surface,
    icon: HugeIcon(icon: icon, color: theme.secondary),
    showProgressBar: false,
    applyBlurEffect: isBlur ?? true,
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.lg,
      vertical: AppSpacing.md,
    ),
    primaryColor: theme.secondary,
  );
}
