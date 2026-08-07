import 'package:flutter/material.dart';
import 'package:quill/core/theme/app_colors.dart';

class AmbientGlow extends StatefulWidget {
  final bool active;
  const AmbientGlow({super.key, required this.active});

  @override
  State<AmbientGlow> createState() => _AmbientGlowState();
}

class _AmbientGlowState extends State<AmbientGlow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  final List<Color> _colors = [
    AppColors.glowJoy.withValues(alpha: 0.12),
    AppColors.glowSadness.withValues(alpha: 0.12),
    AppColors.glowMystery.withValues(alpha: 0.12),
    AppColors.glowCalm.withValues(alpha: 0.12),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void didUpdateWidget(covariant AmbientGlow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active && !oldWidget.active) {
      _controller.repeat();
    } else if (!widget.active) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final index =
            (_controller.value * _colors.length).floor() % _colors.length;
        final next = (index + 1) % _colors.length;
        final t = (_controller.value * _colors.length) - index.toDouble();

        return AnimatedContainer(
          duration: const Duration(milliseconds: 800),
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.5,
              colors: [
                Color.lerp(_colors[index], _colors[next], t)!,
                Colors.transparent,
              ],
            ),
          ),
        );
      },
    );
  }
}
