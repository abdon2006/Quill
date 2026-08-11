  import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/widgets/app_button.dart';

Widget buildBottomActions(BuildContext context) {
    return Positioned(
      left: 5.w,
      right: 5.w,
      bottom: 10.h,
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: AppButton.secondary(
                text: 'Add to Library',
                icon: HugeIcons.strokeRoundedLibrary,
                onPressed: () {},
              ),
            ),

            const SizedBox(width: AppSpacing.sm),

            Expanded(
              child: AppButton.primary(
                text: 'Start Reading',
                icon: HugeIcons.strokeRoundedPlay,
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
