import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';

enum ButtonType { primary, secondary }

class AppButton extends StatelessWidget {
  final String text;
  final Color? color;
  final VoidCallback onPressed;
  final List<List<dynamic>>? icon;
  final ButtonType type;
  final double width;
  final bool isLoading;
  const AppButton._({
    super.key,
    required this.text,
    required this.onPressed,
    required this.type,
    this.color,
    this.icon,
    this.width = double.infinity, // الديفولت إنه بياخد عرض الشاشة
    this.isLoading = false,
  });

  const AppButton.primary({
    Key? key,
    required String text,
    required VoidCallback onPressed,
    List<List<dynamic>>? icon,
    Color? color,
    double width = double.infinity,
    bool isLoading = false,
  }) : this._(
         key: key,
         text: text,
         onPressed: onPressed,
         type: ButtonType.primary,
         icon: icon,
         isLoading: isLoading,
       );

  const AppButton.secondary({
    Key? key,
    required String text,
    required VoidCallback onPressed,
    Color? color,
    List<List<dynamic>>? icon,
    double width = double.infinity,
    bool isLoading = false,
  }) : this._(
         key: key,
         text: text,
         onPressed: onPressed,
         type: ButtonType.secondary,
         icon: icon,
         width: width,
         isLoading: isLoading,
       );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPrimary = type == ButtonType.primary;
    final backgroundColor = isPrimary
        ? theme.colorScheme.primary
        : theme.colorScheme.surface;

    final textColor = isPrimary
        ? theme.colorScheme.onPrimary
        : theme.colorScheme.primary;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
      width: width,
      height: 50.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,

          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.xxl),
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        ),
        child: isLoading
            ? SizedBox(
                height: 24.h,
                width: 24.w,
                child: CircularProgressIndicator(
                  color: textColor,
                  strokeWidth: 2.5,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) HugeIcon(icon: icon!),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    text,
                    style: AppTextStyles.heading2(
                      context,
                    ).copyWith(color: textColor),
                  ),
                ],
              ),
      ),
    );
  }
}
