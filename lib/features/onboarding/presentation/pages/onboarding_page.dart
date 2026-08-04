import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quill/core/theme/app_theme.dart';
import 'package:quill/core/widgets/premium_background.dart';
import 'package:quill/features/onboarding/cubit/onboarding_cubit.dart';
import 'package:quill/features/onboarding/presentation/widgets/ai_hint.dart';
import 'package:quill/features/onboarding/presentation/widgets/ambient_glow.dart';
import 'package:quill/features/onboarding/presentation/widgets/breathing_widget.dart';
import 'package:quill/features/onboarding/presentation/widgets/feather_logo.dart';
import 'package:quill/features/onboarding/presentation/widgets/golden_shimmer.dart';
import 'package:quill/features/onboarding/presentation/widgets/onboarding_button.dart';
import 'package:quill/features/onboarding/presentation/widgets/staggerd_text.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      // السحر هنا: استخدم الثيم الفاتح الأساسي بتاع تطبيقك إنت
      // (غير كلمة AppTheme.lightTheme لاسم المتغير اللي إنت عامله عندك في المشروع)
      data: AppTheme.light,
      child: BlocProvider(
        create: (_) => OnboardingCubit(),
        child: const _OnboardingView(),
      ),
    );
  }
}

class _OnboardingView extends StatefulWidget {
  const _OnboardingView();

  @override
  State<_OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<_OnboardingView> {
  @override
  Widget build(BuildContext context) {
    final stage = context.watch<OnboardingCubit>().state;

    return PremiumAuroraBackground(
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            // 1. طبقة الإضاءة الخلفية (Ambient Glow)
            AmbientGlow(active: stage == OnboardingStage.scene2),

            // 2. طبقة الـ AI Hints (حطيناها في الخلفية عشان متزقش أي عنصر تاني)
            // عملناها Center عشان تظهر ورا النص الأساسي بالظبط كأنها عمق ميدان
            Center(
              child: IgnorePointer(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeInOut,
                  opacity: stage == OnboardingStage.scene3 ? 1.0 : 0.0,
                  child: AIHints(active: stage == OnboardingStage.scene3),
                ),
              ),
            ),

            // 3. طبقة المحتوى الأساسي (الريشة والنصوص)
            SafeArea(
              child: Column(
                children: [
                  const Spacer(),

                  // الريشة
                  FeatherLogo(hasStarted: stage != OnboardingStage.initial),

                  const SizedBox(height: 48),

                  // النصوص الأساسية
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 700),
                    transitionBuilder: (child, animation) => FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.1),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    ),
                    child: _buildText(stage),
                  ),

                  // شيلنا الـ AIHints من هنا، فالمساحة هتفضل ثابتة دايماً!
                  const Spacer(flex: 2),
                ],
              ),
            ),

            // 4. طبقة الزراير
            Positioned(
              bottom: 48,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 500),
                      opacity: stage == OnboardingStage.initial ? 1.0 : 0.0,
                      child: IgnorePointer(
                        ignoring: stage != OnboardingStage.initial,
                        child: OnboardingButton(
                          label: 'Turn the First Page',
                          onPressed: () =>
                              context.read<OnboardingCubit>().startJourney(),
                        ),
                      ),
                    ),

                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 800),
                      opacity: stage == OnboardingStage.finale ? 1.0 : 0.0,
                      child: IgnorePointer(
                        ignoring: stage != OnboardingStage.finale,
                        child: BreathingWidget(
                          child: OnboardingButton(
                            label: 'Begin The Journy',
                            onPressed: () {
                              // Navigation to Signup
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildText(OnboardingStage stage) {
    return switch (stage) {
      OnboardingStage.scene1 => StaggeredText(
        key: const ValueKey('s1'),
        text: 'Read without distraction.',
      ),
      OnboardingStage.scene2 => StaggeredText(
        key: const ValueKey('s2'),
        text: 'Feel every emotion.',
      ),
      OnboardingStage.scene3 => StaggeredText(
        key: const ValueKey('s3'),
        text: 'Every page has someone to ask.',
      ),
      OnboardingStage.finale => GoldenShimmer(
        key: const ValueKey('s4'),
        child: const StaggeredText(text: 'Welcome to Quill.'),
      ),
      _ => const SizedBox.shrink(key: ValueKey('empty')),
    };
  }
}
