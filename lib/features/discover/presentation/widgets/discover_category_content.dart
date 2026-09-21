import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:quill/core/constants/app_constants.dart';
import 'package:quill/core/router/app_router.dart';
import 'package:quill/core/states/EmptyStates/app_empty.dart';
import 'package:quill/core/states/ErrorStates/app_error.dart';
import 'package:quill/core/theme/app_assets.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/features/discover/presentation/widgets/category_params.dart';
import 'package:quill/features/discover/presentation/widgets/recommended_tile.dart';
import 'package:quill/features/home/presentation/bloc/home_bloc.dart';
import 'package:quill/features/home/presentation/bloc/home_state.dart';
import 'package:quill/features/home/presentation/widgets/Home/section_header.dart';
import 'package:quill/features/library/presentation/widgets/staggerd_animation.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DiscoverCategoryContent extends StatelessWidget {
  final int selectedChipIndex;
  const DiscoverCategoryContent({super.key, required this.selectedChipIndex});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is FetchBooksSuccess) {
          final selectedCategory = AppConstants.categories[selectedChipIndex];

          final filteredBooks = state.books.reversed.where(
            (book) => book.categories.any(
              (category) => category.toLowerCase().contains(
                selectedCategory.toLowerCase(),
              ),
            ),
          );

          final books = filteredBooks.take(5).toList();

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: Column(
                  children: [
                    SizedBox(height: AppSpacing.lg),
                    Builder(
                      builder: (context) {
                        return SectionHeader(
                          title:
                              '${AppConstants.categories[selectedChipIndex]} Books',
                          viewAllOnTap: filteredBooks.isEmpty
                              ? null
                              : () => context.push(
                                  AppRoutes.category,
                                  extra: CategoryParams(
                                    books: filteredBooks.toList(),
                                    category: AppConstants
                                        .categories[selectedChipIndex],
                                  ),
                                ),
                        );
                      },
                    ),
                    SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),

              if (filteredBooks.isEmpty)
                StaggerdAnimation(
                  index: 0,
                  child: AppEmpty(
                    title:
                        "We are still curating our $selectedCategory collection.",
                    image: AppAssets.noResults,
                  ),
                ),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: books.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: AppSpacing.md),
                    child: StaggerdAnimation(
                      index: index * 2,
                      child: RecommendedBookTile(book: books[index]),
                    ),
                  );
                },
              ),

              /// 2. عرض الكتب المتفلترة
            ],
          );
        }
        if (state is HomeError) {
          return AppError(
            title:
                "Our library is currently taking a pause. Check back later.",
            image: AppAssets.errorBookDetails,
          );
        }
        return Skeletonizer(
          enabled: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: AppSpacing.lg),
                    Skeleton.leaf(
                      child: Container(
                        height: 24,
                        width: 180.w,
                        decoration: BoxDecoration(
                          borderRadius: AppRadius.lg,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
              ...List.generate(
                4,
                (i) => Padding(
                  padding: EdgeInsets.only(bottom: AppSpacing.md),
                  child: Skeleton.leaf(
                    child: Container(
                      height: 84.h,
                      margin: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                      decoration: BoxDecoration(
                        borderRadius: AppRadius.xl,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
