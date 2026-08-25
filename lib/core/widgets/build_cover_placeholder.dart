import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

Widget buildCoverPlaceholder(BuildContext context) {
  final theme = Theme.of(context).colorScheme;
  return Container(
    color: theme.surface,
    child: Center(
      child: HugeIcon(
        icon: HugeIcons.strokeRoundedLibrary,
        color: theme.onSurface.withValues(alpha: 0.4),
        size: 48.sp,
      ),
    ),
  );
}
