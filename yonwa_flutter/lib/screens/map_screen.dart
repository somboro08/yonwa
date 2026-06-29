import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';

class MapScreen extends StatefulWidget {
  final VoidCallback onBack;
  final Function(String) navigate;
  const MapScreen({super.key, required this.onBack, required this.navigate});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  int? _selected;

  final _pins = const [
    _Pin(id: 1, x: 0.46, y: 0.32, label: 'Kokou Agbéko', type: 'artisan'),
    _Pin(id: 2, x: 0.28, y: 0.44, label: 'Akosua Mensah', type: 'artisan'),
    _Pin(id: 3, x: 0.62, y: 0.56, label: 'Prosper H.', type: 'guide'),
    _Pin(id: 4, x: 0.41, y: 0.64, label: 'Palais Royaux', type: 'site'),
    _Pin(id: 5, x: 0.20, y: 0.74, label: 'Marché Dantokpa', type: 'site'),
    _Pin(id: 6, x: 0.74, y: 0.36, label: 'Céleste A.', type: 'guide'),
  ];

  Color _pinColor(String type) {
    switch (type) {
      case 'artisan': return AppColors.primary;
      case 'guide': return AppColors.secondary;
      default: return AppColors.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map background
          Container(
            color: const Color(0xFFE8D9C5),
            child: CustomPaint(
              painter: _MapPainter(),
              size: MediaQuery.of(context).size,
            ),
          ),

          // Pins
          ...(_pins.map((pin) {
            final color = _pinColor(pin.type);
            final active = _selected == pin.id;
            return Positioned(
              left: pin.x * MediaQuery.of(context).size.width - (active ? 12 : 9),
              top: pin.y * MediaQuery.of(context).size.height - (active ? 12 : 9),
              child: GestureDetector(
                onTap: () => setState(() => _selected = _selected == pin.id ? null : pin.id),
                child: Container(
                  width: active ? 24 : 18,
                  height: active ? 24 : 18,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: color.withOpacity(0.4), blurRadius: 8, spreadRadius: 2)],
                  ),
                  child: Center(
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    ),
                  ),
                ),
              ),
            );
          })),

          // Top controls
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 16,
            right: 16,
            child: Row(
              children: [
                GestureDetector(
                  onTap: widget.onBack,
                  child: Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)]),
                    child: const Icon(Icons.chevron_left, color: AppColors.textDark),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10)]),
                    child: const Row(
                      children: [
                        Icon(Icons.search, color: AppColors.textMuted, size: 16),
                        SizedBox(width: 8),
                        Text('Cotonou, Bénin', style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Legend
          Positioned(
            top: MediaQuery.of(context).padding.top + 70,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10)]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _LegendItem(color: AppColors.primary, label: 'Artisans'),
                  SizedBox(height: 6),
                  _LegendItem(color: AppColors.secondary, label: 'Guides'),
                  SizedBox(height: 6),
                  _LegendItem(color: AppColors.textMuted, label: 'Sites'),
                ],
              ),
            ),
          ),

          // Selected card
          if (_selected != null)
            Positioned(
              bottom: 24,
              left: 16,
              right: 16,
              child: AnimatedScale(
                scale: 1.0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 20, offset: const Offset(0, 4))],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14)),
                        child: const Icon(Icons.person, color: AppColors.textMuted),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_pins.firstWhere((p) => p.id == _selected).label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                            const Text('2.3 km · Ouvert', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => widget.navigate('artisanProfile'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          shape: const StadiumBorder(),
                          textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                        child: const Text('Voir'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Pin {
  final int id;
  final double x, y;
  final String label, type;
  const _Pin({required this.id, required this.x, required this.y, required this.label, required this.type});
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
      ],
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final road = Paint()..color = const Color(0xFFFAF6F0)..strokeWidth = 12..style = PaintingStyle.stroke;
    final street = Paint()..color = const Color(0xFFFAF6F0)..strokeWidth = 4..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    final block = Paint()..color = const Color(0xFFD4BC9A)..style = PaintingStyle.fill;
    final water = Paint()..color = const Color(0xFFB8D4E8)..style = PaintingStyle.fill;

    // Roads
    for (final y in [0.3, 0.5, 0.7]) {
      canvas.drawLine(Offset(0, size.height * y), Offset(size.width, size.height * y), road);
    }
    for (final x in [0.25, 0.5, 0.75]) {
      canvas.drawLine(Offset(size.width * x, 0), Offset(size.width * x, size.height), road);
    }

    // Streets
    for (final y in [0.2, 0.4, 0.6, 0.8]) {
      canvas.drawLine(Offset(0, size.height * y), Offset(size.width, size.height * y), street);
    }
    for (final x in [0.125, 0.375, 0.625, 0.875]) {
      canvas.drawLine(Offset(size.width * x, 0), Offset(size.width * x, size.height), street);
    }

    // Blocks
    final rects = [[0.28, 0.12, 0.2, 0.16], [0.53, 0.12, 0.2, 0.16], [0.15, 0.32, 0.2, 0.16], [0.53, 0.32, 0.2, 0.16], [0.28, 0.52, 0.2, 0.16]];
    for (final r in rects) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(size.width * r[0], size.height * r[1], size.width * r[2], size.height * r[3]),
          const Radius.circular(6),
        ),
        block..color = block.color.withOpacity(0.45),
      );
    }

    // Water/lagoon
    canvas.drawOval(
      Rect.fromCenter(center: Offset(size.width * 0.85, size.height * 0.8), width: size.width * 0.3, height: size.height * 0.15),
      water..color = water.color.withOpacity(0.6),
    );
  }

  @override
  bool shouldRepaint(_) => false;
}
