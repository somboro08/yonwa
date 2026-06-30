import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';

class BookingScreen extends StatefulWidget {
  final VoidCallback onBack;
  final Function(String) navigate;
  const BookingScreen({super.key, required this.onBack, required this.navigate});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime _selected = DateTime(2025, 7, 14);
  int _adults = 2;
  int _children = 0;
  final int _basePrice = 35000;

  int get _total => (_adults + _children) * _basePrice;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppTopBar(title: 'Réserver', onBack: widget.onBack),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: AppColors.textDark.withOpacity(0.06), blurRadius: 10)]),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: const SizedBox(
                      width: 70, height: 70,
                      child: NetworkImg(url: "https://images.unsplash.com/photo-1564507592333-c60657eea523?w=200&h=200&fit=crop"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Palais Royaux d'Abomey", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                        SizedBox(height: 4),
                        Text("Prosper Houédanou · 4h", style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                        SizedBox(height: 4),
                        StarRating(value: 4.9, count: 312, size: 11),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Date picker
            const Text('Choisir une date', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark)),
            const SizedBox(height: 12),
            _buildCalendar(),
            const SizedBox(height: 24),

            // Participants
            const Text('Participants', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark)),
            const SizedBox(height: 12),
            _ParticipantRow(label: 'Adultes', sub: '13 ans et plus', value: _adults, onMinus: () { if (_adults > 1) setState(() => _adults--); }, onPlus: () => setState(() => _adults++)),
            const SizedBox(height: 8),
            _ParticipantRow(label: 'Enfants', sub: '2–12 ans', value: _children, onMinus: () { if (_children > 0) setState(() => _children--); }, onPlus: () => setState(() => _children++)),
            const SizedBox(height: 24),

            // Time slot
            const Text('Créneau horaire', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10, runSpacing: 8,
              children: ['08:00', '10:00', '14:00', '16:00'].map((t) {
                final active = t == '09:00' || t == '08:00';
                return GestureDetector(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      color: t == '08:00' ? AppColors.primary : AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(t, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: t == '08:00' ? Colors.white : AppColors.textDark)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Price breakdown
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  _PriceLine(label: '${((_basePrice / 1000)).toStringAsFixed(0)}k FCFA × $_adults adultes', value: _adults * _basePrice),
                  if (_children > 0) _PriceLine(label: '${((_basePrice * 0.5 / 1000)).toStringAsFixed(0)}k FCFA × $_children enfants', value: (_children * _basePrice * 0.5).round()),
                  _PriceLine(label: 'Frais de service', value: 3500),
                  const Divider(color: AppColors.border, height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                      Text('${((_total + 3500) / 1000).toStringAsFixed(0)} 500 FCFA', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.primary)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => widget.navigate('payment'),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: const StadiumBorder(), textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                child: const Text('Continuer vers le paiement'),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    final now = DateTime.now();
    final daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(18)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.chevron_left, color: AppColors.textMuted),
              Text('Juillet 2025', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textDark)),
              const Icon(Icons.chevron_right, color: AppColors.primary),
            ],
          ),
          const SizedBox(height: 8),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 7,
            childAspectRatio: 1.1,
            children: List.generate(daysInMonth, (i) {
              final day = i + 1;
              final isSelected = day == _selected.day;
              return GestureDetector(
                onTap: () => setState(() => _selected = DateTime(2025, 7, day)),
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$day',
                      style: TextStyle(fontSize: 12, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400, color: isSelected ? Colors.white : AppColors.textDark),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _ParticipantRow extends StatelessWidget {
  final String label, sub;
  final int value;
  final VoidCallback onMinus, onPlus;

  const _ParticipantRow({required this.label, required this.sub, required this.value, required this.onMinus, required this.onPlus});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                Text(sub, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
              ],
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: onMinus,
                child: Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.remove, size: 16, color: AppColors.textDark),
                ),
              ),
              SizedBox(
                width: 36,
                child: Text('$value', textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
              ),
              GestureDetector(
                onTap: onPlus,
                child: Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.add, size: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PriceLine extends StatelessWidget {
  final String label;
  final int value;

  const _PriceLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
          Text('${(value / 1000).toStringAsFixed(0)} 000 FCFA', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textDark)),
        ],
      ),
    );
  }
}
