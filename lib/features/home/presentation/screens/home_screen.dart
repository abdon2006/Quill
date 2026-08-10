import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:quill/core/theme/app_assets.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/widgets/book_list_tile.dart';
import 'package:quill/core/widgets/premium_background.dart';
import 'package:quill/core/widgets/show_app_snack_bar.dart';
import 'package:quill/features/auth/domain/entities/user_entity.dart';
import 'package:quill/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:quill/features/auth/presentation/bloc/auth_state.dart';
import 'package:quill/features/home/presentation/bloc/home_bloc.dart';
import 'package:quill/features/home/presentation/bloc/home_event.dart';
import 'package:quill/features/home/presentation/bloc/home_state.dart';
import 'package:quill/features/home/presentation/widgets/Home/book_grid_card.dart';
import 'package:quill/features/home/presentation/widgets/Home/continue_reading.dart';
import 'package:quill/features/home/presentation/widgets/Home/home_header.dart';
import 'package:quill/features/home/presentation/widgets/Home/section_header.dart';
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

                /// Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                  ),
                  child: ContinueReading(ontap: () {}),
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
                        child: SizedBox(
                          height: 230.h,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.xl,
                            ),
                            children: [
                              Row(
                                children: List.generate(
                                  3,
                                  (i) => BookGridCard(
                                    onTap: () {},
                                    bookCover: '',
                                    bookTitle: 'Loading title here',
                                    bookAuthor: 'Loading author',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    if (state is FetchBooksSuccess) {
                      final books = state.books;
                      return SizedBox(
                        height: 230.h,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xl,
                          ),
                          scrollDirection: Axis.horizontal,
                          itemCount: books.length,
                          itemBuilder: (context, i) {
                            final item = books[i];
                            return StaggerdAnimation(
                              index: i,
                              child: BookGridCard(
                                onTap: () => context.push(
                                  '/bookDeatails',
                                  extra: state.books[i],
                                ),
                                bookCover: item.coverImage,
                                bookTitle: item.title,
                                bookAuthor: item.author,
                              ),
                            );
                          },
                        ),
                      );
                    }
                    if (state is HomeError) {
                      return SvgPicture.asset(AppAssets.noData);
                    }
                    return Text('');
                  },
                  listener: (BuildContext context, HomeState state) {
                    if (state is HomeError) {
                      showSnackBar(
                        context,
                        message: 'Couldn\'t Load Books',
                        messageDisc: 'Check Your Connection',
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
                    if (state is FetchBooksSuccess) {
                      final books = state.books;
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xl,
                        ),
                        child: Column(
                          children: List.generate(books.length, (i) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppSpacing.sm,
                              ),
                              child: StaggerdAnimation(
                                index: i,
                                child: GestureDetector(
                                  onTap: () => context.push(
                                    '/bookDeatails',
                                    extra: state.books[i],
                                  ),
                                  child: BookListTile(book: books[i]),
                                ),
                              ),
                            );
                          }),
                        ),
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
