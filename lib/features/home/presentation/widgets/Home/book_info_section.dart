import 'package:flutter/widgets.dart';
import 'package:quill/core/theme/app_colors.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';

class BookInfoSection extends StatelessWidget {
  final String label;
  final String content;

  const BookInfoSection({
    super.key,
    required this.label,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.heading2(context)),
        const SizedBox(height: AppSpacing.sm),
        Text(
          content,
          style: AppTextStyles.bodyLarge(
            context,
          ).copyWith(color: AppColors.lightTextMuted),
        ),
      ],
    );
  }
}
