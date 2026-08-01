import 'package:flutter/material.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/features/home/presentation/widgets/continue_reading.dart';
import 'package:quill/features/home/presentation/widgets/home_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: ListView(
            children: [
              HomeHeader(),
              SizedBox(height: AppSpacing.md),
              ContinueReading(ontap: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
