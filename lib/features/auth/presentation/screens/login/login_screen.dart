// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quill/core/router/app_router.dart';
import 'package:quill/core/theme/app_icons.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/widgets/app_button.dart';
import 'package:quill/core/widgets/premium_background.dart';
import 'package:quill/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:quill/features/auth/presentation/bloc/auth_state.dart';
import 'package:quill/features/auth/presentation/screens/login/login_email_screen.dart';
import 'package:quill/features/auth/presentation/screens/login/login_pass_Screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController email = TextEditingController();
  final TextEditingController pass = TextEditingController();
  int currentIndex = 0;

  bool get isEnabled {
    switch (currentIndex) {
      case 0:
        return email.text.trim().isNotEmpty &&
            email.text.contains('@') &&
            email.text.endsWith('.com');
      case 1:
        bool hasMinLength = pass.text.length >= 8;
        bool hasNumOrSymbol =
            pass.text.contains(RegExp(r'[0-9]')) ||
            pass.text.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
        return hasNumOrSymbol && hasMinLength;
      default:
        return false;
    }
  }

  late final List<Widget> screens;

  @override
  void initState() {
    super.initState();
    screens = [LoginEmailScreen(email: email), LoginPassScreen(pass: pass)];
    email.addListener(() => setState(() {}));
    pass.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    email.removeListener(() {});
    pass.removeListener(() {});

    email.dispose();
    pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: PremiumAuroraBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () => currentIndex == 0
                                ? context.pop()
                                : setState(() => currentIndex--),
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 800),
                              padding: EdgeInsets.all(AppSpacing.md),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: theme.colorScheme.surface,
                              ),
                              child: HugeIcon(icon: AppIcons.back),
                            ),
                          ),
                          Expanded(
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 1200),
                              switchInCurve: Curves.easeOutCubic,
                              switchOutCurve: Curves.easeIn,
                              transitionBuilder:
                                  (Widget child, Animation<double> animation) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: SlideTransition(
                                        position: Tween<Offset>(
                                          begin: const Offset(0.3, 0.0),
                                          end: Offset.zero,
                                        ).animate(animation),
                                        child: child,
                                      ),
                                    );
                                  },
                              child: SizedBox(
                                key: ValueKey<int>(currentIndex),
                                child: screens[currentIndex],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.xxxl),
                      child: BlocConsumer<AuthBloc, AuthState>(
                        builder: (context, state) {
                          bool isLoading = state is AuthLoading;
                          return AppButton.primary(
                            isLoading: isLoading,
                            isEnabled: isEnabled,
                            text: currentIndex == 1
                                ? "Resume Your Story"
                                : "Turn the Page",
                            onPressed: () {
                              if (currentIndex < screens.length - 1) {
                                setState(() {
                                  currentIndex++;
                                });
                              } else {
                                print("Email: ${email.text}");
                                print("Pass: ${pass.text}");
                              }
                            },
                          );
                        },
                        listener: (BuildContext context, state) {
                          if (state is LoginSuccess) context.go(AppRoutes.home);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
