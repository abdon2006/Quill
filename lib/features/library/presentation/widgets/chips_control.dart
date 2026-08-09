import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quill/core/theme/app_animation.dart';
import 'package:quill/core/theme/app_duration.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';

class ChipsControl extends StatefulWidget {
  final ValueChanged<int> onChanged;
  const ChipsControl({super.key, required this.onChanged});

  @override
  State<ChipsControl> createState() => _ChipsControlState();
}

class _ChipsControlState extends State<ChipsControl> {
  List chipsData = ["All", "In Progress", "Completed"];
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = constraints.maxWidth / chipsData.length;
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 50.h,
              padding: EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                borderRadius: AppRadius.xxl,
                color: theme.surface,
              ),
            ),
            AnimatedPositioned(
              width: itemWidth,
              left: selectedIndex * itemWidth,
              duration: AppDuration.normal,
              curve: AppAnimation.emphasizedCurve,
              child: Container(
                height: 50.h,
                decoration: BoxDecoration(
                  borderRadius: AppRadius.xxl,
                  color: theme.primary,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(chipsData.length, (i) {
                bool isSelected = selectedIndex == i;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = i;
                      widget.onChanged(selectedIndex);
                    });
                  },
                  child: SizedBox(
                    width: itemWidth,
                    child: Center(
                      child: AnimatedDefaultTextStyle(
                        duration: AppDuration.normal,
                        curve: AppAnimation.emphasizedCurve,
                        style: AppTextStyles.heading2(context).copyWith(
                          color: isSelected
                              ? theme.onPrimary
                              : theme.onSurface.withValues(alpha: 0.5),
                        ),
                        child: Text(chipsData[i]),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        );
      },
    );
  }
}
