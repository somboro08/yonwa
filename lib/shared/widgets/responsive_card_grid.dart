import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/responsive/breakpoints.dart';

class ResponsiveCardGrid extends StatelessWidget {
  final List<dynamic> items;
  final Widget Function(dynamic item, int index) cardBuilder;

  const ResponsiveCardGrid({
    super.key,
    required this.items,
    required this.cardBuilder,
  });

  int _columnCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= AppBreakpoints.desktop) return 3; // desktop: 3 colonnes
    if (width >= AppBreakpoints.tablet)  return 2; // tablet: 2 colonnes
    return 1;                                       // mobile: 1 colonne (full width)
  }

  @override
  Widget build(BuildContext context) {
    final cols = _columnCount(context);
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cols,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        mainAxisExtent: 280, // Set an explicit height for the cards
      ),
      itemCount: items.length,
      itemBuilder: (context, index) =>
        cardBuilder(items[index], index)
          .animate(delay: Duration(milliseconds: 60 * index))
          .fadeIn(duration: 350.ms, curve: Curves.easeOut)
          .slideY(begin: 0.08, end: 0, duration: 350.ms),
    );
  }
}
