  import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/features/library/presentation/widgets/staggerd_animation.dart';

Widget builBookCover(BuildContext context , String coverImage) {

    return SizedBox(
      height: 430.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 35, sigmaY: 35),
              child: Opacity(
                opacity: 0.1,
                child: Image.network(coverImage, fit: BoxFit.cover),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: AppSpacing.xxxl,
              bottom: AppSpacing.xl,
            ),
            child: StaggerdAnimation(
              index: 0,
              child: Container(
                width: 190.w,
                decoration: BoxDecoration(
                  borderRadius: AppRadius.lg,
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
                  child: Image.network(
                    coverImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }