import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:quill/core/router/app_router.dart';
import 'package:quill/core/states/EmptyStates/app_empty.dart';
import 'package:quill/core/states/ErrorStates/app_error.dart';
import 'package:quill/core/theme/app_assets.dart';
import 'package:quill/core/theme/app_duration.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_shadows.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';
import 'package:quill/core/widgets/premium_background.dart';
import 'package:quill/features/library/data/models/library_book_display_model.dart';
import 'package:quill/features/library/presentation/widgets/staggerd_animation.dart';
import 'package:quill/features/profile/presentation/widgets/back_button.dart';
import 'package:quill/features/reader/data/models/local_book.dart';
import 'package:quill/features/reader/presentation/bloc/reader_bloc.dart';
import 'package:quill/features/reader/presentation/bloc/reader_event.dart';
import 'package:quill/features/reader/presentation/bloc/reader_state.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ImportsScreen extends StatefulWidget {
  const ImportsScreen({super.key});

  @override
  State<ImportsScreen> createState() => _ImportsScreenState();
}

class _ImportsScreenState extends State<ImportsScreen> {
  List<LocalBook> books = [];
  int epub = 0;
  int pdf = 0;
  bool _hasError = false;
  @override
  void initState() {
    super.initState();
    context.read<ReaderBloc>().add(FetchLocalBooksEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return PremiumAuroraBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              backButton(context, theme),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Storage & Imports',
                      style: AppTextStyles.displayLarge(context),
                    ),
                    SizedBox(height: AppSpacing.sm),
                    BlocConsumer<ReaderBloc, ReaderState>(
                      builder: (context, state) {
                        final isLoading = state is ReaderLoading;
                        return AnimatedSwitcher(
                          duration: AppDuration.slow,
                          switchInCurve: Curves.easeInOutCubic,
                          switchOutCurve: Curves.easeIn,
                          child: isLoading
                              ? _buildLoadingState(
                                  key: ValueKey('loading'),
                                  theme: theme,
                                )
                              : _hasError
                              ? AppError(
                                  title:
                                      'Something went wrong loading your books.',
                                  image: AppAssets.errorBookDetails,
                                )
                              : books.isNotEmpty
                              ? _buildScreen(
                                  key: ValueKey('success'),
                                  context: context,
                                  theme: theme,
                                  books: books,
                                  pdf: pdf,
                                  epub: epub,
                                )
                              : AppEmpty(
                                  key: ValueKey('empty'),
                                  title: 'You Haven\'t Imported Any Book Yet ',
                                  image: AppAssets.emptyState,
                                ),
                        );
                      },
                      listener: (context, state) {
                        if (state is FetchLocalBooksSuccess) {
                          int pdfCount = 0;
                          int epubCount = 0;
                          for (var book in state.localBooks) {
                            if (book.fileType == 'pdf') pdfCount++;
                            if (book.fileType == 'epub') epubCount++;
                          }
                          setState(() {
                            books = state.localBooks;
                            pdf = pdfCount;
                            epub = epubCount;
                          });
                        }
                        if (state is ReaderFailure) {
                          setState(() => _hasError = true);
                        }
                      },
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

Widget _importsHeader({
  required BuildContext context,
  required ColorScheme theme,
  required List<LocalBook> books,
  required int pdf,
  required int epub,
}) {
  final data = ['books', 'pdf', 'epub'];

  return Row(
    children: List.generate(data.length, (i) {
      final currentCount = switch (i) {
        0 => books.length,
        1 => pdf,
        2 => epub,
        int() => throw UnimplementedError(),
      };

      return StaggerdAnimation(
        index: i * 2,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            borderRadius: AppRadius.xl,
            color: theme.secondary.withValues(alpha: 0.1),
          ),
          child: Center(
            child: Text(
              '$currentCount  ${data[i]}',
              style: AppTextStyles.bodyLarge(
                context,
              ).copyWith(color: theme.secondary),
            ),
          ),
        ),
      );
    }),
  );
}

Widget _buildScreen({
  required Key key,
  required BuildContext context,
  required ColorScheme theme,
  required List<LocalBook> books,
  required int pdf,
  required int epub,
}) => Column(
  key: key,
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    _importsHeader(
      context: context,
      theme: theme,
      books: books,
      pdf: pdf,
      epub: epub,
    ),
    SizedBox(height: AppSpacing.xl),

    Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(books.length, (i) {
        final item = books[i];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: StaggerdAnimation(
            index: i * 2,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: AppRadius.xl,
                onTap: () => context.push(
                  AppRoutes.localBookDetails,
                  extra: LibraryMapper.mapLocalToModel(item),
                ),
                child: Ink(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.lg,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: AppRadius.xl,
                    color: theme.surface,
                    boxShadow: AppShadows.card,
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            item.title,
                            style: AppTextStyles.heading2(context),
                          ),
                          Text(
                            item.importedAt
                                .toIso8601String()
                                .split('T')
                                .first
                                .replaceAll('-', '  '),
                            style: AppTextStyles.caption(context),
                          ),
                        ],
                      ),
                      Spacer(),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: AppRadius.xl,
                          color: theme.secondary.withValues(alpha: 0.1),
                        ),
                        child: Center(
                          child: Text(
                            item.fileType,
                            style: AppTextStyles.bodyLarge(
                              context,
                            ).copyWith(color: theme.secondary),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    ),
  ],
);

Widget _buildLoadingState({required Key key, required ColorScheme theme}) =>
    Skeletonizer(
      enabled: true,
      child: Column(
        key: key,
        children: [
          Row(
            children: List.generate(
              3,
              (i) => Skeleton.leaf(
                child: Container(
                  height: 30,
                  width: 50,
                  margin: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                  decoration: BoxDecoration(
                    borderRadius: AppRadius.xl,
                    color: theme.surface,
                  ),
                ),
              ),
            ),
          ),
          ...List.generate(
            3,
            (i) => Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Skeleton.leaf(
                child: Container(
                  height: 70.h,
                  decoration: BoxDecoration(
                    borderRadius: AppRadius.xl,
                    color: theme.surface,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
