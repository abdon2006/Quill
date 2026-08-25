import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';
import 'package:quill/core/widgets/app_button.dart';
import 'package:quill/features/library/data/models/library_book_display_model.dart';
import 'package:quill/features/reader/presentation/bloc/reader_bloc.dart';
import 'package:quill/features/reader/presentation/bloc/reader_event.dart';

Widget buildDeleteSection(BuildContext context, LibraryBookDisplayModel book) {
  final theme = Theme.of(context).colorScheme;

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
    child: GestureDetector(
      onTap: () => _showDeleteConfirmation(context, book),
      child: Container(
        padding: AppSpacing.cardPadding,
        decoration: BoxDecoration(
          color: theme.error.withValues(alpha: 0.06),
          borderRadius: AppRadius.lg,
          border: Border.all(color: theme.error.withValues(alpha: 0.12)),
        ),
        child: Row(
          children: [
            HugeIcon(
              icon: HugeIcons.strokeRoundedDelete02,
              color: theme.error,
              size: 20.sp,
            ),
            const SizedBox(width: AppSpacing.md),
            Text(
              'Remove this book',
              style: AppTextStyles.bodyMedium(
                context,
              ).copyWith(color: theme.error),
            ),
          ],
        ),
      ),
    ),
  );
}

void _showDeleteConfirmation(
  BuildContext context,
  LibraryBookDisplayModel book,
) {
  final theme = Theme.of(context).colorScheme;

  showModalBottomSheet(
    context: context,
    backgroundColor: theme.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
    ),
    builder: (context) => Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.xxl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: theme.onSurface.withValues(alpha: 0.15),
              borderRadius: AppRadius.lg,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Text(
            'Gone for good?',
            style: AppTextStyles.displayMedium(
              context,
            ).copyWith(letterSpacing: 0),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Once removed, it\'s gone from your device. No way back.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium(context).copyWith(
              color: theme.onSurface.withValues(alpha: 0.55),
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          AppButton.primary(
            text: 'Remove it',
            onPressed: () {
              context.read<ReaderBloc>().add(
                RemoveBookEvent(bookId: book.localId!),
              );
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Keep it',
              style: AppTextStyles.bodyMedium(
                context,
              ).copyWith(color: theme.onSurface.withValues(alpha: 0.45)),
            ),
          ),
        ],
      ),
    ),
  );
}
