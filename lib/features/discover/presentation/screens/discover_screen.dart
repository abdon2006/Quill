import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:quill/core/router/app_router.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';
import 'package:quill/core/widgets/premium_background.dart';
import 'package:quill/features/discover/presentation/widgets/discover_filtered_chips.dart';
import 'package:quill/features/discover/presentation/widgets/discover_search_bar.dart';
import 'package:quill/features/discover/presentation/widgets/recommended_tile.dart';
import 'package:quill/features/discover/presentation/widgets/trending_book_card.dart';
import 'package:quill/features/home/domain/entities/book_entity.dart';
import 'package:quill/features/home/presentation/bloc/home_bloc.dart';
import 'package:quill/features/home/presentation/bloc/home_state.dart';
import 'package:quill/features/home/presentation/widgets/Home/section_header.dart';
import 'package:quill/features/library/presentation/widgets/staggerd_animation.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  List<BookEntity> allBooks = [];
  int selectedChipIndex = 0;
  bool _isFocused = false;
  @override
  Widget build(BuildContext context) {
    return PremiumAuroraBackground(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      /// Header
                      Text(
                        'Discover',
                        textAlign: TextAlign.start,
                        style: AppTextStyles.displayLarge(context),
                      ),
                      SizedBox(height: AppSpacing.xl),

                      /// Search Bar
                      DiscoverSearchBar(
                        onChanged: (String p1) {
                          print(p1);
                        },
                        onFocus: (bool isFocused) =>
                            setState(() => _isFocused = isFocused),
                      ),
                      SizedBox(height: AppSpacing.xl),
                    ]),
                  ),
                ),

                /// Filter Chips
                SliverToBoxAdapter(
                  child: DiscoverFilteredChips(
                    onSelectedCategory: (int index) =>
                        setState(() => selectedChipIndex = index),
                  ),
                ),

                /// section Header 'Trending'
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      SizedBox(height: AppSpacing.xl),
                      SectionHeader(
                        title: 'Trending Classics',
                        viewAllOnTap: () {},
                      ),
                      SizedBox(height: AppSpacing.xl),
                    ]),
                  ),
                ),

                /// Trending Books
                SliverToBoxAdapter(
                  child: BlocConsumer<HomeBloc, HomeState>(
                    builder: (context, state) {
                      if (state is FetchBooksSuccess) {
                        final displayedBooks = state.books.reversed
                            .take(5)
                            .toList();
                        return SizedBox(
                          height: 200.h,
                          child: ListView.separated(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                            ),
                            scrollDirection: Axis.horizontal,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, i) {
                              final item = displayedBooks[i];
                              return StaggerdAnimation(
                                index: i * 2,
                                child: TrendingBookCard(
                                  book: item,
                                  onTap: () => context.push(
                                    AppRoutes.bookDeatails,
                                    extra: item.id,
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, i) =>
                                SizedBox(width: 10.w),
                            itemCount: displayedBooks.length,
                          ),
                        );
                      }
                      return SizedBox();
                    },
                    listener: (BuildContext context, HomeState state) {
                      if (state is FetchBooksSuccess) {}
                    },
                  ),
                ),

                /// section Header 'Recommended'
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      SizedBox(height: AppSpacing.xl),
                      SectionHeader(title: 'Recommended'),
                      SizedBox(height: AppSpacing.xl),
                    ]),
                  ),
                ),

                /// Trending Books
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                  sliver: BlocBuilder<HomeBloc, HomeState>(
                    builder: (context, state) {
                      if (state is FetchBooksSuccess) {
                        final recommendedBooks = state.books.toList();
                        return SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: AppSpacing.md),
                              child: StaggerdAnimation(
                                index: index * 2,
                                child: RecommendedBookTile(
                                  book: recommendedBooks[index],
                                ),
                              ),
                            );
                          }, childCount: recommendedBooks.length),
                        );
                      }
                      return SliverToBoxAdapter(child: SizedBox());
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
