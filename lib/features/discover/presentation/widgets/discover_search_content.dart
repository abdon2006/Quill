import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/states/EmptyStates/app_empty.dart';
import 'package:quill/core/theme/app_assets.dart';
import 'package:quill/core/theme/app_duration.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';
import 'package:quill/features/discover/presentation/search%20cubit/search_history_cubit.dart';
import 'package:quill/features/discover/presentation/widgets/recommended_tile.dart';
import 'package:quill/features/home/presentation/bloc/home_bloc.dart';
import 'package:quill/features/home/presentation/bloc/home_state.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DiscoverSearchContent extends StatelessWidget {
  final String searchQuery;
  final bool isTyping;
  final List<String> displayedHistory;
  final TextEditingController controller;
  final ValueChanged<String> onSearchItemTapped;

  const DiscoverSearchContent({
    super.key,
    required this.searchQuery,
    required this.isTyping,
    required this.displayedHistory,
    required this.controller,
    required this.onSearchItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      key: key,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedSwitcher(
                duration: AppDuration.normal,
                child: searchQuery.isNotEmpty
                    ? Text(
                        key: const ValueKey('search'),
                        'Search Results',
                        style: AppTextStyles.heading2(
                          context,
                        ).copyWith(fontWeight: FontWeight.w600),
                      )
                    : const SizedBox.shrink(key: ValueKey('empty')),
              ),
              if (searchQuery.isNotEmpty) SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is FetchBooksSuccess) {
                final searchResults = state.books.where((book) {
                  final titleMatch = book.title.toLowerCase().contains(
                    searchQuery.toLowerCase(),
                  );
                  final authorMatch = book.author.toLowerCase().contains(
                    searchQuery.toLowerCase(),
                  );
                  return titleMatch || authorMatch;
                }).toList();

                return AnimatedSwitcher(
                  duration: AppDuration.normal,
                  switchInCurve: Curves.easeInOutCubic,
                  switchOutCurve: Curves.easeIn,
                  child: searchQuery.isEmpty
                      ? displayedHistory.isEmpty
                            ? Text(
                                "Search for your next great read.",
                                style: AppTextStyles.defaultReading(context),
                              )
                            : Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Recent',
                                        style: AppTextStyles.displayMedium(
                                          context,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.1),
                                  ),
                                  const SizedBox(height: AppSpacing.lg),
                                  ...List.generate(displayedHistory.length, (
                                    i,
                                  ) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: AppSpacing.xs,
                                      ),
                                      child: Row(
                                        children: [
                                          InkWell(
                                            onTap: () => onSearchItemTapped(
                                              displayedHistory[i],
                                            ),
                                            child: Ink(
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: AppSpacing.sm,
                                                  vertical: AppSpacing.xs,
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius: AppRadius.xl,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface
                                                      .withValues(alpha: 0.1),
                                                ),
                                                child: Text(
                                                  displayedHistory[i],
                                                  style:
                                                      AppTextStyles.defaultReading(
                                                        context,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const Spacer(),
                                          InkWell(
                                            onTap: () => context
                                                .read<SearchHistoryCubit>()
                                                .deleteSearch(
                                                  displayedHistory[i],
                                                ),
                                            customBorder: const CircleBorder(),
                                            child: Ink(
                                              child: Container(
                                                padding: EdgeInsets.all(
                                                  AppSpacing.sm,
                                                ),
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                ),
                                                child: HugeIcon(
                                                  icon: HugeIcons
                                                      .strokeRoundedCancel01,
                                                  color: Theme.of(
                                                    context,
                                                  ).colorScheme.onSurface,
                                                  size: 16.sp,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                ],
                              )
                      : searchResults.isEmpty
                      ? AppEmpty(
                          title: "The archives are silent on '$searchQuery'.",
                          image: AppAssets.emptyResults,
                        )
                      : isTyping
                      ? Skeletonizer(
                          key: const ValueKey('loading'),
                          enabled: true,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: AppSpacing.md),
                                child: RecommendedBookTile(
                                  book: state.books[index],
                                ),
                              );
                            },
                          ),
                        )
                      : ListView.builder(
                          key: const ValueKey('results'),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: searchResults.length,
                          itemBuilder: (context, index) {
                            return RecommendedBookTile(
                              book: searchResults[index],
                              searchText: searchQuery,
                              onSave: (String value) => context
                                  .read<SearchHistoryCubit>()
                                  .saveSearch(value),
                            );
                          },
                        ),
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
