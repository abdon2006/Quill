  import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/features/home/presentation/widgets/DetailsScreen/build_section_tile.dart';
import 'package:quill/features/home/presentation/widgets/Home/book_grid_card.dart';
import 'package:quill/features/library/presentation/widgets/staggerd_animation.dart';

Widget buildRecommendations(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: sectionTitle(
            context,
            eyebrow: 'KEEP EXPLORING',
            title: 'You might also like',
          ),
        ),

        const SizedBox(height: AppSpacing.lg),

        SizedBox(
          height: 280.h,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
            itemBuilder: (context, index) {
              final books = [
                (
                  'https://images.unsplash.com/photo-1589829085413-56de8ae18c73?q=80&w=400&auto=format&fit=crop',
                  'Atomic Habits',
                  'James Clear',
                ),
                (
                  'https://images.unsplash.com/photo-1512820790803-83ca734da794?q=80&w=400&auto=format&fit=crop',
                  'Solaris',
                  'Stanislaw Lem',
                ),
                (
                  'https://images.unsplash.com/photo-1544947950-fa07a98d237f?q=80&w=400&auto=format&fit=crop',
                  'The Alchemist',
                  'Paulo Coelho',
                ),
                (
                  'https://images.unsplash.com/photo-1495446815901-a7297e633e8d?q=80&w=400&auto=format&fit=crop',
                  'The Great Gatsby',
                  'F. Scott Fitzgerald',
                ),
              ];
              final book = books[index];

              return SizedBox(
                width: 170.w,
                child: StaggerdAnimation(
                  index: index,
                  child: BookGridCard(
                    bookCover: book.$1,
                    bookTitle: book.$2,
                    bookAuthor: book.$3,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
