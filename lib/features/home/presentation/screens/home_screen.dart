import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/widgets/book_list_tile.dart';
import 'package:quill/core/widgets/premium_background.dart';
import 'package:quill/core/widgets/show_app_snack_bar.dart';
import 'package:quill/features/auth/domain/entities/user_entity.dart';
import 'package:quill/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:quill/features/auth/presentation/bloc/auth_state.dart';
import 'package:quill/features/home/domain/entities/book_entity.dart';
import 'package:quill/features/home/presentation/bloc/home_bloc.dart';
import 'package:quill/features/home/presentation/bloc/home_event.dart';
import 'package:quill/features/home/presentation/bloc/home_state.dart';
import 'package:quill/features/home/presentation/widgets/Home/book_grid_card.dart';
import 'package:quill/features/home/presentation/widgets/Home/continue_reading.dart';
import 'package:quill/features/home/presentation/widgets/Home/continue_reading_empty.dart';
import 'package:quill/features/home/presentation/widgets/Home/home_header.dart';
import 'package:quill/features/home/presentation/widgets/Home/section_header.dart';
import 'package:quill/features/library/presentation/bloc/library_bloc.dart';
import 'package:quill/features/library/presentation/bloc/library_state.dart';
import 'package:quill/features/library/presentation/widgets/staggerd_animation.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final dummyUser = UserEntity(
    id: '',
    name: '',
    email: '',
    currentStreak: 0,
    longestStreak: 0,
  );
  // ضيف اللستة دي جوه الـ StatelessWidget قبل الـ build أو خليها في ملف منفصل للـ Mock Data
  Future<void> _onRefresh(BuildContext context) async {
    context.read<HomeBloc>().add(RefreshBookEvent());
    await context.read<HomeBloc>().stream.firstWhere(
      (state) => state is FetchBooksSuccess || state is HomeError,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PremiumAuroraBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () => _onRefresh(context),
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
              children: [
                /// Header
                BlocConsumer<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is AuthLoading) {
                      return Skeletonizer(
                        enabled: true,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xl,
                          ),
                          child: HomeHeader(user: dummyUser),
                        ),
                      );
                    }
                    if (state is FetchUserDataSuccess) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xl,
                        ),
                        child: HomeHeader(user: state.userEntity),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xl,
                      ),
                      child: HomeHeader(user: dummyUser),
                    );
                  },
                  listener: (BuildContext context, AuthState state) {},
                ),

                SizedBox(height: AppSpacing.lg),

                /// Continue reading
                BlocBuilder<LibraryBloc, LibraryState>(
                  builder: (context, state) {
                    if (state is FetchSuccessState) {
                      final books = state.books;
                      if (books.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xl,
                          ),
                          child: ContinueReadingEmpty(onImport: () {}),
                        );
                      }
                      final book = books.take(1).toList()[0];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xl,
                        ),
                        child: ContinueReading(onTap: () {}, book: book),
                      );
                    }
                    return SizedBox();
                  },
                ),

                SizedBox(height: AppSpacing.lg),

                /// Section Header - Recently Added
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                  ),
                  child: SectionHeader(
                    title: 'Recently Added',
                    viewAllOnTap: () {},
                  ),
                ),

                SizedBox(height: AppSpacing.lg),

                /// Recently Added
                BlocConsumer<HomeBloc, HomeState>(
                  builder: (context, state) {
                    if (state is HomeLoading) {
                      return Skeletonizer(
                        enabled: true,
                        child: _buildRecentlyUsedDataLoadingState(
                          List.generate(
                            3,
                            (i) => BookGridCard(book: BookEntity.dummy()),
                          ),
                        ),
                      );
                    }
                    if (state is FetchBooksSuccess) {
                      final books = state.books;
                      return _buildRecentlyUsedDataSuccessState(books);
                    }
                    if (state is HomeError) {
                      final books = state.cachedBooks;
                      if (books != null && books.isNotEmpty) {
                        return _buildRecentlyUsedDataSuccessState(books);
                      }
                      return _buildRecentlyUsedDataLoadingState(
                        List.generate(
                          3,
                          (i) => BookGridCard(book: BookEntity.dummy()),
                        ),
                      );
                    }
                    return SizedBox();
                  },
                  listener: (BuildContext context, HomeState state) {
                    if (state is HomeError) {
                      showSnackBar(
                        context,
                        message: 'Your shelf couldn\'t be reached.',
                        messageDisc: 'Check your connection and try again.',
                      );
                    }
                  },
                ),

                /// Section Header - From Library
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                    vertical: AppSpacing.xl,
                  ),
                  child: SectionHeader(
                    title: 'From Library',
                    viewAllOnTap: () {},
                  ),
                ),

                /// From Library
                BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    if (state is HomeLoading) {
                      return _buildFromLibraryLoadingState();
                    }
                    if (state is FetchBooksSuccess) {
                      return _buildFromLibrarySuccessState(
                        state.books,
                        context,
                      );
                    }

                    return Text('');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
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

Widget _buildRecentlyUsedDataSuccessState(List<BookEntity> books) {
  return SizedBox(
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

Widget _buildFromLibraryLoadingState() {
  final books = List.generate(3, (i) => BookEntity.dummy());
  return Skeletonizer(
    enabled: true,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        children: List.generate(books.length, (i) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: BookListTile(book: books[i]),
          );
        }),
      ),
    ),
  );
}

Widget _buildFromLibrarySuccessState(
  List<BookEntity> books,
  BuildContext context,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
    child: Column(
      children: List.generate(books.length, (i) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: StaggerdAnimation(
            index: i,
            child: GestureDetector(
              onTap: () => context.push('/bookDeatails', extra: books[i]),
              child: BookListTile(book: books[i]),
            ),
          ),
        );
      }),
    ),
  );
}
