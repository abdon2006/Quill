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
  final bool? isEnabled;
  const AppButton._({
    super.key,
    required this.text,
    required this.onPressed,
    required this.type,
    this.color,
    this.icon,
    this.width = double.infinity, // الديفولت إنه بياخد عرض الشاشة
    this.isLoading = false,
    this.isEnabled = true,
  });

  const AppButton.primary({
    Key? key,
    required String text,
    required VoidCallback onPressed,
    List<List<dynamic>>? icon,
    Color? color,
    double width = double.infinity,
    bool isLoading = false,
    bool isEnabled = true,
  }) : this._(
         key: key,
         text: text,
         onPressed: onPressed,
         type: ButtonType.primary,
         icon: icon,
         isLoading: isLoading,
         isEnabled: isEnabled,
       );

  const AppButton.secondary({
    Key? key,
    required String text,
    required VoidCallback onPressed,
    Color? color,
    List<List<dynamic>>? icon,
    double width = double.infinity,
    bool isLoading = false,
    bool isEnabled = true,
  }) : this._(
         key: key,
         text: text,
         onPressed: onPressed,
         type: ButtonType.secondary,
         icon: icon,
         width: width,
         isLoading: isLoading,
         isEnabled: isEnabled,
       );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPrimary = type == ButtonType.primary;
    final buttonEnabled = isEnabled ?? true;

    final activeBackgroundColor = isPrimary
        ? theme.colorScheme.primary
        : theme.colorScheme.surface;
    final activeTextColor = isPrimary
        ? theme.colorScheme.onPrimary
        : theme.colorScheme.primary;

    final disabledBackgroundColor = theme.colorScheme.onSurface.withValues(
      alpha: 0.12,
    );
    final disabledTextColor = theme.colorScheme.onSurface.withValues(
      alpha: 0.38,
    );

    return AnimatedContainer(
      duration: Duration(milliseconds: 2000),
      curve: Curves.easeInOut,
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
      width: width,
      height: 50.h,
      child: ElevatedButton(
        onPressed: (isLoading || !buttonEnabled) ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: activeBackgroundColor,
          foregroundColor: activeTextColor,

          disabledBackgroundColor: disabledBackgroundColor,
          disabledForegroundColor: disabledTextColor,

          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.xxl),
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        ),
        child: isLoading
            ? SizedBox(
                height: 24.h,
                width: 24.w,
                child: CircularProgressIndicator(
                  color: buttonEnabled ? activeTextColor : disabledTextColor,
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
                    style: AppTextStyles.heading2(context).copyWith(
                      color: buttonEnabled
                          ? activeTextColor
                          : disabledTextColor,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
