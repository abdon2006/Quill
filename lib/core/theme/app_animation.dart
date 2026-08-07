import 'package:flutter/animation.dart';

abstract final class AppAnimation {
  static const standardCurve = Curves.easeInOut;

  static const emphasizedCurve = Curves.easeOutCubic;

  static const decelerateCurve = Curves.easeOut;

  static const accelerateCurve = Curves.easeIn;

  static const bounceCurve = Curves.easeOutBack;
}
