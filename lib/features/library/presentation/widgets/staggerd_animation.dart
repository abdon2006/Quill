import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quill/core/theme/app_duration.dart';

class StaggerdAnimation extends StatefulWidget {
  final Widget child;
  final int index;

  const StaggerdAnimation({super.key, required this.child, required this.index});

  @override
  State<StaggerdAnimation> createState() => _AnimatedBookCardState();
}

class _AnimatedBookCardState extends State<StaggerdAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _fade;
  late final Animation<double> _scale;
  late final Animation<Offset> _slide;

  Timer? _timer;

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

    _startAnimation();
  }

  void _startAnimation() {
    _timer = Timer(Duration(milliseconds: widget.index * 100), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
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
