import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/theme/app_spacing.dart';

Widget editIconButton({
  required BuildContext context,
  required void Function() onTap,
}) {
  final theme = Theme.of(context).colorScheme;
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.onSurface.withValues(alpha: 0.06),
      ),
      child: HugeIcon(
        icon: HugeIcons.strokeRoundedPencilEdit02,
        color: theme.onSurface.withValues(alpha: 0.4),
        size: 18.sp,
      ),
    ),
  );
}
