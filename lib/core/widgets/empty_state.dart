import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quill/core/theme/app_assets.dart';
import 'package:quill/core/theme/app_text_style.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(AppAssets.emptyState),
        Text(
          "Bring a book into your quiet space.",
          style: AppTextStyles.displayMedium(context),
        ),
      ],
    );
  }
}
