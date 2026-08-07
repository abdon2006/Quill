import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/theme/app_colors.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';

class AppTextField extends StatefulWidget {
  final String hintText;
  final List<List<dynamic>> prefixIcon;
  final bool isPass;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final int? maxLines;

  const AppTextField({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    required this.isPass,
    required this.controller,
    this.validator,
    this.keyboardType,
    this.maxLines,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  final _focusNode = FocusNode();
  bool _isFocused = false;
  bool _obscured = true;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: AppRadius.xl,
        color: theme.colorScheme.surface,
        border: Border.all(
          color: _isFocused
              ? theme.colorScheme.primary
              : isDark
              ? AppColors.darkBgSurfaceAlt
              : AppColors.lightBgSurfaceAlt,
          width: _isFocused ? 1.5 : 1,
        ),
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : [],
      ),
      child: ClipRRect(
        borderRadius: AppRadius.xl,
        child: TextFormField(
          focusNode: _focusNode,
          maxLines: widget.isPass ? 1 : widget.maxLines,
          keyboardType: widget.keyboardType,
          controller: widget.controller,
          validator: widget.validator,
          obscureText: widget.isPass ? _obscured : false,
          cursorOpacityAnimates: true,
          cursorColor: theme.colorScheme.primary,
          cursorRadius: Radius.circular(20.r),
          style: AppTextStyles.bodyMedium(context),
          decoration: InputDecoration(
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            prefixIcon: Padding(
              padding: EdgeInsets.only(
                left: AppSpacing.md,
                right: AppSpacing.sm,
              ),
              child: HugeIcon(
                icon: widget.prefixIcon,
                color: _isFocused
                    ? theme.colorScheme.primary
                    : isDark
                    ? AppColors.darkTextMuted
                    : AppColors.lightTextMuted,
                size: 20,
              ),
            ),
            prefixIconConstraints: const BoxConstraints(),
            hintText: widget.hintText,
            hintStyle: AppTextStyles.bodyMedium(context).copyWith(
              color: isDark
                  ? AppColors.darkTextMuted
                  : AppColors.lightTextMuted,
            ),
            suffixIcon: widget.isPass
                ? GestureDetector(
                    onTap: () => setState(() => _obscured = !_obscured),
                    child: Padding(
                      padding: EdgeInsets.only(right: AppSpacing.md),
                      child: HugeIcon(
                        icon: _obscured
                            ? HugeIcons.strokeRoundedEye
                            : HugeIcons.strokeRoundedScanEye,
                        color: isDark
                            ? AppColors.darkTextMuted
                            : AppColors.lightTextMuted,
                        size: 20,
                      ),
                    ),
                  )
                : null,
            suffixIconConstraints: const BoxConstraints(),
          ),
        ),
      ),
    );
  }
}
