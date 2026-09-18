import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/states/EmptyStates/app_empty.dart';
import 'package:quill/core/states/ErrorStates/app_error.dart';
import 'package:quill/core/theme/app_assets.dart';
import 'package:quill/core/theme/app_duration.dart';
import 'package:quill/core/theme/app_icons.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';
import 'package:quill/core/widgets/premium_background.dart';
import 'package:quill/features/discover/presentation/search%20cubit/search_history_cubit.dart';
import 'package:quill/features/discover/presentation/search%20cubit/search_history_state.dart';
import 'package:quill/features/discover/presentation/widgets/discover_category_content.dart';
import 'package:quill/features/discover/presentation/widgets/discover_default_content.dart';
import 'package:quill/features/discover/presentation/widgets/discover_filtered_chips.dart';
import 'package:quill/features/discover/presentation/widgets/discover_search_bar.dart';
import 'package:quill/features/discover/presentation/widgets/discover_search_content.dart';
import 'package:quill/features/home/domain/entities/book_entity.dart';
import 'package:quill/features/home/presentation/bloc/home_bloc.dart';
import 'package:quill/features/home/presentation/bloc/home_state.dart';
import 'package:quill/features/library/domain/entities/wishlist_entity.dart';
import 'package:quill/features/library/presentation/bloc/library_bloc.dart';
import 'package:quill/features/library/presentation/bloc/library_event.dart';
import 'package:quill/features/library/presentation/bloc/library_state.dart';
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
  List<BookEntity> recommendedBooks = [];
  List<BookEntity> bestSellerBooks = [];
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<LibraryBloc>().add(FetchWishlistEvent());
    context.read<SearchHistoryCubit>().loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return PremiumAuroraBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            physics: const BouncingScrollPhysics(),
            children: [
              MultiBlocListener(
                listeners: [
                  BlocListener<SearchHistoryCubit, SearchHistoryState>(
                    listener: (context, state) {
                      if (state is SearchHistoryLoaded) {
                        setState(() => displayedHistory = state.searchHistory);
                      }
                    },
                  ),

                  BlocListener<LibraryBloc, LibraryState>(
                    listener: (context, state) {
                      if (state is FetchSuccessState) {
                        setState(() {
                          wishlist = state.books;
                        });
                      }
                    },
                  ),

                  BlocListener<HomeBloc, HomeState>(
                    listener: (context, state) {
                      if (state is FetchBooksSuccess &&
                          recommendedBooks.isEmpty &&
                          bestSellerBooks.isEmpty) {
                        setState(() {
                          final shuffled = List<BookEntity>.from(state.books)
                            ..shuffle();
                          recommendedBooks = shuffled.take(5).toList();
                          bestSellerBooks = state.books
                              .where((book) => book.ratingAverage >= 4.5)
                              .take(5)
                              .toList();
                        });
                      }
                    },
                  ),
                ],
                child: SizedBox(),
              ),

              /// Header & Search Bar / ثابت
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: AppSpacing.xl),
                    child: Text(
                      'Discover',
                      style: AppTextStyles.displayLarge(context),
                    ),
                  ),
                  SizedBox(height: AppSpacing.xl),
                  AnimatedPadding(
                    duration: AppDuration.slow,
                    curve: Curves.easeInOutCubic,
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                    child: Row(
                      children: [
                        AnimatedContainer(
                          duration: AppDuration.slow,
                          curve: Curves.easeInOutCubic,
                          width: _isFocused ? 40.w + AppSpacing.lg : 0,
                          child: _isFocused
                              ? InkWell(
                                  customBorder: CircleBorder(),
                                  onTap: () {
                                    controller.clear();
                                    setState(() {
                                      _searchQuery = '';
                                      _isFocused = false;
                                    });
                                    FocusScope.of(context).unfocus();
                                  },
                                  child: HugeIcon(
                                    icon: AppIcons.back,
                                    color: theme.secondary,
                                  ),
                                )
                              : null,
                        ),
                        Expanded(
                          child: DiscoverSearchBar(
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
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSpacing.xl),
                ],
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
                          ? DiscoverSearchContent(
                              key: const ValueKey('search'),
                              isTyping: _isTyping,
                              searchQuery: _searchQuery,
                              displayedHistory: displayedHistory,
                              controller: controller,
                              onSearchItemTapped: (String selectedWord) {
                                setState(() {
                                  _searchQuery = selectedWord;
                                  controller.text = selectedWord;
                                });
                              },
                            )
                          : selectedChipIndex != 0
                          ? DiscoverCategoryContent(
                              key: ValueKey('category'),
                              selectedChipIndex: selectedChipIndex,
                            )
                          : DiscoverDefaultContent(
                              key: ValueKey('default'),
                              recommendedBooks: recommendedBooks,
                              bestSellerBooks: bestSellerBooks,
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
                    child: DiscoverDefaultContent(
                      recommendedBooks: recommendedBooks,
                      bestSellerBooks: bestSellerBooks,
                      wishlist: wishlist,
                    ),
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
