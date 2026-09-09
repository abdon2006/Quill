import 'package:flutter/material.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_shadows.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';

Widget milestoneNotch({
  required BuildContext context,
  required Animation<Offset> slide,
  required Animation<double> opacity,
  required ColorScheme theme,
  required String currentMessage,
}) => Positioned(
  left: 0,
  right: 0,
  top: MediaQuery.of(context).padding.top + AppSpacing.lg,
  child: SlideTransition(
    position: slide,
    child: FadeTransition(
      opacity: opacity,
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: theme.secondary,
            borderRadius: AppRadius.xl,
            boxShadow: AppShadows.elevated,
          ),
          child: Text(
            currentMessage,
            style: AppTextStyles.defaultReading(context).copyWith(),
          ),
        ),
      ),
    ),
  ),
);
