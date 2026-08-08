import 'package:flutter/material.dart';
import 'package:quill/core/widgets/app_snack_bar.dart';

void showSnackBar(
  BuildContext context, {
  required String message,
  required String messageDisc,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: AppSnackBar(message: message, messageDisc: messageDisc),
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
  );
}
