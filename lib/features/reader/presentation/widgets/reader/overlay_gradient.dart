import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// شلنا الـ Positioned عشان ندي حرية للـ Stack بره
Widget overlayGradient({
  required Color bgColor,
  required bool isTop,
  required ColorScheme theme,
}) => IgnorePointer(
  child: Container(
    height: 40.h,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isTop
            ? [bgColor, bgColor.withValues(alpha: 0)]
            : [bgColor.withValues(alpha: 0), bgColor],
      ),
    ),
  ),
);
