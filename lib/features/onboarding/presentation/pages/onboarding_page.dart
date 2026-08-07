import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart'; // ضفنا الروتر
import 'package:quill/core/constants/app_constants.dart';
import 'package:quill/core/router/app_router.dart'; // مسار الروتس بتاعك
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
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.light, // أو lightTheme حسب اسم المتغير عندك
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

    // غلفنا الشاشة بـ BlocListener عشان نراقب حالة الريشة وهي بتطير
    return BlocListener<OnboardingCubit, OnboardingStage>(
      listener: (context, state) {
        if (state == OnboardingStage.leavingFeather) {
          // لما الريشة تبدأ تطير، نستنى ثانية ونص وبعدين نقلب الصفحة
          Future.delayed(const Duration(milliseconds: 1500), () {
            if (context.mounted) {
              context.go(AppRoutes.choose); // النقلة للـ Signup
            }
          });
        }
      },
      child: PremiumAuroraBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            fit: StackFit.expand,
            children: [
              AmbientGlow(active: stage == OnboardingStage.scene2),

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

              SafeArea(
                child: Column(
                  children: [
                    const Spacer(),

                    // سحب الريشة لفوق بره الشاشة لما الحالة تكون leavingFeather
                    AnimatedSlide(
                      duration: const Duration(milliseconds: 1500),
                      curve: Curves.easeInOutCubic,
                      offset: stage == OnboardingStage.leavingFeather
                          ? const Offset(0, -3.5)
                          : Offset.zero,
                      child: FeatherLogo(
                        // الريشة تبدأ طيرانها الحقيقي بس لو عدينا مرحلة الـ entering والـ initial
                        hasStarted:
                            stage != OnboardingStage.initial &&
                            stage != OnboardingStage.entering,
                        isExiting: stage == OnboardingStage.leavingFeather,
                      ),
                    ),

                    const SizedBox(height: 48),

                    // إخفاء النص
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

                    const Spacer(flex: 2),
                  ],
                ),
              ),

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

                      // الزرار النهائي
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 500),
                        // الزرار ظاهر في الـ finale بس، وبيختفي أول ما نـ endJourney
                        opacity: stage == OnboardingStage.finale ? 1.0 : 0.0,
                        child: IgnorePointer(
                          ignoring: stage != OnboardingStage.finale,
                          child: BreathingWidget(
                            child: OnboardingButton(
                              label: 'Begin The Journey',
                              onPressed: () async {
                                final prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setBool(
                                  AppConstants.seenOnboarding,
                                  true,
                                );
                                context.read<OnboardingCubit>().endJourney();
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
      ),
    );
  }

  Widget _buildText(OnboardingStage stage) {
    // لو إحنا في مرحلة إخفاء النص أو طيران الريشة، بنخفي النص تماماً
    if (stage == OnboardingStage.leavingText ||
        stage == OnboardingStage.leavingFeather) {
      return const SizedBox.shrink(key: ValueKey('empty'));
    }

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
      // بنخلي النص ظاهر في الـ finale وأثناء اختفاء الزرار
      OnboardingStage.finale || OnboardingStage.leavingButton => GoldenShimmer(
        key: const ValueKey('s4'),
        child: const StaggeredText(text: 'Welcome to Quill.'),
      ),
      _ => const SizedBox.shrink(key: ValueKey('empty')),
    };
  }
}
