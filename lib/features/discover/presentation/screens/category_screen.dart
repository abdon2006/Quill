import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/router/app_router.dart';
import 'package:quill/core/theme/app_icons.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';
import 'package:quill/core/widgets/premium_background.dart';
import 'package:quill/features/discover/presentation/widgets/category_params.dart';
import 'package:quill/features/home/presentation/widgets/Home/book_grid_card.dart';

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
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => context.pop(),
                  child: Container(
                    width: 42.w,
                    height: 42.w,
                    margin: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child: Center(
                      child: HugeIcon(
                        icon: AppIcons.back,
                        size: 32.sp,
                        color: theme.secondary,
                      ),
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
                      SizedBox(height: AppSpacing.xs),

                      Expanded(
                        child: GridView.builder(
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
                            return GestureDetector(
                              onTap: () => context.push(
                                AppRoutes.bookDeatails,
                                extra: item,
                              ),
                              child: BookGridCard(book: item),
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
      ),
    );
  }
}
