
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/widgets/build_cover_placeholder.dart';

Widget buildCover(BuildContext context, String? coverImage) {
  final hasImage = coverImage != null && coverImage.isNotEmpty;

  return SizedBox(
    height: 380.h,
    child: Stack(
      alignment: Alignment.center,
      children: [
        // Blurred background
        if (hasImage)
          Positioned.fill(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 35, sigmaY: 35),
              child: Opacity(
                opacity: 0.1,
                child: Image.file(
                  Uri.file(coverImage).toFilePath() as dynamic,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox(),
                ),
              ),
            ),
          ),

        // Cover card
        Padding(
          padding: const EdgeInsets.only(
            top: AppSpacing.xxxl,
            bottom: AppSpacing.xl,
          ),
          child: Container(
            width: 170.w,
            height: 240.h,
            decoration: BoxDecoration(
              borderRadius: AppRadius.lg,
              color: Theme.of(context).colorScheme.surfaceVariant,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.22),
                  blurRadius: 35,
                  offset: const Offset(0, 18),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: AppRadius.lg,
              child: hasImage
                  ? Image.network(
                      coverImage,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          buildCoverPlaceholder(context),
                    )
                  : buildCoverPlaceholder(context),
            ),
          ),
        ),
      ],
    ),
  );
}

