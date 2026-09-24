import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_spacing.dart';

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
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.xxxxl),
      decoration: BoxDecoration(
        borderRadius: AppRadius.xl,
        color: theme.onSurface.withValues(alpha: 0.1),
      ),
      child: Center(
        child: widget.image == null
            ? null
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
