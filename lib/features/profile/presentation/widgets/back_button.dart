import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/theme/app_icons.dart';
import 'package:quill/core/theme/app_spacing.dart';

Widget backButton(BuildContext context, ColorScheme theme) => Align(
  alignment: AlignmentGeometry.centerLeft,
  child: InkWell(
    customBorder: const CircleBorder(),
    onTap: () => context.pop(),
    child: Container(
      padding: EdgeInsets.all(AppSpacing.sm),
      margin: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(shape: BoxShape.circle),
      child: Center(
        child: HugeIcon(
          icon: AppIcons.back,
          size: 32.sp,
          color: theme.secondary,
        ),
      ),
    ),
  ),
);
