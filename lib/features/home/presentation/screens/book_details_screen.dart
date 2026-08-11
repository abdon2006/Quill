import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quill/core/theme/app_spacing.dart';
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

class BookDetailsScreen extends StatefulWidget {
  final BookEntity? book;
  final String? bookId;
  const BookDetailsScreen({super.key, this.book, this.bookId});

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (widget.book == null) {
      context.read<HomeBloc>().add(GetBookByIdEvent(bookId: widget.bookId!));
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: widget.book == null
          ? BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state is GetBookByIdSuccess) {
                  final book = state.book;
                  return _buildScreen(book);
                }
                if (state is HomeError) {}
                if (state is HomeLoading) {}
                return SizedBox();
              },
            )
          : _buildScreen(widget.book!),
    );
  }

  Widget _buildScreen(BookEntity book) {
    return Stack(
      children: [
        ListView(
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

        buildTopBar(context),

        buildBottomActions(context),
      ],
    );
  }
}
