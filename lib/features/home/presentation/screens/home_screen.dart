import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/router/app_router.dart';
import 'package:quill/core/theme/app_colors.dart';
import 'package:quill/core/theme/app_duration.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_toast.dart';
import 'package:quill/core/usecases/base_usecase.dart';
import 'package:quill/core/widgets/book_list_tile.dart';
import 'package:quill/core/widgets/premium_background.dart';
import 'package:quill/features/auth/domain/entities/user_entity.dart';
import 'package:quill/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:quill/features/auth/presentation/bloc/auth_event.dart';
import 'package:quill/features/auth/presentation/bloc/auth_state.dart';
import 'package:quill/features/home/domain/entities/book_entity.dart';
import 'package:quill/features/home/presentation/bloc/home_bloc.dart';
import 'package:quill/features/home/presentation/bloc/home_event.dart';
import 'package:quill/features/home/presentation/bloc/home_state.dart';
import 'package:quill/features/home/presentation/widgets/Home/book_grid_card.dart';
import 'package:quill/features/home/presentation/widgets/Home/continue_reading.dart';
import 'package:quill/features/home/presentation/widgets/Home/empty_local_book_import.dart';
import 'package:quill/features/home/presentation/widgets/Home/empty_server_book.dart';
import 'package:quill/features/home/presentation/widgets/Home/home_header.dart';
import 'package:quill/features/home/presentation/widgets/Home/quote_of_the_day.dart';
import 'package:quill/features/home/presentation/widgets/Home/section_header.dart';
import 'package:quill/features/library/domain/entities/wishlist_entity.dart';
import 'package:quill/features/library/presentation/bloc/library_bloc.dart';
import 'package:quill/features/library/presentation/bloc/library_state.dart';
import 'package:quill/features/library/presentation/widgets/staggerd_animation.dart';
import 'package:quill/features/reader/domain/usecases/params/reader_book_params.dart';
import 'package:quill/features/reader/presentation/bloc/reader_bloc.dart';
import 'package:quill/features/reader/presentation/bloc/reader_event.dart';
import 'package:quill/features/reader/presentation/bloc/reader_state.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLocalBooksExist = false;

  Future<void> _onRefresh(BuildContext context) async {
    final homeFuture = context.read<HomeBloc>().stream.firstWhere(
      (state) => state is FetchBooksSuccess || state is HomeError,
    );
    final authFuture = context.read<AuthBloc>().stream.firstWhere(
      (state) => state is FetchUserDataSuccess || state is AuthError,
    );
    context.read<AuthBloc>().add(FetchUserDataEvent(params: NoParams()));
    context.read<HomeBloc>().add(RefreshBookEvent());
    await Future.wait([homeFuture, authFuture]);
  }

  @override
  void initState() {
    super.initState();
    context.read<ReaderBloc>().add(FetchLocalBooksEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBgPrimary : AppColors.lightBgPrimary;
    return Stack(
      children: [
        PremiumAuroraBackground(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: RefreshIndicator(
                onRefresh: () => _onRefresh(context),
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
                  children: [
                    BlocListener<ReaderBloc, ReaderState>(
                      listener: (context, state) {
                        if (state is FetchLocalBooksSuccess &&
                            state.localBooks.isNotEmpty) {
                          setState(() => _isLocalBooksExist = true);
                        }
                      },
                      child: const SizedBox.shrink(),
                    ),

                    /// 1. Header (Animated)
                    Align(
                      alignment: AlignmentGeometry.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xl,
                        ),
                        child: BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            final dummyUser = UserEntity(
                              id: '',
                              name: 'abdallah',
                              email: '',
                              currentStreak: 0,
                              longestStreak: 0,
                            );
                            return AnimatedSwitcher(
                              duration: const Duration(milliseconds: 400),
                              switchInCurve: Curves.easeOut,
                              switchOutCurve: Curves.easeIn,
                              child: state is AuthLoading
                                  ? Skeletonizer(
                                      key: const ValueKey('header_loading'),
                                      enabled: true,
                                      child: HomeHeader(user: dummyUser),
                                    )
                                  : HomeHeader(
                                      key: const ValueKey('header_loaded'),
                                      user: state is FetchUserDataSuccess
                                          ? state.userEntity
                                          : dummyUser,
                                    ),
                            );
                          },
                        ),
                      ),
                    ),

                    SizedBox(height: AppSpacing.xl),

                    /// 2. Continue Reading (Animated)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xl,
                      ),
                      child: BlocBuilder<LibraryBloc, LibraryState>(
                        builder: (context, state) {
                          Widget childWidget = const SizedBox.shrink(
                            key: ValueKey('empty'),
                          );

                          if (state is FetchSuccessState) {
                            if (state.books.isEmpty) {
                              childWidget = EmptyServerBook(
                                key: const ValueKey('empty_server'),
                              );
                            } else {
                              final book = state.books.first;
                              childWidget = ContinueReading(
                                key: ValueKey(
                                  'continue_reading_${book.bookId}',
                                ),
                                onTap: () => context.push(
                                  AppRoutes.reader,
                                  extra: ReaderBookParams(
                                    serverId: book.bookId,
                                  ),
                                ),
                                book: book,
                              );
                            }
                          } else if (!_isLocalBooksExist) {
                            childWidget = EmptyLocalBookImport(
                              key: const ValueKey('empty_local'),
                              onImport: () {},
                            );
                          }
                          return AnimatedSize(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOutCubic,
                            alignment: Alignment.topCenter,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 400),
                              layoutBuilder: (currentChild, previousChildren) {
                                // ده بيمنع الشاشة تنط بشكل حاد وقت التغيير
                                return Stack(
                                  alignment: Alignment.topCenter,
                                  children: <Widget>[
                                    ...previousChildren,
                                    if (currentChild != null) currentChild,
                                  ],
                                );
                              },
                              child: childWidget,
                            ),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: AppSpacing.xl),

                    /// Section Header - Recently Added
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xl,
                      ),
                      child: SectionHeader(
                        title: 'Recently Added',
                        viewAllOnTap: () => context.go(AppRoutes.discover),
                      ),
                    ),
                    SizedBox(height: AppSpacing.lg),

                    /// 3. Recently Added (Animated)
                    BlocConsumer<HomeBloc, HomeState>(
                      listener: (context, state) {
                        if (state is HomeError) {
                          appToast(
                            context: context,
                            label: 'Your shelf couldn\'t be reached.',
                            description: 'Check your connection and try again.',
                            theme: theme,
                            icon: HugeIcons.strokeRoundedCloudOff,
                          );
                        }
                      },
                      builder: (context, state) {
                        Widget childWidget;

                        if (state is HomeLoading) {
                          childWidget = Skeletonizer(
                            key: const ValueKey('recent_loading'),
                            enabled: true,
                            child: _buildRecentlyUsedDataLoadingState(
                              List.generate(
                                3,
                                (i) => BookGridCard(book: BookEntity.dummy()),
                              ),
                            ),
                          );
                        } else if (state is FetchBooksSuccess) {
                          childWidget = _buildRecentlyUsedDataSuccessState(
                            books: state.books.reversed.take(5).toList(),
                            key: const ValueKey('recent_success'),
                          );
                        } else if (state is HomeError &&
                            state.cachedBooks != null &&
                            state.cachedBooks!.isNotEmpty) {
                          childWidget = _buildRecentlyUsedDataSuccessState(
                            books: state.cachedBooks!,
                            key: const ValueKey('recent_cached'),
                          );
                        } else {
                          childWidget = const SizedBox(
                            key: ValueKey('recent_empty'),
                          );
                        }

                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          child: childWidget,
                        );
                      },
                    ),

                    SizedBox(height: AppSpacing.xl),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xl,
                      ),
                      child: SectionHeader(title: 'Quote Of The Day'),
                    ),
                    SizedBox(height: AppSpacing.lg),

                    /// Quote
                    Padding(
                      padding: EdgeInsetsGeometry.symmetric(
                        horizontal: AppSpacing.xl,
                      ),
                      child: BlocBuilder<HomeBloc, HomeState>(
                        builder: (context, state) {
                          return AnimatedSwitcher(
                            duration: AppDuration.normal,
                            child: state is HomeLoading
                                ? Skeletonizer(
                                    key: ValueKey('loading'),
                                    enabled: true,
                                    child: QuoteOfTheDay(),
                                  )
                                : QuoteOfTheDay(key: ValueKey('quote')),
                          );
                        },
                      ),
                    ),

                    /// 4. From Library (Animated)
                    BlocBuilder<LibraryBloc, LibraryState>(
                      builder: (context, state) {
                        Widget childWidget = const SizedBox(
                          key: ValueKey('lib_empty'),
                        );

                        if (state is LibraryLoading) {
                          childWidget = _buildFromLibraryLoadingState(
                            key: const ValueKey('lib_loading'),
                          );
                        } else if (state is FetchSuccessState &&
                            state.books.isNotEmpty) {
                          childWidget = _buildFromLibrarySuccessState(
                            key: const ValueKey('lib_success'),
                            books: state.books.take(5).toList(),
                            context: context,
                          );
                        }

                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          switchInCurve: Curves.easeOutCubic,
                          child: childWidget,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: IgnorePointer(
            child: Container(
              height: 150.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [bgColor.withValues(alpha: 0), bgColor],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentlyUsedDataLoadingState(List<Widget> data) {
    return SizedBox(
      height: 230.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        children: [Row(children: data)],
      ),
    );
  }

  Widget _buildRecentlyUsedDataSuccessState({
    required List<BookEntity> books,
    Key? key,
  }) {
    return SizedBox(
      key: key,
      height: 230.h,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        scrollDirection: Axis.horizontal,
        itemCount: books.length,
        itemBuilder: (context, i) {
          final item = books[i];
          return StaggerdAnimation(
            index: i,
            child: BookGridCard(
              onTap: () => context.push('/bookDeatails', extra: books[i]),
              book: item,
            ),
          );
        },
      ),
    );
  }

  Widget _buildFromLibraryLoadingState({Key? key}) {
    final books = List.generate(3, (i) => WishlistEntity.dummy());
    return Skeletonizer(
      key: key,
      enabled: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              child: SectionHeader(title: 'From Library'),
            ),
            ...List.generate(books.length, (i) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: BookListTile(book: books[i]),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildFromLibrarySuccessState({
    required List<WishlistEntity> books,
    required BuildContext context,
    Key? key,
  }) {
    return Padding(
      key: key,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.xl,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: SectionHeader(
              title: 'From Library',
              viewAllOnTap: () => context.go(AppRoutes.library),
            ),
          ),
          ...List.generate(books.length, (i) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: StaggerdAnimation(
                index: i,
                child: GestureDetector(
                  onTap: () =>
                      context.push('/bookDeatails', extra: books[i].bookId),
                  child: BookListTile(book: books[i]),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
