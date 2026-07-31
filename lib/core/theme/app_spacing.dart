import 'package:flutter/widgets.dart';

abstract final class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 20.0;
  static const xxl = 24.0;
  static const xxxl = 32.0;

  static const screenPadding = EdgeInsets.symmetric(
    horizontal: xl,
    vertical: lg,
  );

  static const cardPadding = EdgeInsets.all(lg);

  static const dialogPadding = EdgeInsets.all(xl);

  static const bottomSheetPadding = EdgeInsets.all(xl);
}
