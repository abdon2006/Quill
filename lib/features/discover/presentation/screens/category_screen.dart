import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/router/app_router.dart';
import 'package:quill/core/states/EmptyStates/app_empty.dart';
import 'package:quill/core/theme/app_assets.dart';
import 'package:quill/core/theme/app_icons.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';
import 'package:quill/core/widgets/premium_background.dart';
import 'package:quill/features/discover/presentation/widgets/category_params.dart';
import 'package:quill/features/home/presentation/widgets/Home/book_grid_card.dart';
import 'package:quill/features/library/presentation/widgets/staggerd_animation.dart';

class CategoryScreen extends StatefulWidget {
  final CategoryParams categoryParams;
  const CategoryScreen({super.key, required this.categoryParams});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
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
              InkWell(
                customBorder: const CircleBorder(),
                onTap: () => context.pop(),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  padding: EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: HugeIcon(
                    icon: AppIcons.back,
                    size: 32.sp,
                    color: theme.secondary,
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                      ),
                      child: Text(
                        widget.categoryParams.category,
                        style: AppTextStyles.displayLarge(context),
                      ),
                    ),
                    SizedBox(height: AppSpacing.md),
                    Expanded(
                      child: widget.categoryParams.books.isEmpty
                          ? AppEmpty(
                              title:
                                  'No books in this category yet. Check back soon.',
                              image: AppAssets.noResults,
                            )
                          : GridView.builder(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm,
                              ),
                              itemCount: widget.categoryParams.books.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    mainAxisSpacing: 16.h,
                                    childAspectRatio: 0.6,
                                  ),
                              itemBuilder: (context, i) {
                                final item = widget.categoryParams.books[i];
                                return StaggerdAnimation(
                                  index: i,
                                  child: GestureDetector(
                                    onTap: () => context.push(
                                      AppRoutes.bookDeatails,
                                      extra: item,
                                    ),
                                    child: BookGridCard(book: item),
                                  ),
                                );
                              },
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
