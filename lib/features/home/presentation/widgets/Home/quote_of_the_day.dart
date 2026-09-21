import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_shadows.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';

class _Quote {
  final String author;
  final String title;

  _Quote(this.title, this.author);
}

List<_Quote> _quotes = [
  _Quote(
    "A reader lives a thousand lives before he dies. The man who never reads lives only one.",
    "George R.R. Martin",
  ),
  _Quote("There is no friend as loyal as a book.", "Ernest Hemingway"),
  _Quote("A book is a dream that you hold in your hand.", "Neil Gaiman"),
  _Quote(
    "Reading is a conversation. All books talk. But a good book listens as well.",
    "Mark Haddon",
  ),
  _Quote(
    "That is part of the beauty of all literature. You discover that your longings are universal longings.",
    "F. Scott Fitzgerald",
  ),
  _Quote(
    "To learn to read is to light a fire; every syllable that is spelled out is a spark.",
    "Victor Hugo",
  ),
  _Quote(
    "Read deeply. Think clearly. Let the pages be your quiet sanctuary.",
    "Quill",
  ),
];

class QuoteOfTheDay extends StatelessWidget {
  const QuoteOfTheDay({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    final now = DateTime.now();
    final daysSinceEpoch = now.difference(DateTime(1970, 1, 1)).inDays;
    final quoteIndex = daysSinceEpoch % _quotes.length;
    final todayQuote = _quotes[quoteIndex];
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: AppRadius.xxl,
        boxShadow: AppShadows.card,
        border: Border.all(
          color: theme.onSurface.withValues(alpha: 0.05),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HugeIcon(
            icon: HugeIcons.strokeRoundedQuoteDown,
            size: 24.sp,
            color: theme.primary.withValues(alpha: 0.4),
          ),

          SizedBox(height: AppSpacing.md),

          // نص الاقتباس
          Text(
            textAlign: TextAlign.center,
            "“${todayQuote.title}”",
            style: AppTextStyles.heading2(
              context,
            ).copyWith(fontWeight: FontWeight.bold),
          ),

          SizedBox(height: AppSpacing.lg),

          // اسم الكاتب
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 24.w,
                height: 1,
                color: theme.primary.withValues(alpha: 0.3),
              ),
              SizedBox(width: AppSpacing.sm),
              Text(
                todayQuote.author,
                style: AppTextStyles.caption(context).copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: theme.primary,
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Container(
                width: 24.w,
                height: 1,
                color: theme.primary.withValues(alpha: 0.3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
