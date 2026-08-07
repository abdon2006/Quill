import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/theme/app_radius.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/widgets/app_text_field.dart';
import 'package:quill/features/auth/presentation/widgets/build_auth_screen.dart';
import 'package:quill/features/auth/presentation/widgets/build_rules_rows.dart';

class LoginPassScreen extends StatelessWidget {
  final TextEditingController pass;

  const LoginPassScreen({super.key, required this.pass});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    return Column(
      children: [
        buildAuthScreens(
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
              SizedBox(height: AppSpacing.md),
              AnimatedBuilder(
                animation: Listenable.merge([pass]),
                builder: (context, child) {
                  bool hasMinLength = pass.text.length >= 8;
                  bool hasNumOrSymbol =
                      pass.text.contains(RegExp(r'[0-9]')) ||
                      pass.text.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
                  bool isPristine = pass.text.isEmpty;
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
                    ],
                  );
                },
              ),
            ],
          ),
          "Unlock your Current Story.",
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: InkWell(
            borderRadius: AppRadius.xl,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                borderRadius: AppRadius.xl,
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
              ),
              child: Text(
                "Forgot Your Password ? ",
                style: TextStyle(color: theme.colorScheme.primary),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
