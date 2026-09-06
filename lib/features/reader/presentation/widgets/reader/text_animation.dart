import 'dart:ui';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quill/core/theme/app_colors.dart';
import 'package:quill/core/theme/app_text_style.dart';
import 'package:quill/features/reader/presentation/cubit/reader_preferences_cubit.dart';
import 'package:quill/features/reader/presentation/cubit/reader_preferences_state.dart';

class TextAnimation extends StatelessWidget {
  final void Function() callBack;
  final List<String> messages;
  final int repeat;
  const TextAnimation({
    super.key,
    required this.callBack,
    required this.messages,
    this.repeat = 1,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.read<ReaderPreferencesCubit>().state;
    final isDark = state.theme == ReaderTheme.dark;
    final bgColor = AppColors.lightBgPrimary;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      child: Container(
        color: bgColor.withValues(alpha: 0.05),
        child: Center(
          child: DefaultTextStyle(
            textAlign: TextAlign.center,
            style: AppTextStyles.heading2(context).copyWith(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : state.bgColor == ReaderBgColor.dark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
            child: AnimatedTextKit(
              animatedTexts: [
                ...messages.map((m) {
                  final isLast = m == messages[messages.length - 1];
                  return FadeAnimatedText(
                    m,
                    duration: Duration(milliseconds: isLast ? 2500 : 1500),
                  );
                }),
              ],
              totalRepeatCount: repeat,
              pause: Duration(milliseconds: 300),
              onFinished: callBack,
            ),
          ),
        ),
      ),
    );
  }
}
