import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/widgets/app_button.dart';
import 'package:quill/features/home/domain/entities/book_entity.dart';
import 'package:quill/features/home/presentation/widgets/DetailsScreen/build_about_section.dart';
import 'package:quill/features/home/presentation/widgets/DetailsScreen/build_book_identity.dart';
import 'package:quill/features/home/presentation/widgets/DetailsScreen/build_book_cover.dart';
import 'package:quill/features/home/presentation/widgets/DetailsScreen/build_for_who_section.dart';
import 'package:quill/features/home/presentation/widgets/DetailsScreen/build_recommendations.dart';
import 'package:quill/features/home/presentation/widgets/DetailsScreen/build_top_bar.dart';
import 'package:quill/features/home/presentation/widgets/DetailsScreen/build_topics_sections.dart';

class BookDetailsScreen extends StatefulWidget {
  final BookEntity book;
  const BookDetailsScreen({super.key, required this.book});

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          ListView(
            controller: _scrollController,
            padding: EdgeInsets.zero,
            children: [
              builBookCover(context, widget.book.coverImage),

              const SizedBox(height: AppSpacing.xxl),

              buildBookIdentity(context, widget.book),

              const SizedBox(height: AppSpacing.xxxl),

              buildAboutSection(context, widget.book.aboutBook),

              const SizedBox(height: AppSpacing.xxl),

              buildTopicsSection(context, widget.book.categories),

              const SizedBox(height: AppSpacing.xxl),

              buildForWhoSection(context, widget.book.forWho),

              const SizedBox(height: AppSpacing.xxxl),

              buildRecommendations(context),

              const SizedBox(height: 150),
            ],
          ),

          buildTopBar(context),

          _buildBottomActions(context),
        ],
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Positioned(
      left: 5.w,
      right: 5.w,
      bottom: 10.h,
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: AppButton.secondary(
                text: 'Add to Library',
                icon: HugeIcons.strokeRoundedLibrary,
                onPressed: () {},
              ),
            ),

            const SizedBox(width: AppSpacing.sm),

            Expanded(
              child: AppButton.primary(
                text: 'Start Reading',
                icon: HugeIcons.strokeRoundedPlay,
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
