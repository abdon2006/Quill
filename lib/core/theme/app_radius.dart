import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract final class AppRadius {
  static BorderRadius xs = BorderRadius.circular(8);
  static BorderRadius sm = BorderRadius.circular(10);
  static BorderRadius md = BorderRadius.circular(16);
  static BorderRadius lg = BorderRadius.circular(20);
  static BorderRadius xl = BorderRadius.circular(24);
  static BorderRadius xxl = BorderRadius.circular(32);

  
  static BorderRadius sheetSm = BorderRadius.vertical(top: Radius.circular(24.r));
  static BorderRadius sheet = BorderRadius.vertical(top: Radius.circular(28.r));
}
