import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:quill/core/router/app_router.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/features/discover/presentation/widgets/recommended_tile.dart';
import 'package:quill/features/discover/presentation/widgets/trending_book_card.dart';
import 'package:quill/features/home/presentation/bloc/home_bloc.dart';
import 'package:quill/features/home/presentation/bloc/home_state.dart';
import 'package:quill/features/home/presentation/widgets/Home/section_header.dart';
import 'package:quill/features/library/domain/entities/wishlist_entity.dart';
import 'package:quill/features/library/presentation/widgets/staggerd_animation.dart';

class DiscoverDefaultContent extends StatelessWidget {
  final List<WishlistEntity> wishlist;
  const DiscoverDefaultContent({super.key, required this.wishlist});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// section Header 'Trending'
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            children: [
              SizedBox(height: AppSpacing.xl),
              SectionHeader(title: 'Trending Books'),
              SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),

        /// Trending Books
        BlocConsumer<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is FetchBooksSuccess) {
              final displayedBooks = state.books.reversed.take(5).toList();
              return SizedBox(
                height: 350.h,
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, i) {
                    final item = displayedBooks[i];
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                      child: StaggerdAnimation(
                        index: i * 2,
                        child: TrendingBookCard(
                          isInWishlist: wishlist.any(
                            (wishlistBook) =>
                                wishlistBook.bookId.contains(item.id),
                          ),
                          book: item,
                          onTap: () => context.push(
                            AppRoutes.bookDeatails,
                            extra: item.id,
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, i) => SizedBox(width: 10.w),
                  itemCount: displayedBooks.length,
                ),
              );
            }
            return const SizedBox();
          },
          listener: (BuildContext context, HomeState state) {
            if (state is FetchBooksSuccess) {}
          },
        ),

        /// section Header 'Recommended'
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            children: [
              SizedBox(height: AppSpacing.xl),
              SectionHeader(title: 'Recommended'),
              SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),

        /// Recommended Books
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is FetchBooksSuccess) {
                final recommendedBooks = state.books.toList();
                // استخدمنا ListView.builder مع shrinkWrap عشان تشتغل جوه الـ ListView الأب
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: recommendedBooks.length,
                  itemBuilder: (context, index) {
                    return StaggerdAnimation(
                      index: index * 2,
                      child: RecommendedBookTile(book: recommendedBooks[index]),
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
