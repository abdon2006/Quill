import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class PremiumAuroraBackground extends StatefulWidget {
  final Widget child;

  const PremiumAuroraBackground({super.key, required this.child});

  @override
  State<PremiumAuroraBackground> createState() =>
      _PremiumAuroraBackgroundState();
}

class _PremiumAuroraBackgroundState extends State<PremiumAuroraBackground> {
  // Alignments for the moving orbs
  Alignment _alignment1 = Alignment.topLeft;
  Alignment _alignment2 = Alignment.bottomRight;
  Alignment _alignment3 = Alignment.centerLeft;

  late Timer _timer;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    // Change positions every 3 seconds to create a slow, breathing movement
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      setState(() {
        _alignment1 = _getRandomAlignment();
        _alignment2 = _getRandomAlignment();
        _alignment3 = _getRandomAlignment();
      });
    });
  }

  Alignment _getRandomAlignment() {
    return Alignment(
      _random.nextDouble() * 2 - 1,
      _random.nextDouble() * 2 - 1,
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        // ─── Background Color ───
        Container(color: theme.scaffoldBackgroundColor),

        // ─── Animated Orb 1 (Primary Color) ───
        AnimatedAlign(
          duration: const Duration(seconds: 5),
          curve: Curves.easeInOutSine, // Smooth natural movement
          alignment: _alignment1,
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.primary.withValues(alpha: 0.15),
            ),
          ),
        ),

        // ─── Animated Orb 2 (Accent/Secondary Color) ───
        AnimatedAlign(
          duration: const Duration(seconds: 7),
          curve: Curves.easeInOutSine,
          alignment: _alignment2,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // You can use another color here to make it mix nicely
              color: theme.colorScheme.secondary.withValues(alpha: 0.15),
            ),
          ),
        ),

        // ─── Animated Orb 3 (Optional extra pop) ───
        AnimatedAlign(
          duration: const Duration(seconds: 6),
          curve: Curves.easeInOutSine,
          alignment: _alignment3,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.2),
            ),
          ),
        ),

        // ─── The Magic Blur Layer ───
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80), // Extreme blur
          child: Container(color: Colors.transparent),
        ),

        // ─── The Actual Screen Content ───
        widget.child,
      ],
    );
  }
}
