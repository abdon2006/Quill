import 'package:flutter/material.dart';

class GoldenShimmer extends StatefulWidget {
  final Widget child;
  const GoldenShimmer({super.key, required this.child});

  @override
  State<GoldenShimmer> createState() => _GoldenShimmerState();
}

class _GoldenShimmerState extends State<GoldenShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // سرعة اللمعة (بطيئة عشان الهدوء)
    );

    // بنستنى ثانية ونص عشان ندي فرصة للنص إنه يظهر الأول بـ StaggeredText
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) _controller.repeat();
    });
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
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.0),
                const Color(
                  0xFFD98A6C,
                ).withValues(alpha: 0.5), // لون اللمعة (Terracotta/Gold)
                Colors.white.withValues(alpha: 0.0),
              ],
              stops: const [0.0, 0.5, 1.0],
              // تحريك النور من الشمال لليمين
              begin: Alignment(-2.0 + (_controller.value * 4), -0.5),
              end: Alignment(0.0 + (_controller.value * 4), 0.5),
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
