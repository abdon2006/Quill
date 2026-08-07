import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/widgets/app_text_field.dart';
import 'package:quill/features/auth/presentation/widgets/build_auth_screen.dart';
import 'package:quill/features/auth/presentation/widgets/build_rules_rows.dart';

class LoginEmailScreen extends StatelessWidget {
  final TextEditingController email;

  const LoginEmailScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        buildAuthScreens(
          context,
          AppTextField(
            isPass: false,
            hintText: "email",
            prefixIcon: HugeIcons.strokeRoundedUser,
            controller: email,
            keyboardType: TextInputType.emailAddress,
            maxLines: 1,
          ),
          "Welcome back.\nRetrieve your story.",
        ),
        AnimatedBuilder(
          animation: Listenable.merge([email]),
          builder: (context, child) {
            bool isValid =
                email.text.contains('@') && email.text.endsWith('.com');
            bool isPristine = email.text.isEmpty;
            return buildRulesRow(
              'ends with .com and contains @',
              isValid,
              isDark,
              isPristine,
            );
          },
        ),
      ],
    );
  }
}
