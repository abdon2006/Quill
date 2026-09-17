import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quill/core/states/EmptyStates/app_empty.dart';
import 'package:quill/core/theme/app_assets.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/features/discover/presentation/widgets/recommended_tile.dart';
import 'package:quill/features/home/presentation/bloc/home_bloc.dart';
import 'package:quill/features/home/presentation/bloc/home_state.dart';
import 'package:quill/features/home/presentation/widgets/Home/section_header.dart';
import 'package:quill/features/library/presentation/widgets/staggerd_animation.dart';

class DiscoverCategoryContent extends StatelessWidget {
  final int selectedChipIndex;
  const DiscoverCategoryContent({super.key, required this.selectedChipIndex});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            children: [
              SizedBox(height: AppSpacing.lg),
              Builder(
                builder: (context) {
                  final categories = [
                    'All',
                    'Fiction',
                    'Philosophy',
                    'Science',
                    'Self-Improvement',
                    'Poetry',
                  ];
                  return SectionHeader(
                    title: '${categories[selectedChipIndex]} Books',
                  );
                },
              ),
              SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),

        /// 2. عرض الكتب المتفلترة
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is FetchBooksSuccess) {
                final categories = [
                  'All',
                  'Fiction',
                  'Philosophy',
                  'Science',
                  'Self-Improvement',
                  'Poetry',
                ];
                final selectedCategory = categories[selectedChipIndex];

                // السحر هنا: بنفلتر الكتب اللي في الرام (Local Filtering)
                final filteredBooks = state.books
                    .where(
                      (book) => book.categories.any(
                        (category) => category.toLowerCase().contains(
                          selectedCategory.toLowerCase(),
                        ),
                      ),
                    )
                    .toList();
                // لو القسم ده مفيهوش كتب لسه (Empty State)
                if (filteredBooks.isEmpty) {
                  return StaggerdAnimation(
                    index: 0,
                    child: AppEmpty(
                      title:
                          "We are still curating our $selectedCategory collection.",
                      image: AppAssets.noResults,
                    ),
                  );
                }

                // لو فيه كتب، بنعرضها بنفس شياكة الـ Recommended
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredBooks.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: AppSpacing.md),
                      child: StaggerdAnimation(
                        index: index * 2,
                        child: RecommendedBookTile(book: filteredBooks[index]),
                      ),
                    );
                  },
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }
}
