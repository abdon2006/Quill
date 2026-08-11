import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:quill/core/errors/failures.dart';
import 'package:quill/core/states/EmptyStates/app_empty.dart';
import 'package:quill/core/states/ErrorStates/app_error.dart';
import 'package:quill/core/theme/app_assets.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/widgets/premium_background.dart';
import 'package:quill/features/library/domain/Entities/wishlist_entity.dart';
import 'package:quill/features/library/presentation/bloc/library_bloc.dart';
import 'package:quill/features/library/presentation/bloc/library_state.dart';
import 'package:quill/features/library/presentation/widgets/staggerd_animation.dart';
import 'package:quill/features/library/presentation/widgets/chips_control.dart';
import 'package:quill/features/library/presentation/widgets/library_book_card.dart';
import 'package:quill/features/library/presentation/widgets/library_header.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return PremiumAuroraBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                  child: LibraryHeader(),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                  child: ChipsControl(
                    onChanged: (int value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                  ),
                ),

                BlocBuilder<LibraryBloc, LibraryState>(
                  builder: (context, state) {
                    if (state is FetchSuccessState) {
                      final books = state.books;
                      if (books.isEmpty) {
                        return StaggerdAnimation(
                          index: 0,
                          child: AppEmpty(
                            title: "Your shelf is waiting.",
                            subtitle: "Bring a book into your quiet space.",
                            image: AppAssets.emptyState,
                          ),
                        );
                      }
                      return _buildBooks(books);
                    }
                    if (state is LibraryLoading) {
                      return Skeletonizer(
                        child: _buildBooks(
                          List.generate(4, (i) => WishlistEntity.dummy()),
                        ),
                      );
                    }
                    if (state is LibraryError) {
                      if (state.failure is NetworkFailure) {
                        return StaggerdAnimation(
                          index: 0,
                          child: AppError(
                            image: AppAssets.error,
                            title: 'We lost the thread.',
                            subtitle:
                                'Check your connection and give it another try.',
                          ),
                        );
                      }
                      if (state.failure is ServerFailure) {
                        return StaggerdAnimation(
                          index: 0,
                          child: AppError(
                            image: AppAssets.error,
                            title: 'Quill needs a moment.',
                            subtitle:
                                'Something went wrong on our side. We\'ll be ready soon.',
                          ),
                        );
                      }
                      return StaggerdAnimation(
                        index: 0,
                        child: AppError(
                          image: AppAssets.error,
                          title: 'That didn\'t go as planned.',
                          subtitle:
                              'Something went wrong while loading this. Please try again.',
                        ),
                      );
                    }
                    return SizedBox();
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

Widget _buildBooks(List<WishlistEntity> books) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
    child: GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: books.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.55,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 20.h,
      ),
      itemBuilder: (context, i) {
        return StaggerdAnimation(
          index: i,
          child: LibraryBookCard(
            book: books[i],
            onTap: () => context.push('/bookDeatails', extra: books[i].bookId),
          ),
        );
      },
    ),
  );
}
