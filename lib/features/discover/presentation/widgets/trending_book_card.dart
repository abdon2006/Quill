import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:quill/core/theme/app_colors.dart';
import 'package:quill/core/theme/app_duration.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';
import 'package:quill/features/home/domain/entities/book_entity.dart';
import 'package:quill/features/library/presentation/bloc/library_bloc.dart';
import 'package:quill/features/library/presentation/bloc/library_event.dart';
import 'package:quill/features/library/presentation/bloc/library_state.dart';

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
      child: Ink(
        child: Container(
          width: 200.w,
          decoration: BoxDecoration(borderRadius: AppRadius.xl),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                top: 60.h,
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: theme.secondary.withValues(alpha: 0.1),
                    borderRadius: AppRadius.xl,
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 15.w,
                right: 15.w,
                bottom: 0.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        height: 250.h,
                        decoration: BoxDecoration(borderRadius: AppRadius.md),
                        child: ClipRRect(
                          borderRadius: AppRadius.md,
                          child: Image.network(
                            book.coverImage,
                            fit: BoxFit.fitHeight,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  color: theme.onSurface.withValues(alpha: 0.1),
                                  child: const Center(child: Icon(Icons.book)),
                                ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            book.title,
                            style: AppTextStyles.heading1(context),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Iconsax.star1,
                                size: 14.sp,
                                color: AppColors.darkGold,
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              Text(
                                '${book.ratingAverage}',
                                style: AppTextStyles.caption(context).copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),

                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: EdgeInsetsGeometry.only(
                                    bottom: AppSpacing.sm,
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () =>
                                          context.read<LibraryBloc>().add(
                                            isInWishlist
                                                ? RemoveFromWishlistEvent(
                                                    bookId: book.id,
                                                  )
                                                : AddToWishlistEvent(
                                                    bookId: book.id,
                                                  ),
                                          ),
                                      customBorder: CircleBorder(),
                                      hoverColor: theme.secondary,
                                      splashColor: theme.secondary.withValues(
                                        alpha: 0.02,
                                      ),
                                      child: AnimatedContainer(
                                        height: 40.w,
                                        width: 40.w,
                                        curve: Curves.easeInOutCubic,
                                        duration: AppDuration.normal,
                                        padding: EdgeInsets.all(AppSpacing.sm),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: theme.secondary.withValues(
                                            alpha: 0.1,
                                          ),
                                        ),
                                        child: BlocBuilder<LibraryBloc, LibraryState>(
                                          builder: (context, state) {
                                            bool isLoading =
                                                state is LibraryLoading &&
                                                state.targetBookId == book.id;

                                            return AnimatedSwitcher(
                                              duration: AppDuration.slow,
                                              switchInCurve:
                                                  Curves.easeInOutCubic,
                                              switchOutCurve: Curves.easeIn,

                                              /// في مشكل هنا اني لما بدوس علي اي حاجة سواء اضافة او ازالة من المكتبة كل الكتب بتحمل
                                              child: isLoading
                                                  ? LoadingAnimationWidget.flickr(
                                                      key: ValueKey('Loading'),
                                                      leftDotColor:
                                                          theme.secondary,
                                                      rightDotColor: theme
                                                          .secondary
                                                          .withValues(
                                                            alpha: 0.5,
                                                          ),
                                                      size: 20.r,
                                                    )
                                                  : Icon(
                                                      key: ValueKey('success'),
                                                      isInWishlist
                                                          ? Iconsax.heart5
                                                          : Iconsax.heart,
                                                      color: theme.secondary,
                                                    ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
