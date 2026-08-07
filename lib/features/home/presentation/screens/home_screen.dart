import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/widgets/premium_background.dart';
import 'package:quill/features/auth/domain/entities/user_entity.dart';
import 'package:quill/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:quill/features/auth/presentation/bloc/auth_state.dart';
import 'package:quill/features/home/presentation/bloc/home_bloc.dart';
import 'package:quill/features/home/presentation/bloc/home_event.dart';
import 'package:quill/features/home/presentation/bloc/home_state.dart';
import 'package:quill/features/home/presentation/widgets/book_grid_card.dart';
import 'package:quill/features/home/presentation/widgets/continue_reading.dart';
import 'package:quill/features/home/presentation/widgets/home_header.dart';
import 'package:quill/features/home/presentation/widgets/section_header.dart';
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
  final List<Map<String, String>> mockBooks = [
    {
      'title': 'Dune',
      'author': 'Frank Herbert',
      'cover':
          'https://images.unsplash.com/photo-1541961017774-22349e4a1262?q=80&w=400&auto=format&fit=crop',
    },
    {
      'title': 'The Silent Patient',
      'author': 'Alex Michaelides',
      // اللينك الجديد الشغال هنا 👇
      'cover':
          'https://images.unsplash.com/photo-1543002588-bfa74002ed7e?q=80&w=400&auto=format&fit=crop',
    },
    {
      'title': 'Atomic Habits',
      'author': 'James Clear',
      'cover':
          'https://images.unsplash.com/photo-1589829085413-56de8ae18c73?q=80&w=400&auto=format&fit=crop',
    },
    {
      'title': 'Solaris',
      'author': 'Stanislaw Lem',
      'cover':
          'https://images.unsplash.com/photo-1512820790803-83ca734da794?q=80&w=400&auto=format&fit=crop',
    },
    {
      'title': '1984',
      'author': 'George Orwell',
      'cover':
          'https://images.unsplash.com/photo-1532012197267-da84d127e765?q=80&w=400&auto=format&fit=crop',
    },
  ];

  Future<void> _onRefresh(BuildContext context) async {
    context.read<HomeBloc>().add(FetchHomeBooksEvent());
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
                BlocBuilder<AuthBloc, AuthState>(
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
                ),

                SizedBox(height: AppSpacing.lg),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                  ),
                  child: ContinueReading(ontap: () {}),
                ),

                SizedBox(height: AppSpacing.lg),

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

                BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    final books = Iterable.generate(3);
                    if (state is HomeLoading) {
                      return Skeletonizer(
                        enabled: true,
                        child: SizedBox(
                          height: 230.h,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.xl,
                            ),
                            scrollDirection: Axis.horizontal,
                            itemCount: books.length,
                            itemBuilder: (context, i) {
                              return BookGridCard(
                                onTap: () => context.push('/bookDeatails'),
                                bookCover: '',
                                bookTitle: '',
                                bookAuthor: '',
                              );
                            },
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
                            return BookGridCard(
                              onTap: () => context.push('/bookDeatails'),
                              bookCover: item.coverImage,
                              bookTitle: item.title,
                              bookAuthor: item.author,
                            );
                          },
                        ),
                      );
                    }

                    /// هن انا عارف طبعا ده مش بيست براكتيس بس ممكن نفكر سوا في الموضوع ه بس قيملي بس الكود
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
