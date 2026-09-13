import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:quill/core/router/app_router.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/features/home/domain/entities/book_entity.dart';
import 'package:quill/features/home/presentation/recommendations%20cubit/recommendation_cubit.dart';
import 'package:quill/features/home/presentation/recommendations%20cubit/recommendation_state.dart';
import 'package:quill/features/home/presentation/widgets/DetailsScreen/build_section_tile.dart';
import 'package:quill/features/home/presentation/widgets/Home/book_grid_card.dart';
import 'package:quill/features/library/presentation/widgets/staggerd_animation.dart';
import 'package:skeletonizer/skeletonizer.dart';

Widget buildRecommendations(BuildContext context) {
  return BlocBuilder<RecommendationCubit, RecommendationState>(
    builder: (context, state) {
      if (state is RecommendationSuccess) {
        if (state.books.isEmpty) return SizedBox.shrink();
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
                itemCount: state.books.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(width: AppSpacing.md),
                itemBuilder: (context, i) {
                  return SizedBox(
                    width: 170.w,
                    child: StaggerdAnimation(
                      index: i,
                      child: BookGridCard(
                        onTap: ()=> context.push(AppRoutes.bookDeatails , extra: state.books[i]),
                        book: state.books[i]),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }
      if (state is RecommendationLoading || state is RecommendationInitial) {
        return _buildLoadingState(context);
      }
      return SizedBox();
    },
  );
}

Widget _buildLoadingState(BuildContext context) => Skeletonizer(
  enabled: true,
  child: Column(
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
          itemCount: 3,
          separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
          itemBuilder: (context, i) {
            return SizedBox(
              width: 170.w,
              child: BookGridCard(book: BookEntity.dummy()),
            );
          },
        ),
      ),
    ],
  ),
);
