import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/widgets/app_toast.dart';
import 'package:quill/core/widgets/toast_animation.dart';
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
  final toastAnimationKey = GlobalKey<ToastAnimationState>();
  bool isInWishlist = false;
  @override
  void initState() {
    super.initState();
    if (widget.book == null) {
      context.read<HomeBloc>().add(GetBookByIdEvent(bookId: widget.bookId!));
    }
    final wishliststate = context.read<LibraryBloc>().state;
    if (wishliststate is FetchSuccessState) {
      setState(() {
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
    return BlocListener<LibraryBloc, LibraryState>(
      listener: (context, state) async {
        if (state is AddSuccessState) {
          final overlayEntry = OverlayEntry(
            builder: (context) {
              return Align(
                alignment: Alignment.topCenter,
                child: Material(
                  color: Colors.transparent,
                  child: ToastAnimation(
                    key: toastAnimationKey,
                    child: AppToast(
                      label: 'Added to your library',
                      subLabel: 'Ready whenever you are.',
                      type: ToastType.success,
                    ),
                  ),
                ),
              );
            },
          );
          Overlay.of(context).insert(overlayEntry);
          setState(() => isInWishlist = true);

          await Future.delayed(Duration(seconds: 2));
          await toastAnimationKey.currentState?.dismiss();
          overlayEntry.remove();
        }
        if (state is RemoveSuccessState) {
          final overlayEntry = OverlayEntry(
            builder: (context) {
              return Align(
                alignment: Alignment.topCenter,
                child: Material(
                  color: Colors.transparent,
                  child: ToastAnimation(
                    key: toastAnimationKey,
                    child: AppToast(
                      label: 'Removed From your library',
                      subLabel: 'You can always add it back.',
                      type: ToastType.success,
                    ),
                  ),
                ),
              );
            },
          );
          Overlay.of(context).insert(overlayEntry);
          setState(() => isInWishlist = false);

          await Future.delayed(Duration(seconds: 2));
          await toastAnimationKey.currentState?.dismiss();
          overlayEntry.remove();
        }
      },
      child: Scaffold(
        extendBody: true,
        body: widget.book == null
            ? BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state is GetBookByIdSuccess) {
                    final book = state.book;
                    return _buildScreen(book, false);
                  }
                  if (state is HomeError) {}
                  if (state is HomeLoading) {
                    return _buildScreen(BookEntity.dummy(), true);
                  }
                  return SizedBox();
                },
              )
            : _buildScreen(widget.book!, false),
      ),
    );
  }

  Widget _buildScreen(BookEntity book, bool isLoading) {
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

        buildTopBar(context),

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
