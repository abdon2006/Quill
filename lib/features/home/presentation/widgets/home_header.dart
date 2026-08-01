import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:quill/core/theme/app_colors.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';

class HomeHeader extends StatelessWidget {
  final String userName;
  const HomeHeader({super.key, this.userName = 'Abdallah'});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    final greeting = _getGreeting();
    final date = DateFormat(
      'EEEE, MMMM d',
    ).format(DateTime.now()).toUpperCase();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$greeting, $userName',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.bodyLarge(
            context,
          ).copyWith(fontSize: AppSpacing.xl, fontWeight: FontWeight.bold),
        ),

        Text(
          date,
          style: AppTextStyles.label(context).copyWith(
            color: AppColors.lightTextMuted,
            letterSpacing: 1.2, // بيدي شكل Premium ومريح
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
