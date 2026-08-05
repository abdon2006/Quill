import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:quill/core/theme/app_colors.dart';
import 'package:quill/core/theme/app_text_style.dart';
import 'package:quill/features/auth/domain/entities/user_entity.dart';

class HomeHeader extends StatelessWidget {
  final UserEntity user;
  const HomeHeader({super.key, required this.user});

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
          '$greeting, ${user.name}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.displayMedium(context),
        ),

        Text(
          date,
          style: AppTextStyles.label(
            context,
          ).copyWith(color: AppColors.lightTextMuted),
        ),
      ],
    );
  }
}
