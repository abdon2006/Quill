import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FeatherLogo extends StatefulWidget {
  final bool hasStarted;
  final bool isExiting;
  const FeatherLogo({
    super.key,
    required this.hasStarted,
    this.isExiting = false,
  });

  @override
  State<FeatherLogo> createState() => _FeatherLogoState();
}

class _FeatherLogoState extends State<FeatherLogo>
    with TickerProviderStateMixin {
  // --- أنيميشن الدخول (الأساسي) ---
  late final AnimationController _moveController;
  late final Animation<double> _moveUp;
  late final Animation<double> _wiggleRotation;
  late final Animation<double> _wiggleSide;
  late final List<InkParticle> _particles;

  // --- أنيميشن الخروج (النقلة السينمائية) ---
  late final AnimationController _exitController;
  late final Animation<double> _exitMoveUp;
  late final Animation<double> _exitWiggleRotation;
  late final Animation<double> _exitWiggleSide;
  late final List<InkParticle> _exitParticles;

  // --- أنيميشن الظهور (Fade In) ---
  late final AnimationController _controller;
  late final Animation<Offset> _slide;
  late final Animation<double> _opacity;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    // 1. إعدادات الدخول
    _moveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _moveUp = Tween<double>(begin: 0, end: -120).animate(
      CurvedAnimation(parent: _moveController, curve: Curves.easeInOutCubic),
    );
    _wiggleRotation =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.08), weight: 30),
          TweenSequenceItem(tween: Tween(begin: 0.08, end: -0.05), weight: 40),
          TweenSequenceItem(tween: Tween(begin: -0.05, end: 0.0), weight: 30),
        ]).animate(
          CurvedAnimation(parent: _moveController, curve: Curves.easeInOut),
        );
    _wiggleSide =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 0.0, end: 6.0), weight: 50),
          TweenSequenceItem(tween: Tween(begin: 6.0, end: 0.0), weight: 50),
        ]).animate(
          CurvedAnimation(parent: _moveController, curve: Curves.easeInOut),
        );

    final rand = Random();
    _particles = List.generate(35, (index) {
      return InkParticle(
        dx: (rand.nextDouble() - 0.5) * 40,
        dy: -rand.nextDouble() * 120,
        size: rand.nextDouble() * 2.5 + 1.0,
        maxOpacity: rand.nextDouble() * 0.6 + 0.3,
        driftSpeed: (rand.nextDouble() - 0.5) * 15,
      );
    });

    // 2. إعدادات الخروج (بتكمل من مكان ما الدخول وقف)
    _exitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    // بتطير مسافة -400 عشان تخرج بره الشاشة بنعومة
    _exitMoveUp = Tween<double>(
      begin: 0,
      end: -400,
    ).animate(CurvedAnimation(parent: _exitController, curve: Curves.easeIn));
    _exitWiggleRotation =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.08), weight: 30),
          TweenSequenceItem(tween: Tween(begin: 0.08, end: -0.05), weight: 40),
          TweenSequenceItem(tween: Tween(begin: -0.05, end: 0.0), weight: 30),
        ]).animate(
          CurvedAnimation(parent: _exitController, curve: Curves.easeInOut),
        );
    _exitWiggleSide =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 0.0, end: 6.0), weight: 50),
          TweenSequenceItem(tween: Tween(begin: 6.0, end: 0.0), weight: 50),
        ]).animate(
          CurvedAnimation(parent: _exitController, curve: Curves.easeInOut),
        );

    // نقط حبر جديدة بتترسم في مسار الخروج (من -120 لحد -400)
    _exitParticles = List.generate(40, (index) {
      return InkParticle(
        dx: (rand.nextDouble() - 0.5) * 40,
        dy: -120 - (rand.nextDouble() * 280), // تبدأ من مكان وقوف الريشة وتطلع
        size: rand.nextDouble() * 2.5 + 1.0,
        maxOpacity: rand.nextDouble() * 0.6 + 0.3,
        driftSpeed: (rand.nextDouble() - 0.5) * 15,
      );
    });

    // 3. إعدادات الظهور الأولي
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

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _moveController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant FeatherLogo oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!oldWidget.hasStarted && widget.hasStarted) {
      _moveController.forward();
    }

    // أول ما الـ Cubit يدي أمر الخروج، نشغل أنيميشن الطيران التاني
    if (!oldWidget.isExiting && widget.isExiting) {
      _exitController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        // الحبر
        AnimatedBuilder(
          // بنراقب الحركتين مع بعض (الدخول والخروج)
          animation: Listenable.merge([_moveController, _exitController]),
          builder: (context, _) {
            // بنجمع الإزاحة بتاعت الدخول + إزاحة الخروج
            final totalY = _moveUp.value + _exitMoveUp.value;
            // بنجمع الحبر القديم والجديد عشان يبان كأنه مسار واحد متصل
            final allParticles = [..._particles, ..._exitParticles];

            return CustomPaint(
              size: Size(180.w, 180.w),
              painter: InkTrailPainter(
                currentY: totalY,
                particles: allParticles,
              ),
            );
          },
        ),

        // الريشة
        AnimatedBuilder(
          animation: Listenable.merge([_moveController, _exitController]),
          builder: (context, child) {
            final totalY = _moveUp.value + _exitMoveUp.value;
            final totalSide = _wiggleSide.value + _exitWiggleSide.value;
            final totalRotation =
                _wiggleRotation.value + _exitWiggleRotation.value;

            return Transform.translate(
              offset: Offset(totalSide, totalY),
              child: Transform.rotate(angle: totalRotation, child: child),
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
  final double driftSpeed;

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
  final List<InkParticle> particles;

  InkTrailPainter({required this.currentY, required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    for (final particle in particles) {
      if (currentY <= particle.dy) {
        final distancePassed = particle.dy - currentY;
        final fade = 1.0 - (distancePassed / 60).clamp(0.0, 1.0);

        if (fade > 0) {
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
