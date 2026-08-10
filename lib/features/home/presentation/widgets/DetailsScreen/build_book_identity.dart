  import 'package:flutter/material.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';
import 'package:quill/features/home/domain/entities/book_entity.dart';
import 'package:quill/features/home/presentation/widgets/DetailsScreen/book_stats_row.dart';

Widget buildBookIdentity(BuildContext context , BookEntity book ) {
    final theme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            book.title,
            style: AppTextStyles.displayMedium(context).copyWith(height: 1.08),
          ),

          const SizedBox(height: AppSpacing.sm),

          Text(
            book.author,
            style: AppTextStyles.heading2(
              context,
            ).copyWith(color: theme.primary),
          ),

          const SizedBox(height: AppSpacing.xl),

          Container(
            padding: AppSpacing.cardPadding,
            decoration: BoxDecoration(
              color: theme.surface.withValues(alpha: 0.72),
              borderRadius: AppRadius.lg,
            ),
            child: BookStatsRow(
              pages: book.totalChunks,
              lang: book.language,
              rating: book.ratingAverage,
            ),
          ),
        ],
      ),
    );
  }
