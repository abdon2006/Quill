import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quill/core/router/app_router.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/widgets/app_button.dart';
import 'package:quill/core/widgets/premium_background.dart';
import 'package:quill/features/onboarding/presentation/widgets/staggerd_text.dart';

class AuthChooseScreen extends StatefulWidget {
  const AuthChooseScreen({super.key});

  @override
  State<AuthChooseScreen> createState() => _AuthChooseScreenState();
}

class _AuthChooseScreenState extends State<AuthChooseScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  // أنيميشن الزرار الأول (Sign Up)
  late final Animation<Offset> _slideButton1;
  late final Animation<double> _fadeButton1;

  // أنيميشن الزرار التاني (Log In)
  late final Animation<Offset> _slideButton2;
  late final Animation<double> _fadeButton2;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000), // وقت دخول الزرارين مع بعض
    );

    // الزرار الأول بيبدأ من الصفر لـ 60% من وقت الأنيميشن
    _fadeButton1 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    _slideButton1 = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
          ),
        );

    // الصياعة هنا: الزرار التاني بيبدأ متأخر شوية (من 40% لـ 100%) عشان يدي شكل الـ Staggered
    _fadeButton2 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );
    _slideButton2 = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.4, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    // بنستنى 800 ملي ثانية عشان ندي فرصة للـ StaggeredText يظهر الأول، وبعدين نشغل الزراير
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PremiumAuroraBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            child: Column(
              children: [
                Spacer(),

                StaggeredText(text: 'Your Story Begins Here.'),

                Spacer(),
                FadeTransition(
                  opacity: _fadeButton1,
                  child: SlideTransition(
                    position: _slideButton1,
                    child: AppButton.primary(
                      // أو الزرار اللي إنت حاطه
                      text: 'Sign Up',
                      onPressed: () {
                        context.push(AppRoutes.signup);
                      },
                    ),
                  ),
                ),
                FadeTransition(
                  opacity: _fadeButton2,
                  child: SlideTransition(
                    position: _slideButton2,
                    child: TextButton(
                      // أو الزرار اللي إنت حاطه
                      onPressed: () {
                        context.push(AppRoutes.login);
                      },
                      child: const Text('Log In'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
