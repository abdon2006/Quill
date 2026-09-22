import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/theme/app_colors.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_shadows.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';
import 'package:quill/core/widgets/app_button.dart';
import 'package:quill/features/library/presentation/widgets/staggerd_animation.dart';

void showAboutQuillDialog(BuildContext context) {
  final theme = Theme.of(context).colorScheme;
  showDialog(
    context: context,
    builder: (_) => StaggerdAnimation(
      index: 0,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.xl),
        backgroundColor: theme.surface,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: AppSpacing.xxxl),
              decoration: BoxDecoration(
                borderRadius: AppRadius.sheetSm,
              ),
              child: Column(
                children: [
                  Container(
                    height: 56.w,
                    width: 56.w,
                    decoration: BoxDecoration(
                      borderRadius: AppRadius.xl,
                      color: theme.secondary,
                      boxShadow: AppShadows.card,
                    ),
                    child: Center(
                      child: HugeIcon(
                        icon: HugeIcons.strokeRoundedQuillWrite01,
                        color: AppColors.white,
                        size: 28.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacing.md),
                  Text('Quill', style: AppTextStyles.displayMedium(context)),
                ],
              ),
            ),

            
            _infoRow(
              context: context,
              theme: theme,
              label: 'Version',
              value: '1.0.0',
              isAccent: true,
            ),
            _infoRow(
              context: context,
              theme: theme,
              label: 'Platform',
              value: 'Flutter · Android',
            ),
            _infoRow(
              context: context,
              theme: theme,
              label: 'Developer',
              value: 'Abdallah Saad',
            ),

            
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.xs,
              ),
              child: SizedBox(
                width: double.infinity,
                child: AppButton.secondary(
                  text: 'Close',
                  onPressed: () => context.pop(),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _infoRow({
  required BuildContext context,
  required ColorScheme theme,
  required String label,
  required String value,
  bool isAccent = false,
}) => Container(
  padding: EdgeInsets.symmetric(
    horizontal: AppSpacing.xl,
    vertical: AppSpacing.md,
  ),
  decoration: BoxDecoration(
    border: Border(
      bottom: BorderSide(
        color: theme.onSurface.withValues(alpha: 0.1),
        width: 0.5,
      ),
    ),
  ),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: AppTextStyles.caption(context)),
      Text(
        value,
        style: AppTextStyles.heading2(
          context,
        ).copyWith(color: isAccent ? theme.secondary : null),
      ),
    ],
  ),
);
