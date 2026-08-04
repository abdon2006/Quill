import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/widgets/app_text_field.dart';
import 'package:quill/features/auth/presentation/widgets/build_auth_screen.dart';
import 'package:quill/features/auth/presentation/widgets/build_rules_rows.dart';

class PassScreen extends StatelessWidget {
  final TextEditingController pass;
  final TextEditingController passConfirm;

  const PassScreen({super.key, required this.pass, required this.passConfirm});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return buildAuthScreens(
      context,
      Column(
        children: [
          AppTextField(
            isPass: true,
            hintText: "password",
            prefixIcon: HugeIcons.strokeRoundedUser,
            controller: pass,
            keyboardType: TextInputType.visiblePassword,
          ),
          SizedBox(height: AppSpacing.lg),
          AppTextField(
            isPass: true,
            hintText: "confirm password",
            prefixIcon: HugeIcons.strokeRoundedUser,
            controller: passConfirm,
            keyboardType: TextInputType.visiblePassword,
          ),
          SizedBox(height: AppSpacing.md),
          AnimatedBuilder(
            animation: Listenable.merge([pass, passConfirm]),
            builder: (context, child) {
              bool hasMinLength = pass.text.length >= 8;
              bool hasNumOrSymbol =
                  pass.text.contains(RegExp(r'[0-9]')) ||
                  pass.text.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
              bool isMatching =
                  pass.text.isNotEmpty && pass.text == passConfirm.text;
              bool isPristine = pass.text.isEmpty && passConfirm.text.isEmpty;
              return Column(
                children: [
                  buildRulesRow(
                    "At least 8 characters",
                    hasMinLength,
                    isDark,
                    isPristine,
                  ),
                  buildRulesRow(
                    "Contains a number or a symbol",
                    hasNumOrSymbol,
                    isDark,
                    isPristine,
                  ),
                  buildRulesRow(
                    "Both keys match perfectly",
                    isMatching,
                    isDark,
                    isPristine,
                  ),
                ],
              );
            },
          ),
        ],
      ),
      "Keep your story safe.",
    );
  }
}
