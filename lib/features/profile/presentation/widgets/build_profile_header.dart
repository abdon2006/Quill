import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quill/core/theme/app_colors.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';
import 'package:quill/features/auth/domain/entities/user_entity.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BuildProfileHeader extends StatelessWidget {
  final UserEntity? user;
  const BuildProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    return Row(
      children: [
        Skeleton.leaf(
          child: CircleAvatar(
            radius: 32.r,
            backgroundColor: theme.secondary,
            child: Center(
              child: Text(
                user == null ? '' : user!.name[0].toUpperCase(),
                style: AppTextStyles.displayMedium(
                  context,
                ).copyWith(color: AppColors.darkTextPrimary),
              ),
            ),
          ),
        ),
        SizedBox(width: AppSpacing.lg),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                user == null ? 'userName' : user!.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.displayMedium(context),
              ),
              Text(
                user == null ? 'example@gmail.com' : user!.email,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.heading2(context).copyWith(
                  color: isDark
                      ? AppColors.darkTextMuted
                      : AppColors.lightTextMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
