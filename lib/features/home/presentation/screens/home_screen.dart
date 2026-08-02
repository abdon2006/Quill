import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/widgets/premium_background.dart';
import 'package:quill/features/home/presentation/widgets/book_grid_card.dart';
import 'package:quill/features/home/presentation/widgets/continue_reading.dart';
import 'package:quill/features/home/presentation/widgets/home_header.dart';
import 'package:quill/features/home/presentation/widgets/section_header.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  // ضيف اللستة دي جوه الـ StatelessWidget قبل الـ build أو خليها في ملف منفصل للـ Mock Data
  final List<Map<String, String>> mockBooks = [
    {
      'title': 'Dune',
      'author': 'Frank Herbert',
      'cover':
          'https://images.unsplash.com/photo-1541961017774-22349e4a1262?q=80&w=400&auto=format&fit=crop',
    },
    {
      'title': 'The Silent Patient',
      'author': 'Alex Michaelides',
      // اللينك الجديد الشغال هنا 👇
      'cover':
          'https://images.unsplash.com/photo-1543002588-bfa74002ed7e?q=80&w=400&auto=format&fit=crop',
    },
    {
      'title': 'Atomic Habits',
      'author': 'James Clear',
      'cover':
          'https://images.unsplash.com/photo-1589829085413-56de8ae18c73?q=80&w=400&auto=format&fit=crop',
    },
    {
      'title': 'Solaris',
      'author': 'Stanislaw Lem',
      'cover':
          'https://images.unsplash.com/photo-1512820790803-83ca734da794?q=80&w=400&auto=format&fit=crop',
    },
    {
      'title': '1984',
      'author': 'George Orwell',
      'cover':
          'https://images.unsplash.com/photo-1532012197267-da84d127e765?q=80&w=400&auto=format&fit=crop',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return PremiumAuroraBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: HomeHeader(),
              ),
              SizedBox(height: AppSpacing.lg),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: ContinueReading(ontap: () {}),
              ),
              SizedBox(height: AppSpacing.lg),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: SectionHeader(
                  title: 'Recently Added',
                  viewAllOnTap: () {},
                ),
              ),
              SizedBox(height: AppSpacing.lg),
              SizedBox(
                height: 230.h,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: mockBooks.length,
                  itemBuilder: (context, i) {
                    final item = mockBooks[i];
                    return BookGridCard(
                      onTap: () => context.push('/bookDeatails'),
                      bookCover: item['cover']!,
                      bookTitle: item['title']!,
                      bookAuthor: item['author']!,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
