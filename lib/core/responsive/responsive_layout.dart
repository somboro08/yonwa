import 'package:flutter/material.dart';
import 'breakpoints.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    required this.desktop,
    this.tablet,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= AppBreakpoints.desktop) {
          return desktop;
        } else if (constraints.maxWidth >= AppBreakpoints.tablet) {
          return tablet ?? desktop;
        }
        return mobile;
      },
    );
  }
}
