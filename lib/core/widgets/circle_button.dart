  import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/theme/app_shadows.dart';

Widget circleButton(
    BuildContext context, {
    required List<List<dynamic>> icon,
    required Color background,
    required Color foreground,
    required VoidCallback onTap,
  }) {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: Container(
        width: 42.w,
        height: 42.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: background,
          boxShadow: AppShadows.circleButton,
        ),
        child: Center(
          child: HugeIcon(icon: icon, size: 20.sp, color: foreground),
        ),
      ),
    );
  }