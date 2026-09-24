import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quill/core/theme/app_colors.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_shadows.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/features/library/presentation/widgets/staggerd_animation.dart';
import 'package:skeletonizer/skeletonizer.dart';

Widget builBookCover(BuildContext context, String coverImage) {
  return SizedBox(
    height: 430.h,
    child: Stack(
      alignment: Alignment.center,
      children: [
        Positioned.fill(
          child: Skeleton.ignore(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 35, sigmaY: 35),
              child: Opacity(
                opacity: 0.1,
                child: Image.network(coverImage, fit: BoxFit.cover),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: AppSpacing.xxxl,
            bottom: AppSpacing.xl,
          ),
          child: Skeleton.leaf(
            child: StaggerdAnimation(
              index: 0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: AppRadius.lg,
                  boxShadow: AppShadows.bookCoverHeavy,
                ),
                child: Skeleton.leaf(
                  child: ClipRRect(
                    borderRadius: AppRadius.lg,
                    child: Image.network(
                      coverImage,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 190.w,
                          height: 260.h,
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? AppColors.darkImagePlaceholder
                                : AppColors.lightImagePlaceholder,
                            borderRadius: AppRadius.lg,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
