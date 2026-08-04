import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/widgets/app_text_field.dart';
import 'package:quill/features/auth/presentation/widgets/build_auth_screen.dart';

class NameScreen extends StatelessWidget {
  final TextEditingController name;
  const NameScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return buildAuthScreens(
      context,
      AppTextField(
        isPass: false,
        hintText: "Name",
        prefixIcon: HugeIcons.strokeRoundedUser,
        controller: name,
        keyboardType: TextInputType.name,
        maxLines: 1,
      ),
      "Every story has an author.\nWhat’s your name?",
    );
  }
}
