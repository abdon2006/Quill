import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/theme/app_duration.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_shadows.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';
import 'package:quill/core/widgets/app_button.dart';

void showAiComingSoonDialog(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Dismiss',
    barrierColor: Colors.black.withValues(alpha: 0.4),
    transitionDuration: AppDuration.slow,
    pageBuilder: (context, anim1, anim2) {
      return const _AiComingSoonDialog();
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 8 * anim1.value,
          sigmaY: 8 * anim1.value,
        ),
        child: Transform.scale(
          scale: CurvedAnimation(
            parent: anim1,
            curve: Curves.easeInOutCubic,
          ).value,
          child: Opacity(opacity: anim1.value, child: child),
        ),
      );
    },
  );
}

class _AiComingSoonDialog extends StatefulWidget {
  const _AiComingSoonDialog();

  @override
  State<_AiComingSoonDialog> createState() => _AiComingSoonDialogState();
}

class _AiComingSoonDialogState extends State<_AiComingSoonDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _breathingController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _breathingController = AnimationController(
      vsync: this,
      duration: AppDuration.dialogPulse,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 4.0, end: 15.0).animate(
      CurvedAnimation(parent: _breathingController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _breathingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: theme.surface,
          borderRadius: AppRadius.xxl,
          border: Border.all(
            color: theme.onSurface.withValues(alpha: 0.1),
            width: 1,
          ),
          boxShadow: AppShadows.card,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: AppSpacing.md),

            AnimatedBuilder(
              animation: _glowAnimation,
              builder: (context, child) {
                return Container(
                  width: 70.w,
                  height: 70.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.secondary.withValues(alpha: 0.1),
                    boxShadow: [
                      BoxShadow(
                        color: theme.primary.withValues(alpha: 0.25),
                        blurRadius: _glowAnimation.value,
                        spreadRadius: _glowAnimation.value / 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: HugeIcon(
                      icon: HugeIcons.strokeRoundedSparkles,
                      size: 32.sp,
                      color: theme.secondary,
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: AppSpacing.xxl),

            
            Text(
              'Quill AI is Learning',
              textAlign: TextAlign.center,
              style: AppTextStyles.displayMedium(context),
            ),

            SizedBox(height: AppSpacing.sm),

            Text(
              'Your personal reading companion is currently reading thousands of books. Soon, you will be able to summarize chapters, clarify complex ideas, and chat directly with your books.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium(context).copyWith(
                color: theme.onSurface.withValues(alpha: 0.6),
                height: 1.6,
              ),
            ),

            SizedBox(height: AppSpacing.xxl),

            
            AppButton.secondary(
              text: 'Got it, Thanks',
              onPressed: () => Navigator.of(context).pop(),
            ),

            SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }
}
