import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/router/app_router.dart';
import 'package:quill/core/states/EmptyStates/app_empty.dart';
import 'package:quill/core/states/ErrorStates/app_error.dart';
import 'package:quill/core/theme/app_assets.dart';
import 'package:quill/core/theme/app_duration.dart';
import 'package:quill/core/theme/app_radius.dart';
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
import 'package:quill/features/library/domain/entities/wishlist_entity.dart';
import 'package:quill/features/library/presentation/bloc/library_bloc.dart';
import 'package:quill/features/library/presentation/bloc/library_event.dart';
import 'package:quill/features/library/presentation/bloc/library_state.dart';
import 'package:quill/features/library/presentation/widgets/staggerd_animation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  List<BookEntity> allBooks = [];
  List<WishlistEntity> wishlist = [];
  int selectedChipIndex = 0;
  bool _isFocused = false;
  String _searchQuery = '';
  bool get _isSearchActive => _isFocused || _searchQuery.isNotEmpty;
  Timer? _timer;
  bool _isTyping = false;
  List<String> displayedHistory = [];
  final controller = TextEditingController();

  Widget _buildSearchContent({
    Key? key,
    required String searchQuery,
    required BuildContext context,
    required bool isTyping,
  }) => Column(
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
                      key: ValueKey('search'),
                      'Search Results',
                      style: AppTextStyles.heading2(
                        context,
                      ).copyWith(fontWeight: FontWeight.w600),
                    )
                  : SizedBox.shrink(key: ValueKey('empty')),
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
                                  color: Theme.of(context).colorScheme.onSurface
                                      .withValues(alpha: 0.1),
                                ),
                                const SizedBox(height: AppSpacing.lg),
                                ...List.generate(displayedHistory.length, (i) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: AppSpacing.xs,
                                    ),
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap: () => setState(() {
                                            _searchQuery = displayedHistory[i];
                                            controller.text =
                                                displayedHistory[i];
                                          }),
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
                                        Spacer(),
                                        InkWell(
                                          onTap: () => _deleteWordFromHistory(
                                            displayedHistory[i],
                                          ),
                                          customBorder: CircleBorder(),
                                          child: Ink(
                                            child: Container(
                                              padding: EdgeInsets.all(
                                                AppSpacing.sm,
                                              ),
                                              decoration: BoxDecoration(
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
                        key: ValueKey('loading'),
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
                        key: ValueKey('results'),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: searchResults.length,
                        itemBuilder: (context, index) {
                          return RecommendedBookTile(
                            book: searchResults[index],
                            searchText: searchQuery,
                            onSave: (String value) => _saveSearch(value),
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

  @override
  void initState() {
    super.initState();
    context.read<LibraryBloc>().add(FetchWishlistEvent());
    initHistory();
  }

  void initHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => displayedHistory = prefs.getStringList('history') ?? []);
  }

  void _saveSearch(String savedText) async {
    final prefs = await SharedPreferences.getInstance();
    final savedHistory = prefs.getStringList('history');
    if (savedHistory != null) {
      if (savedHistory.contains(savedText)) {
        return;
      }
      if (savedHistory.length == 5) {
        savedHistory.removeLast();
      }
      setState(() {
        savedHistory.insert(0, savedText);
      });
    }
    setState(() => displayedHistory = savedHistory ?? [savedText]);
    await prefs.setStringList('history', savedHistory ?? [savedText]);
  }

  void _deleteWordFromHistory(String deletedWord) async {
    setState(() => displayedHistory.remove(deletedWord));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('history', displayedHistory);
  }

  @override
  Widget build(BuildContext context) {
    return PremiumAuroraBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            physics: const BouncingScrollPhysics(),
            children: [
              BlocListener<LibraryBloc, LibraryState>(
                listener: (context, state) {
                  if (state is FetchSuccessState) {
                    setState(() => wishlist = state.books);
                  }
                },
                child: SizedBox.shrink(),
              ),

              /// Header & Search Bar / ثابت
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Discover',
                      style: AppTextStyles.displayLarge(context),
                    ),
                    SizedBox(height: AppSpacing.xl),
                    DiscoverSearchBar(
                      onChanged: (String p1) {
                        final isDeleted = p1.length > _searchQuery.length;
                        if (isDeleted) {
                          setState(() => _isTyping = true);
                        }
                        _timer?.cancel();
                        _timer = Timer(
                          isDeleted ? Duration.zero : AppDuration.normal,
                          () => setState(() {
                            _isTyping = false;
                            _searchQuery = p1;
                          }),
                        );
                      },
                      onFocus: (bool isFocused) =>
                          setState(() => _isFocused = isFocused),
                      controller: controller,
                    ),
                    SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),

              /// Filter Chips / ثابتة
              AnimatedSwitcher(
                duration: AppDuration.slow,
                switchInCurve: Curves.easeInOutCubic,
                switchOutCurve: Curves.easeIn,
                child: _isSearchActive
                    ? null
                    : DiscoverFilteredChips(
                        onSelectedCategory: (int index) =>
                            setState(() => selectedChipIndex = index),
                        selectedIndex: selectedChipIndex,
                      ),
              ),

              /// category محتوي الصفحة بقا الي بيتغير مع كل حالة واء بحث او اختيار
              BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state is FetchBooksSuccess) {
                    final books = state.books;
                    if (books.isEmpty) {
                      return AppEmpty(
                        title:
                            "Our library is currently taking a pause. Check back later.",
                        image: AppAssets.peace,
                      );
                    }
                    return AnimatedSwitcher(
                      duration: AppDuration.slow,
                      switchInCurve: Curves.easeInOutCubic,
                      switchOutCurve: Curves.easeIn,
                      child: _isSearchActive
                          ? _buildSearchContent(
                              isTyping: _isTyping,
                              context: context,
                              searchQuery: _searchQuery,
                              key: ValueKey('search'),
                            )
                          : selectedChipIndex != 0
                          ? _buildCategoryContent(
                              key: ValueKey('category'),
                              selectedChipIndex: selectedChipIndex,
                            )
                          : _buildDefaultContent(
                              key: ValueKey('default'),
                              wishlist: wishlist,
                            ),
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
                    child: _buildDefaultContent(wishlist: wishlist),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildCategoryContent({
  Key? key,
  required int selectedChipIndex,
}) => Column(
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

Widget _buildDefaultContent({
  Key? key,
  required List<WishlistEntity> wishlist,
}) => Column(
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
                        (wishlistBook) => wishlistBook.bookId.contains(item.id),
                      ),
                      book: item,
                      onTap: () =>
                          context.push(AppRoutes.bookDeatails, extra: item.id),
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
