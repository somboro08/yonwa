import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';

class PaymentScreen extends StatefulWidget {
  final VoidCallback onBack;
  final Function(String) navigate;
  const PaymentScreen({super.key, required this.onBack, required this.navigate});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _method = 'card';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppTopBar(title: 'Paiement', onBack: widget.onBack),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(18)),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Récapitulatif', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                  SizedBox(height: 12),
                  _SummaryRow(label: "Palais Royaux d'Abomey", value: "2 pers."),
                  _SummaryRow(label: "14 Juillet 2025 · 08:00", value: ""),
                  _SummaryRow(label: "Sous-total", value: "70 000 FCFA"),
                  _SummaryRow(label: "Frais de service", value: "3 500 FCFA"),
                  Divider(color: AppColors.border, height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                      Text('73 500 FCFA', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.primary)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text('Mode de paiement', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark)),
            const SizedBox(height: 12),

            _PaymentOption(
              id: 'card',
              selected: _method,
              icon: Icons.credit_card,
              label: 'Carte bancaire',
              sub: 'Visa, Mastercard',
              onTap: () => setState(() => _method = 'card'),
            ),
            const SizedBox(height: 10),
            _PaymentOption(
              id: 'mobile',
              selected: _method,
              icon: Icons.phone_android,
              label: 'Mobile Money',
              sub: 'MTN, Moov, Celtis',
              onTap: () => setState(() => _method = 'mobile'),
            ),
            const SizedBox(height: 10),
            _PaymentOption(
              id: 'cash',
              selected: _method,
              icon: Icons.money,
              label: 'Paiement sur place',
              sub: 'Réservation sans avance',
              onTap: () => setState(() => _method = 'cash'),
            ),
            const SizedBox(height: 24),

            if (_method == 'card') ...[
              const Text('Détails de la carte', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark)),
              const SizedBox(height: 12),
              const TextField(decoration: InputDecoration(hintText: 'Numéro de carte', prefixIcon: Icon(Icons.credit_card, color: AppColors.textMuted, size: 20))),
              const SizedBox(height: 10),
              Row(
                children: const [
                  Expanded(child: TextField(decoration: InputDecoration(hintText: 'MM / AA', prefixIcon: Icon(Icons.calendar_today_outlined, color: AppColors.textMuted, size: 16)))),
                  SizedBox(width: 10),
                  Expanded(child: TextField(decoration: InputDecoration(hintText: 'CVV', prefixIcon: Icon(Icons.lock_outline, color: AppColors.textMuted, size: 16)))),
                ],
              ),
              const SizedBox(height: 10),
              const TextField(decoration: InputDecoration(hintText: 'Nom du titulaire')),
              const SizedBox(height: 24),
            ],

            if (_method == 'mobile') ...[
              const Text('Numéro Mobile Money', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark)),
              const SizedBox(height: 12),
              const TextField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(hintText: '+229 XX XX XX XX', prefixIcon: Icon(Icons.phone, color: AppColors.textMuted, size: 20)),
              ),
              const SizedBox(height: 24),
            ],

            // Security note
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.green.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
              child: const Row(
                children: [
                  Icon(Icons.shield_outlined, color: AppColors.green, size: 18),
                  SizedBox(width: 10),
                  Expanded(child: Text('Paiement sécurisé SSL 256 bits. Vos données bancaires ne sont jamais stockées.', style: TextStyle(fontSize: 11, color: AppColors.green))),
                ],
              ),
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => widget.navigate('confirmation'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: const StadiumBorder(),
                  textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
                child: const Text('Confirmer et payer · 73 500 FCFA'),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label, value;
  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
          if (value.isNotEmpty) Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textDark)),
        ],
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final String id, selected, label, sub;
  final IconData icon;
  final VoidCallback onTap;

  const _PaymentOption({required this.id, required this.selected, required this.icon, required this.label, required this.sub, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final active = id == selected;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: active ? AppColors.primary.withOpacity(0.06) : AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: active ? AppColors.primary : AppColors.border, width: active ? 1.5 : 1),
        ),
        child: Row(
          children: [
            Container(
              width: 42, height: 42,
              decoration: BoxDecoration(color: active ? AppColors.primary.withOpacity(0.12) : AppColors.surface, borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: active ? AppColors.primary : AppColors.textMuted, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: active ? AppColors.primary : AppColors.textDark)),
                  Text(sub, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                ],
              ),
            ),
            Container(
              width: 20, height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: active ? AppColors.primary : AppColors.border, width: 2),
                color: active ? AppColors.primary : Colors.transparent,
              ),
              child: active ? const Icon(Icons.check, size: 11, color: Colors.white) : null,
            ),
          ],
        ),
      ),
    );
  }
}
