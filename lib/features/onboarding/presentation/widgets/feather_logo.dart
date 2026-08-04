import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FeatherLogo extends StatefulWidget {
  final bool hasStarted;
  const FeatherLogo({super.key, required this.hasStarted});

  @override
  State<FeatherLogo> createState() => _FeatherLogoState();
}

class _FeatherLogoState extends State<FeatherLogo>
    with TickerProviderStateMixin {
  late final AnimationController _moveController;
  late final Animation<double> _moveUp;
  late final Animation<double> _wiggleRotation; // حركة تمايل الريشة
  late final Animation<double> _wiggleSide; // حركة طيران الريشة يمين وشمال

  late final AnimationController _controller;
  late final Animation<Offset> _slide;
  late final Animation<double> _opacity;
  late final Animation<double> _scale;

  late final List<InkParticle> _particles;

  @override
  void initState() {
    super.initState();

    _moveController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1800,
      ), // زودنا الوقت سنة عشان الطيران يبان أروق
    );

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _opacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _scale = Tween<double>(
      begin: .8,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // حركة الطلوع لفوق
    _moveUp = Tween<double>(begin: 0, end: -120).animate(
      CurvedAnimation(parent: _moveController, curve: Curves.easeInOutCubic),
    );

    // 1. حركة تمايل الريشة (Rotation) وهي طالعة (تلف سنة يمين وسنة شمال)
    _wiggleRotation =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.08), weight: 30),
          TweenSequenceItem(tween: Tween(begin: 0.08, end: -0.05), weight: 40),
          TweenSequenceItem(tween: Tween(begin: -0.05, end: 0.0), weight: 30),
        ]).animate(
          CurvedAnimation(parent: _moveController, curve: Curves.easeInOut),
        );

    // 2. حركة انزلاق الريشة الأفقية (Horizontal Drift) كأن الهواء بيحركها
    _wiggleSide =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 0.0, end: 6.0), weight: 50),
          TweenSequenceItem(tween: Tween(begin: 6.0, end: 0.0), weight: 50),
        ]).animate(
          CurvedAnimation(parent: _moveController, curve: Curves.easeInOut),
        );

    // توليد نقط الحبر مع سرعة طيران لكل نقطة
    final rand = Random();
    _particles = List.generate(35, (index) {
      return InkParticle(
        dx: (rand.nextDouble() - 0.5) * 40,
        dy: -rand.nextDouble() * 120,
        size: rand.nextDouble() * 2.5 + 1.0,
        maxOpacity: rand.nextDouble() * 0.6 + 0.3,
        // كل نقطة بتاخد سرعة طيران أفقية عشوائية عشان النقط تتفرق وتطير
        driftSpeed: (rand.nextDouble() - 0.5) * 15,
      );
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _moveController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant FeatherLogo oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!oldWidget.hasStarted && widget.hasStarted) {
      _moveController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        // 1. غبار الحبر الطائر
        AnimatedBuilder(
          animation: _moveController,
          builder: (context, _) {
            return CustomPaint(
              size: Size(180.w, 180.w),
              painter: InkTrailPainter(
                currentY: _moveUp.value,
                progress: _moveController.value,
                particles: _particles,
              ),
            );
          },
        ),

        // 2. الريشة وهي بتطير وتتمايل
        AnimatedBuilder(
          animation: _moveController,
          builder: (context, child) {
            return Transform.translate(
              // إزاحة عمودية + إزاحة أفقية خفيفة الطيران
              offset: Offset(_wiggleSide.value, _moveUp.value),
              child: Transform.rotate(
                // دوران خفيف جداً بحسب زاوية الطيران
                angle: _wiggleRotation.value,
                child: child,
              ),
            );
          },
          child: FadeTransition(
            opacity: _opacity,
            child: SlideTransition(
              position: _slide,
              child: ScaleTransition(
                scale: _scale,
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 180.w,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class InkParticle {
  final double dx;
  final double dy;
  final double size;
  final double maxOpacity;
  final double driftSpeed; // سرعة الانزلاق الأفقي للنقطة

  InkParticle({
    required this.dx,
    required this.dy,
    required this.size,
    required this.maxOpacity,
    required this.driftSpeed,
  });
}

class InkTrailPainter extends CustomPainter {
  final double currentY;
  final double progress;
  final List<InkParticle> particles;

  InkTrailPainter({
    required this.currentY,
    required this.progress,
    required this.particles,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    for (final particle in particles) {
      if (currentY <= particle.dy) {
        final distancePassed = particle.dy - currentY;
        final fade = 1.0 - (distancePassed / 60).clamp(0.0, 1.0);

        if (fade > 0) {
          // حركة طيران النقطة أفقياً وهي بتختفي
          final driftedX = particle.dx + (particle.driftSpeed * (1.0 - fade));

          final paint = Paint()
            ..color = const Color(
              0xFFD98A6C,
            ).withValues(alpha: particle.maxOpacity * fade)
            ..style = PaintingStyle.fill;

          canvas.drawCircle(
            center + Offset(driftedX, particle.dy),
            particle.size,
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant InkTrailPainter oldDelegate) => true;
}
