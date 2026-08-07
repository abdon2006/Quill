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
import 'package:quill/features/auth/domain/auth_params.dart';
import 'package:quill/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:quill/features/auth/presentation/bloc/auth_event.dart';
import 'package:quill/features/auth/presentation/bloc/auth_state.dart';
import 'package:quill/features/auth/presentation/screens/signup/email_screen.dart';
import 'package:quill/features/auth/presentation/screens/signup/name_screen.dart';
import 'package:quill/features/auth/presentation/screens/signup/pass_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController pass = TextEditingController();
  final TextEditingController passConfirm = TextEditingController();
  int currentIndex = 0;
  PageController controller = PageController();

  bool get isEnabled {
    switch (currentIndex) {
      case 0:
        return name.text.trim().isNotEmpty;
      case 1:
        return email.text.trim().isNotEmpty &&
            email.text.contains('@') &&
            email.text.endsWith('.com');
      case 2:
        bool hasMinLength = pass.text.length >= 8;
        bool hasNumOrSymbol =
            pass.text.contains(RegExp(r'[0-9]')) ||
            pass.text.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
        bool isMatching = pass.text.isNotEmpty && pass.text == passConfirm.text;
        return hasNumOrSymbol && hasMinLength && isMatching;
      default:
        return false;
    }
  }

  late final List<Widget> screens;

  @override
  void initState() {
    super.initState();
    screens = [
      NameScreen(name: name),
      EmailScreen(email: email),
      PassScreen(pass: pass, passConfirm: passConfirm),
    ];
    name.addListener(() => setState(() {}));
    email.addListener(() => setState(() {}));
    pass.addListener(() => setState(() {}));
    passConfirm.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    name.removeListener(() {});
    email.removeListener(() {});
    pass.removeListener(() {});
    passConfirm.removeListener(() {});

    name.dispose();
    email.dispose();
    pass.dispose();
    passConfirm.dispose();
    controller.dispose();
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
                            onTap: () {
                              currentIndex == 0
                                  ? context.pop()
                                  : setState(() {
                                      currentIndex--;
                                    });
                            },
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
                    BlocConsumer<AuthBloc, AuthState>(
                      builder: (context, state) {
                        bool isLoading = state is AuthLoading;
                        if (state is AuthError) {
                          print(
                            '====================== ${state.message} =======================',
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.only(
                            bottom: AppSpacing.xxxl,
                          ),
                          child: AppButton.primary(
                            isLoading: isLoading,
                            isEnabled: isEnabled,
                            text: currentIndex == screens.length - 1
                                ? "Begin Your Story"
                                : "Turn the Page",
                            onPressed: () {
                              if (currentIndex < screens.length - 1) {
                                setState(() {
                                  currentIndex++;
                                });
                              } else {
                                context.read<AuthBloc>().add(
                                  SignUpEvent(
                                    params: SignupParams(
                                      name: name.text,
                                      email: email.text,
                                      password: pass.text,
                                      passwordConfirm: passConfirm.text,
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        );
                      },
                      listener: (context, state) {
                        if (state is SignupSuccess) context.go(AppRoutes.home);
                        if (state is AuthError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)),
                          );
                        }
                      },
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
