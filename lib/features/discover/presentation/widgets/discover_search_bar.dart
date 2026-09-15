import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/theme/app_colors.dart';
import 'package:quill/core/theme/app_duration.dart';
import 'package:quill/core/theme/app_icons.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';

class DiscoverSearchBar extends StatefulWidget {
  final void Function(String)? onChanged;
  final ValueChanged<bool> onFocus;
  const DiscoverSearchBar({
    super.key,
    required this.onChanged,
    required this.onFocus,
  });

  @override
  State<DiscoverSearchBar> createState() => _DiscoverSearchBarState();
}

class _DiscoverSearchBarState extends State<DiscoverSearchBar> {
  final controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
      widget.onFocus(_isFocused);
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
      duration: AppDuration.normal,
      decoration: BoxDecoration(
        borderRadius: AppRadius.xxl,
        color: theme.colorScheme.surface,
        border: Border.all(
          color: _isFocused
              ? theme.colorScheme.secondary
              : isDark
              ? AppColors.darkBgSurfaceAlt
              : AppColors.lightBgSurfaceAlt,
          width: _isFocused ? 1.05 : 1,
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
          onChanged: widget.onChanged,
          focusNode: _focusNode,
          keyboardType: TextInputType.name,

          controller: controller,
          validator: (v) => '',
          cursorOpacityAnimates: true,
          cursorColor: theme.colorScheme.secondary,
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
                icon: AppIcons.search,
                color: _isFocused
                    ? theme.colorScheme.secondary
                    : isDark
                    ? AppColors.darkTextMuted
                    : AppColors.lightTextMuted,
                size: 20,
              ),
            ),
            prefixIconConstraints: const BoxConstraints(),
            ////
            hintText: 'Search classics, authors, philosophers...',
            hintStyle: AppTextStyles.bodyMedium(context).copyWith(
              color: isDark
                  ? AppColors.darkTextMuted.withValues(alpha: 0.5)
                  : AppColors.lightTextMuted.withValues(alpha: 0.5),
            ),
          ),
        ),
      ),
    );
  }
}
