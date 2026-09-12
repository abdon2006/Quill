import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:quill/core/router/app_router.dart';
import 'package:quill/core/theme/app_duration.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/widgets/app_button.dart';
import 'package:quill/features/home/presentation/bloc/home_bloc.dart';
import 'package:quill/features/home/presentation/bloc/home_state.dart';
import 'package:quill/features/library/presentation/bloc/library_bloc.dart';
import 'package:quill/features/library/presentation/bloc/library_event.dart';
import 'package:quill/features/library/presentation/bloc/library_state.dart';
import 'package:quill/features/reader/domain/usecases/params/reader_book_params.dart';

class BuildBottomActions extends StatefulWidget {
  final bool isInWishlist;
  final String bookId;
  const BuildBottomActions({
    super.key,
    required this.isInWishlist,
    required this.bookId,
  });

  @override
  State<BuildBottomActions> createState() => _BuildBottomActionsState();
}

class _BuildBottomActionsState extends State<BuildBottomActions> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        bool isScreenLoading = state is HomeLoading;
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: IgnorePointer(
              ignoring: isScreenLoading,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: AppButton.primary(
                      text: 'Start Reading',
                      icon: HugeIcons.strokeRoundedPlay,
                      onPressed: () => context.push(
                        AppRoutes.reader,
                        extra: ReaderBookParams(serverId: widget.bookId),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),

                  BlocBuilder<LibraryBloc, LibraryState>(
                    builder: (context, state) {
                      bool isLoadingEvent = state is LibraryLoading;
                      return Expanded(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            customBorder: CircleBorder(),
                            hoverColor: theme.secondary,
                            splashColor: theme.secondary.withValues(
                              alpha: 0.02,
                            ),
                            onTap: () {
                              if (isLoadingEvent) return;
                              context.read<LibraryBloc>().add(
                                widget.isInWishlist
                                    ? RemoveFromWishlistEvent(
                                        bookId: widget.bookId,
                                      )
                                    : AddToWishlistEvent(bookId: widget.bookId),
                              );
                            },
                            child: AnimatedContainer(
                              height: 55.w,
                              width: 55.w,
                              curve: Curves.easeInOutCubic,
                              duration: AppDuration.normal,
                              padding: EdgeInsets.all(AppSpacing.lg),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: widget.isInWishlist
                                    ? theme.secondary.withValues(alpha: 0.1)
                                    : theme.surface,
                              ),
                              child: AnimatedSwitcher(
                                duration: AppDuration.normal,
                                child: isLoadingEvent
                                    ? LoadingAnimationWidget.flickr(
                                        leftDotColor: theme.secondary,
                                        rightDotColor: theme.secondary
                                            .withValues(alpha: 0.5),
                                        size: 20.r,
                                      )
                                    : widget.isInWishlist
                                    ? HugeIcon(
                                        key: ValueKey('added'),
                                        icon: HugeIcons.strokeRoundedFavourite,
                                        color: theme.secondary,
                                      )
                                    : HugeIcon(
                                        key: ValueKey('removed'),
                                        icon: HugeIcons.strokeRoundedHeartAdd,
                                      ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
