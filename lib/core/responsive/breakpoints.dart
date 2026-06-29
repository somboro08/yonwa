import 'package:flutter/material.dart';

class AppBreakpoints {
  static const double mobile  = 0;
  static const double tablet  = 768;
  static const double desktop = 1024;
  static const double wide    = 1440;
}

extension ContextBreakpoints on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;

  bool get isMobile  => screenWidth < AppBreakpoints.tablet;
  bool get isTablet  => screenWidth >= AppBreakpoints.tablet && screenWidth < AppBreakpoints.desktop;
  bool get isDesktop => screenWidth >= AppBreakpoints.desktop;
}
