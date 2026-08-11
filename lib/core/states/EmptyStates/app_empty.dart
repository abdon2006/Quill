import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quill/core/theme/app_text_style.dart';

class AppEmpty extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String image;
  const AppEmpty({
    super.key,
    required this.title,
    required this.image,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(image),
        Text(title, style: AppTextStyles.displayMedium(context)),
        Text(subtitle ?? '', style: AppTextStyles.caption(context)),
      ],
    );
  }
}
