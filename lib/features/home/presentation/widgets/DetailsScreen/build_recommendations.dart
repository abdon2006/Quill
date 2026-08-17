import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/features/home/domain/entities/book_entity.dart';
import 'package:quill/features/home/presentation/widgets/DetailsScreen/build_section_tile.dart';
import 'package:quill/features/home/presentation/widgets/Home/book_grid_card.dart';
import 'package:quill/features/library/presentation/widgets/staggerd_animation.dart';

Widget buildRecommendations(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: sectionTitle(
          context,
          eyebrow: 'KEEP EXPLORING',
          title: 'You might also like',
        ),
      ),

      const SizedBox(height: AppSpacing.lg),

      SizedBox(
        height: 280.h,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          scrollDirection: Axis.horizontal,
          itemCount: 4,
          separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
          itemBuilder: (context, index) {
            return SizedBox(
              width: 170.w,
              child: StaggerdAnimation(
                index: index,
                child: BookGridCard(book: BookEntity.dummy()),
              ),
            );
          },
        ),
      ),
    ],
  );
}
