import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';
import 'package:quill/core/widgets/app_button.dart';

class ImportBookBottomSheet extends StatelessWidget {
  const ImportBookBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.xxl,
      ),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: theme.onSurface.withValues(alpha: 0.15),
              borderRadius: AppRadius.lg,
            ),
          ),
          SizedBox(height: AppSpacing.xxl),
          Container(
            width: 64.w,
            height: 64.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.primary.withValues(alpha: 0.08),
            ),
            child: Center(
              child: HugeIcon(
                icon: HugeIcons.strokeRoundedBook02,
                size: 30.sp,
                color: theme.primary,
              ),
            ),
          ),
          SizedBox(height: AppSpacing.xl),
          // Title
          Text(
            'Bring something worth reading.',
            textAlign: TextAlign.center,
            style: AppTextStyles.displayMedium(
              context,
            ).copyWith(letterSpacing: 0.0),
          ),

          SizedBox(height: AppSpacing.sm),

          // Description
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text(
              'Add a book to your personal reading space and make it yours.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium(context).copyWith(
                color: theme.onSurface.withValues(alpha: 0.55),
                height: 1.5,
              ),
            ),
          ),

          SizedBox(height: AppSpacing.xxl),

          // Supported formats
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _FormatBadge(label: 'PDF', theme: theme),
              SizedBox(width: 8.w),
              _FormatBadge(label: 'ePub', theme: theme),
            ],
          ),

          SizedBox(height: AppSpacing.xxl),

          // Choose file
          AppButton.primary(
            text: 'Choose a File',
            onPressed: () {},
            icon: HugeIcons.strokeRoundedFolder02,
          ),

          SizedBox(height: AppSpacing.sm),

          // Cancel
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Maybe later',
              style: AppTextStyles.bodyMedium(
                context,
              ).copyWith(color: theme.onSurface.withValues(alpha: 0.45)),
            ),
          ),
        ],
      ),
    );
  }
}

class _FormatBadge extends StatelessWidget {
  final String label;
  final ColorScheme theme;

  const _FormatBadge({required this.label, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: theme.onSurface.withValues(alpha: 0.05),
        borderRadius: AppRadius.lg,
      ),
      child: Text(
        label,
        style: AppTextStyles.bodyMedium(
          context,
        ).copyWith(color: theme.onSurface.withValues(alpha: 0.55)),
      ),
    );
  }
}
