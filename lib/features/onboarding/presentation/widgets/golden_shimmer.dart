import 'package:flutter/material.dart';
import 'package:quill/core/theme/app_colors.dart';
import 'package:quill/core/theme/app_duration.dart';

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
      duration: AppDuration.ambient, 
    );

    
    Future.delayed(AppDuration.dialogPulse, () {
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
                AppColors.white.withValues(alpha: 0.0),
                AppColors.shimmerHighlight.withValues(alpha: 0.5),
                AppColors.white.withValues(alpha: 0.0),
              ],
              stops: const [0.0, 0.5, 1.0],
              
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
