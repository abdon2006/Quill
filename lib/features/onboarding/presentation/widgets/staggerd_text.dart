import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:quill/core/theme/app_duration.dart';
import 'package:quill/core/theme/app_spacing.dart';
import 'package:quill/core/theme/app_text_style.dart';

class StaggeredText extends StatefulWidget {
  final String text;
  final Duration delay;
  final TextStyle? style;
  const StaggeredText({
    super.key,
    required this.text,
    this.delay = Duration.zero,
    this.style,
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
      duration: Duration(
        milliseconds: AppDuration.switchOut.inMilliseconds +
            (_words.length - 1) * AppDuration.focus.inMilliseconds,
      ),
    );

    _wordAnimations = List.generate(_words.length, (i) {
      final start =
          (i * AppDuration.focus.inMilliseconds) /
              _controller.duration!.inMilliseconds;
      final end =
          (i * AppDuration.focus.inMilliseconds +
              AppDuration.switchOut.inMilliseconds) /
          _controller.duration!.inMilliseconds;
      return CurvedAnimation(
        parent: _controller,
        curve: Interval(start, end.clamp(0.0, 1.0), curve: Curves.easeOut),
      );
    });

    
    _startAnimationWithHaptics();
  }

  void _startAnimationWithHaptics() async {
    await Future.delayed(widget.delay);
    if (!mounted) return;

    _controller.forward();

    
    for (int i = 0; i < _words.length; i++) {
      Future.delayed(Duration(milliseconds: i * AppDuration.focus.inMilliseconds), () {
        if (mounted) {
          
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
      spacing: AppSpacing.sm,
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
                  style: widget.style ?? AppTextStyles.displayMedium(context),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
