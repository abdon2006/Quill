import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/theme/app_colors.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/widgets/app_button.dart';
import 'package:quill/core/widgets/premium_background.dart';
import 'package:quill/features/home/domain/entities/book_entity.dart';
import 'package:quill/features/home/presentation/widgets/book_cover_header.dart';
import 'package:quill/features/home/presentation/widgets/book_grid_card.dart';
import 'package:quill/features/home/presentation/widgets/book_info_section.dart';
import 'package:quill/features/home/presentation/widgets/book_stats_row.dart';
import 'package:quill/features/home/presentation/widgets/section_header.dart';
import 'package:quill/features/library/presentation/widgets/staggerd_animation.dart';

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
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PremiumAuroraBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: _buildButtons(),
        extendBody: true,
        appBar: _buildAppBar(context, theme),
        body: ListView(
          controller: _scrollController,
          children: [
            AnimatedBuilder(
              animation: _scrollController,
              builder: (context, child) {
                final offset = _scrollController.hasClients
                    ? _scrollController.offset
                    : 0.0;
                // بنحسب الشفافية: كل ما الـ offset يزيد، الشفافية تقل.
                // الـ 250 ده الارتفاع اللي بعده الكتاب هيختفي تماماً (تقدر تغيره براحتك).
                // الـ clamp بيضمن إن الرقم ميزيدش عن 1 ومايقلش عن 0 عشان التطبيق ميضربش.
                double opacity = (1 - (offset / 300)).clamp(0.0, 1.0);

                return Opacity(
                  opacity: opacity,
                  child: StaggerdAnimation(
                    index: 0,
                    child: BookCoverHeader(
                      bookCover: widget.book.coverImage,
                      bookTitle: widget.book.title,
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
              child: BookStatsRow(
                pages: widget.book.totalChunks,
                lang: widget.book.language,
                rating: widget.book.ratingAverage,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // 1. الوصف الأساسي
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: BookInfoSection(
                label: 'About this book',
                content: widget.book.aboutBook, // الداتا اللي جهزناها قبل كده
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // 2. التصنيفات
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: BookInfoSection(
                label: 'Topic',
                content: widget.book.categories.join(' '),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // 3. الفئة المستهدفة
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: BookInfoSection(
                label: 'For who',
                content: widget.book.forWho,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            const SizedBox(height: AppSpacing.xxl),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: SectionHeader(
                title: 'You Might Also Like',
                viewAllOnTap: () {},
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            SizedBox(
              height: 250.h,
              child: Row(
                children: [
                  Expanded(
                    child: BookGridCard(
                      bookCover:
                          'https://images.unsplash.com/photo-1589829085413-56de8ae18c73?q=80&w=400&auto=format&fit=crop',
                      bookTitle: 'Atomic Habits',
                      bookAuthor: 'Stanislaw Lem',
                    ),
                  ),
                  Expanded(
                    child: BookGridCard(
                      bookCover:
                          'https://images.unsplash.com/photo-1512820790803-83ca734da794?q=80&w=400&auto=format&fit=crop',
                      bookTitle: 'Solaris',
                      bookAuthor: 'James Clear',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}

Widget _buildButtons() {
  return ClipRRect(
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
      child: Container(
        color: AppColors.lightAccentMedium.withValues(alpha: 0.01),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.md,
            AppSpacing.xl,
            AppSpacing.md,
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppButton.primary(
                  text: 'Start Reading',
                  onPressed: () {},
                  icon: HugeIcons.strokeRoundedPlay,
                ),
                SizedBox(height: AppSpacing.sm),
                AppButton.secondary(
                  text: 'Add To Library',
                  onPressed: () {},
                  icon: HugeIcons.strokeRoundedLibrary,
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Widget _buildAppBarIcons(List<List<dynamic>> icon, ThemeData theme) {
  return InkWell(
    onTap: () {},
    customBorder: CircleBorder(),
    child: Container(
      padding: EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.colorScheme.primary,
      ),
      child: HugeIcon(icon: icon, color: theme.colorScheme.onPrimary),
    ),
  );
}

Widget _buildBackButton(BuildContext context, ThemeData theme) {
  return InkWell(
    onTap: () => context.pop(),
    customBorder: const CircleBorder(),
    child: Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.colorScheme.surface,
      ),
      child: HugeIcon(
        icon: HugeIcons.strokeRoundedArrowLeft01,
        color: theme.colorScheme.onSurface,
      ),
    ),
  );
}

PreferredSizeWidget _buildAppBar(BuildContext context, ThemeData theme) {
  return AppBar(
    actionsPadding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
    backgroundColor: Colors.transparent,
    // title: Text("Library", style: AppTextStyles.displayMedium(context)),
    elevation: 0,
    centerTitle: true,
    leading: Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: Center(child: _buildBackButton(context, theme)),
    ),
    actions: [
      _buildAppBarIcons(HugeIcons.strokeRoundedShare08, theme),
      SizedBox(width: AppSpacing.sm),
      _buildAppBarIcons(HugeIcons.strokeRoundedBookmark03, theme),
    ],
  );
}
