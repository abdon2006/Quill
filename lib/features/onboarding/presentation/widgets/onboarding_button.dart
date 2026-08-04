import 'package:flutter/material.dart';
import 'package:quill/core/widgets/app_button.dart';

class OnboardingButton extends StatelessWidget {
  final String label;
  final void Function() onPressed;
  const OnboardingButton({
    super.key,
    required this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton.primary(text: label, onPressed: onPressed);
  }
}
