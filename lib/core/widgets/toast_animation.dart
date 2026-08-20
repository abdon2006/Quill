import 'package:flutter/widgets.dart';
import 'package:quill/core/theme/app_duration.dart';

class ToastAnimation extends StatefulWidget {
  final Widget child;
  const ToastAnimation({super.key, required this.child});

  @override
  State<ToastAnimation> createState() => ToastAnimationState();
}

class ToastAnimationState extends State<ToastAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _fade;
  late final Animation<double> _scale;
  late final Animation<Offset> _slide;
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: AppDuration.normal,
    );

    final curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _fade = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    _scale = Tween<double>(begin: 0.94, end: 1).animate(curvedAnimation);

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(curvedAnimation);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> dismiss() async {
    print('dismiss called');
    await _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: ScaleTransition(scale: _scale, child: widget.child),
      ),
    );
  }
}
