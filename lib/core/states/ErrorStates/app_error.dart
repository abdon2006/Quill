import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quill/core/theme/app_text_style.dart';

class AppError extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String image;
  final Color? textColor;
  const AppError({
    super.key,
    required this.title,
    required this.image,
    this.textColor,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(image),
        Text(
          title,
          style: AppTextStyles.displayMedium(context).copyWith(
            color: textColor ?? Theme.of(context).colorScheme.secondary,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          subtitle ?? '',
          style: AppTextStyles.caption(context).copyWith(
            color:
                textColor ??
                Theme.of(context).colorScheme.secondary.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }
}
