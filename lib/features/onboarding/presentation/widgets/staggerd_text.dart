import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // ضفنا المكتبة دي عشان الـ Haptics
import 'package:quill/core/theme/app_text_style.dart';

class StaggeredText extends StatefulWidget {
  final String text;
  final Duration delay;

  const StaggeredText({
    super.key,
    required this.text,
    this.delay = Duration.zero,
  });

  @override
  State<StaggeredText> createState() => _StaggeredTextState();
}

class _StaggeredTextState extends State<StaggeredText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<Animation<double>> _wordAnimations;
  late final List<String> _words;

  @override
  void initState() {
    super.initState();
    _words = widget.text.split(' ');

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400 + (_words.length - 1) * 200),
    );

    _wordAnimations = List.generate(_words.length, (i) {
      final start = (i * 200) / _controller.duration!.inMilliseconds;
      final end = (i * 200 + 400) / _controller.duration!.inMilliseconds;
      return CurvedAnimation(
        parent: _controller,
        curve: Interval(start, end.clamp(0.0, 1.0), curve: Curves.easeOut),
      );
    });

    // فصلنا التشغيل في دالة لوحده عشان نتحكم في الـ Haptics
    _startAnimationWithHaptics();
  }

  void _startAnimationWithHaptics() async {
    await Future.delayed(widget.delay);
    if (!mounted) return;

    _controller.forward();

    // هنا الصياعة: لوب بيحسب وقت ظهور كل كلمة ويضرب نبضة خفيفة مع كل كلمة
    for (int i = 0; i < _words.length; i++) {
      Future.delayed(Duration(milliseconds: i * 200), () {
        if (mounted) {
          // selectionClick بتدي إحساس "التكة" السريعة والناعمة جداً
          HapticFeedback.selectionClick();
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      children: List.generate(_words.length, (i) {
        return AnimatedBuilder(
          animation: _wordAnimations[i],
          builder: (context, _) {
            return Opacity(
              opacity: _wordAnimations[i].value,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - _wordAnimations[i].value)),
                child: Text(
                  _words[i],
                  style: AppTextStyles.displayMedium(context),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
