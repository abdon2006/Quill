import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:quill/core/theme/app_colors.dart';
import 'package:quill/core/theme/app_text_style.dart';

class AIHints extends StatelessWidget {
  final bool active;
  const AIHints({super.key, required this.active});

  @override
  Widget build(BuildContext context) {
    // لو مش في المشهد التالت، بنخفي المساحة دي خالص

    return SizedBox(
      height: 180, // مساحة كافية عشان الأفكار تتنطور فيها براحتها
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: const [
          // توزيع الأفكار في أماكن عشوائية في الشاشة (بتنطور)
          Positioned(
            top: 0,
            left: 20,
            child: _FloatingBlurredHint(text: 'Explain this...', delay: 0),
          ),
          Positioned(
            top: 50,
            right: 20,
            child: _FloatingBlurredHint(
              text: 'Who is...',
              delay: 800, // بتظهر بعدها بشوية
            ),
          ),
          Positioned(
            bottom: 20,
            left: 40,
            child: _FloatingBlurredHint(text: 'Summarize...', delay: 1600),
          ),
          Positioned(
            bottom: -20,
            right: 50,
            child: _FloatingBlurredHint(
              text: 'What does this mean?',
              delay: 2400,
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingBlurredHint extends StatefulWidget {
  final String text;
  final int delay;

  const _FloatingBlurredHint({required this.text, required this.delay});

  @override
  State<_FloatingBlurredHint> createState() => _FloatingBlurredHintState();
}

class _FloatingBlurredHintState extends State<_FloatingBlurredHint>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _position;

  @override
  void initState() {
    super.initState();
    // الكلمة بتاخد 4 ثواني تظهر، تعوم لفوق، وتختفي
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    // Fade in -> hold -> Fade out
    _opacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 30),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // حركة طفو بطيئة جداً من تحت لفوق كأن الفكرة بتطير
    _position = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: const Offset(0, -0.4),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _startAnimation();
  }

  void _startAnimation() async {
    await Future.delayed(Duration(milliseconds: widget.delay));
    if (mounted) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _position,
        // الصياعة كلها هنا: ImageFiltered بتعمل Blur حقيقي للعنصر كأنه برة الفوكس
        child: ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
          child: Text(
            widget.text,
            style: AppTextStyles.heading1(context).copyWith(
              // الخط كبير بس شفافيته مدياله إحساس إنه ورا النص الأساسي
              color: AppColors.lightTextMuted.withValues(alpha: 0.5),
              fontStyle: FontStyle.italic,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}
