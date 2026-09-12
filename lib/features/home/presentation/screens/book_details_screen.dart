import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/states/ErrorStates/app_error.dart';
import 'package:quill/core/theme/app_assets.dart';
import 'package:quill/core/theme/app_duration.dart';
import 'package:quill/core/theme/app_icons.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_toast.dart';
import 'package:quill/features/home/domain/entities/book_entity.dart';
import 'package:quill/features/home/presentation/bloc/home_bloc.dart';
import 'package:quill/features/home/presentation/bloc/home_event.dart';
import 'package:quill/features/home/presentation/bloc/home_state.dart';
import 'package:quill/features/home/presentation/widgets/DetailsScreen/build_about_section.dart';
import 'package:quill/features/home/presentation/widgets/DetailsScreen/build_book_identity.dart';
import 'package:quill/features/home/presentation/widgets/DetailsScreen/build_book_cover.dart';
import 'package:quill/features/home/presentation/widgets/DetailsScreen/build_bottom_action_buttons.dart';
import 'package:quill/features/home/presentation/widgets/DetailsScreen/build_for_who_section.dart';
import 'package:quill/features/home/presentation/widgets/DetailsScreen/build_recommendations.dart';
import 'package:quill/features/home/presentation/widgets/DetailsScreen/build_top_bar.dart';
import 'package:quill/features/home/presentation/widgets/DetailsScreen/build_topics_sections.dart';
import 'package:quill/features/library/presentation/bloc/library_bloc.dart';
import 'package:quill/features/library/presentation/bloc/library_state.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BookDetailsScreen extends StatefulWidget {
  final BookEntity? book;
  final String? bookId;
  const BookDetailsScreen({super.key, this.book, this.bookId});

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  final ScrollController _scrollController = ScrollController();
  bool isInWishlist = false;
  bool _bookError = false;
  @override
  void initState() {
    super.initState();
    if (widget.book == null) {
      /// if came to display server book dispatch the request
      context.read<HomeBloc>().add(GetBookByIdEvent(bookId: widget.bookId!));
    }
    final wishliststate = context.read<LibraryBloc>().state;
    if (wishliststate is FetchSuccessState) {
      setState(() {
        /// check this book of the all library books to know is it exist or not
        /// to handle the remove & add to library button
        isInWishlist = wishliststate.books.any((book) {
          if (widget.book == null) {
            return book.bookId == widget.bookId;
          } else {
            return book.bookId == widget.book!.id;
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return BlocListener<LibraryBloc, LibraryState>(
      listener: (context, state) async {
        if (state is AddSuccessState) {
          setState(() => isInWishlist = true);
          appToast(
            context: context,
            label: 'Added to your library.',
            description: 'Ready whenever you are.',
            theme: theme,
            isBlur: false,
            icon: HugeIcons.strokeRoundedFavourite,
          );
        }
        if (state is RemoveSuccessState) {
          setState(() => isInWishlist = false);
          appToast(
            context: context,
            label: 'Removed from your library.',
            description: 'You can always add it back.',
            theme: theme,
            isBlur: false,
            icon: HugeIcons.strokeRoundedArchive01,
          );
        }
      },
      child: Scaffold(
        extendBody: true,
        body: widget.book == null
            ? BlocConsumer<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state is GetBookByIdSuccess) {
                    final book = state.book;
                    return _buildScreen(
                      key: const ValueKey('success_state'),
                      book: book,
                      isLoading: false,
                      isError: _bookError,
                      theme: theme,
                      isLoadingForAddAndRemove: state is HomeLoading,
                      context: context,
                    );
                  }
                  return AnimatedSwitcher(
                    duration: AppDuration.slow,
                    child: state is HomeError
                        ? _buildErrorState(context: context, theme: theme)
                        : _buildScreen(
                            key: ValueKey('loading'),
                            book: BookEntity.dummy(),
                            isLoading: true,
                            isError: _bookError,
                            theme: theme,
                            context: context,
                          ),
                  );
                },
                listener: (BuildContext context, HomeState state) {
                  if (state is HomeError) setState(() => _bookError = true);
                },
              )
            : _buildScreen(
                book: widget.book!,
                isLoading: false,
                isError: _bookError,
                theme: theme,
                context: context,
              ),
      ),
    );
  }

  Widget _buildScreen({
    Key? key,
    required BuildContext context,
    required BookEntity book,
    required bool isLoading,
    required bool isError,
    required ColorScheme theme,
    bool? isLoadingForAddAndRemove,
  }) {
    return Stack(
      children: [
        Skeletonizer(
          enabled: isLoading,
          child: ListView(
            controller: _scrollController,
            padding: EdgeInsets.zero,
            children: [
              builBookCover(context, book.coverImage),

              const SizedBox(height: AppSpacing.xxl),

              buildBookIdentity(context, book),

              const SizedBox(height: AppSpacing.xxxl),

              buildAboutSection(context, book.aboutBook),

              const SizedBox(height: AppSpacing.xxl),

              buildTopicsSection(context, book.categories),

              const SizedBox(height: AppSpacing.xxl),

              buildForWhoSection(context, book.forWho),

              const SizedBox(height: AppSpacing.xxxl),

              buildRecommendations(context),

              const SizedBox(height: 150),
            ],
          ),
        ),

        buildTopBar(context: context, book: book),

        Positioned(
          left: 5.w,
          right: 5.w,
          bottom: 10.h,
          child: BuildBottomActions(
            isInWishlist: isInWishlist,
            bookId: widget.book == null ? widget.bookId! : widget.book!.id,
          ),
        ),
      ],
    );
  }
}

Widget _errorBackButton({
  required BuildContext context,
  required ColorScheme theme,
}) => Material(
  color: Colors.transparent,
  child: InkWell(
    onTap: () => context.pop(),
    customBorder: CircleBorder(),
    child: Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.secondary.withValues(alpha: 0.1),
      ),
      padding: EdgeInsets.all(AppSpacing.sm),
      child: HugeIcon(
        icon: AppIcons.back,
        color: theme.secondary.withValues(alpha: 0.7),
        // getIconsFgColor(state: state, context: context, theme: theme),
      ),
    ),
  ),
);

Widget _buildErrorState({
  required BuildContext context,
  required ColorScheme theme,
}) => SafeArea(
  key: ValueKey('error'),
  child: Stack(
    children: [
      AppError(
        title: 'The story slipped away.',
        subtitle:
            'Something went wrong while dusting off this book. Let\'s bring it back.',
        image: AppAssets.errorBookDetails,
      ),
      Positioned(
        top: 10.h,
        left: 20.w,
        child: _errorBackButton(context: context, theme: theme),
      ),
    ],
  ),
);
