import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quill/core/theme/app_radius.dart';

class BuildSelectedImage extends StatefulWidget {
  final XFile? image;
  const BuildSelectedImage({super.key, this.image});

  @override
  State<BuildSelectedImage> createState() => _BuildSelectedImageState();
}

class _BuildSelectedImageState extends State<BuildSelectedImage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Container(
      width: 140.w,
      height: 180.h,

      decoration: BoxDecoration(
        borderRadius: AppRadius.xl,
        color: theme.onSurface.withValues(alpha: 0.1),
      ),
      child: Center(
        child: widget.image == null
            ? HugeIcon(
                icon: HugeIcons.strokeRoundedLibrary,
                color: theme.onSurface.withValues(alpha: 0.4),
                size: 28.sp,
              )
            : ClipRRect(
                borderRadius: AppRadius.xl,
                child: Image.file(
                  File(widget.image!.path),
                  fit: BoxFit.cover,
                  width: 140.w,
                  height: 180.h,
                ),
              ),
      ),
    );
  }
}