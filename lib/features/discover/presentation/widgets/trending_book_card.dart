import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:quill/core/theme/app_colors.dart';
import 'package:quill/core/theme/app_duration.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_shadows.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';
import 'package:quill/core/widgets/build_cover_placeholder.dart';
import 'package:quill/features/home/domain/entities/book_entity.dart';
import 'package:quill/features/library/presentation/bloc/library_bloc.dart';
import 'package:quill/features/library/presentation/bloc/library_event.dart';
import 'package:quill/features/library/presentation/bloc/library_state.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TrendingBookCard extends StatelessWidget {
  final bool isInWishlist;
  final void Function() onTap;
  final BookEntity book;

  const TrendingBookCard({
    super.key,
    required this.book,
    required this.onTap,
    required this.isInWishlist,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: AppRadius.xl,
      onTap: onTap,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            top: 40.h,
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: theme.secondary.withValues(alpha: 0.1),
                borderRadius: AppRadius.xl,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: AppRadius.md,
                        boxShadow: AppShadows.bookCover,
                      ),
                      child: AspectRatio(
                        aspectRatio: 2 / 3,
                        child: ClipRRect(
                          borderRadius: AppRadius.md,
                          child: Image.network(
                            book.coverImage,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                buildCoverPlaceholder(context),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.md),
                Text(
                  book.title,
                  style: AppTextStyles.heading2(
                    context,
                  ).copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppSpacing.xs),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Iconsax.star1, size: 14.sp, color: AppColors.darkGold),
                    SizedBox(width: AppSpacing.xs),
                    Text(
                      '${book.ratingAverage}',
                      style: AppTextStyles.caption(
                        context,
                      ).copyWith(fontWeight: FontWeight.bold, fontSize: 12.sp),
                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: AppSpacing.sm),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => context.read<LibraryBloc>().add(
                            isInWishlist
                                ? RemoveFromWishlistEvent(bookId: book.id)
                                : AddToWishlistEvent(bookId: book.id),
                          ),
                          customBorder: CircleBorder(),
                          hoverColor: theme.secondary.withValues(alpha: 0.1),
                          splashColor: theme.secondary.withValues(alpha: 0.02),
                          child: Skeleton.ignore(
                            child: AnimatedContainer(
                              padding: EdgeInsets.all(AppSpacing.sm),
                              curve: Curves.easeInOutCubic,
                              duration: AppDuration.normal,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: theme.secondary.withValues(alpha: 0.1),
                              ),
                              child: BlocBuilder<LibraryBloc, LibraryState>(
                                builder: (context, state) {
                                  bool isLoading =
                                      state is LibraryLoading &&
                                      state.targetBookId == book.id;

                                  return AnimatedSwitcher(
                                    duration: AppDuration.slow,
                                    switchInCurve: Curves.easeInOutCubic,
                                    switchOutCurve: Curves.easeIn,
                                    child: isLoading
                                        ? LoadingAnimationWidget.flickr(
                                            key: ValueKey('Loading'),
                                            leftDotColor: theme.secondary,
                                            rightDotColor: theme.secondary
                                                .withValues(alpha: 0.5),
                                            size: 20.r,
                                          )
                                        : Icon(
                                            key: ValueKey('success'),
                                            isInWishlist
                                                ? Iconsax.heart5
                                                : Iconsax.heart,
                                            color: theme.secondary,
                                            size: 20.sp,
                                          ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
