import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/commerce_provider.dart';
import '../../theme/yonwa_theme.dart';

class CheckoutScreen extends StatefulWidget {
  final CommerceItem item;

  const CheckoutScreen({super.key, required this.item});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _method = 'MTN Mobile Money';
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? YonwaColors.neutral900 : YonwaColors.neutral50,
      appBar: AppBar(
        title: Text(widget.item.type == CommerceItemType.product ? 'Achat' : 'Reservation'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SummaryCard(item: widget.item, isDark: isDark),
          const SizedBox(height: 20),
          Text(
            'Mode de paiement',
            style: YonwaTextStyles.h3.copyWith(
              color: isDark ? Colors.white : YonwaColors.neutral800,
            ),
          ),
          const SizedBox(height: 12),
          _PaymentTile(
            label: 'MTN Mobile Money',
            subtitle: 'Paiement par numero MTN MoMo',
            color: const Color(0xFFFFCC00),
            selected: _method == 'MTN Mobile Money',
            onTap: () => setState(() => _method = 'MTN Mobile Money'),
          ),
          const SizedBox(height: 10),
          _PaymentTile(
            label: 'Moov Money',
            subtitle: 'Paiement par numero Moov Money',
            color: const Color(0xFF0066CC),
            selected: _method == 'Moov Money',
            onTap: () => setState(() => _method = 'Moov Money'),
          ),
          const SizedBox(height: 20),
          TextField(
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Numero de paiement',
              hintText: '+229 97 00 00 00',
              prefixIcon: const Icon(Icons.phone_android_rounded),
              filled: true,
              fillColor: isDark ? YonwaColors.neutral800 : Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(YonwaRadius.lg),
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _isProcessing ? null : _confirm,
            style: ElevatedButton.styleFrom(
              backgroundColor: YonwaColors.primary500,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: _isProcessing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                : Text(widget.item.actionLabel),
          ),
        ],
      ),
    );
  }

  Future<void> _confirm() async {
    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    context.read<CommerceProvider>().createOrder(widget.item, _method);
    setState(() => _isProcessing = false);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Operation confirmee'),
        content: Text('${widget.item.title} a ete enregistre avec $_method.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
            child: const Text('Retour accueil'),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final CommerceItem item;
  final bool isDark;

  const _SummaryCard({required this.item, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? YonwaColors.neutral800 : Colors.white,
        borderRadius: BorderRadius.circular(YonwaRadius.lg),
        border: Border.all(color: isDark ? YonwaColors.neutral700 : YonwaColors.neutral200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(YonwaRadius.lg)),
            child: Image.network(item.image, height: 180, width: double.infinity, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.typeLabel, style: YonwaTextStyles.caption.copyWith(color: YonwaColors.primary500)),
                const SizedBox(height: 4),
                Text(item.title, style: YonwaTextStyles.h2),
                const SizedBox(height: 8),
                Text(item.description, style: YonwaTextStyles.body),
                const Divider(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total', style: YonwaTextStyles.label.copyWith(fontWeight: FontWeight.bold)),
                    Text(item.price, style: YonwaTextStyles.h3.copyWith(color: YonwaColors.primary500)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentTile extends StatelessWidget {
  final String label;
  final String subtitle;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _PaymentTile({
    required this.label,
    required this.subtitle,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(YonwaRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.12) : (isDark ? YonwaColors.neutral800 : Colors.white),
          borderRadius: BorderRadius.circular(YonwaRadius.lg),
          border: Border.all(color: selected ? color : (isDark ? YonwaColors.neutral700 : YonwaColors.neutral200)),
        ),
        child: Row(
          children: [
            Icon(Icons.phone_android_rounded, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: YonwaTextStyles.label.copyWith(fontWeight: FontWeight.bold)),
                  Text(subtitle, style: YonwaTextStyles.caption.copyWith(color: YonwaColors.neutral500)),
                ],
              ),
            ),
            if (selected) Icon(Icons.check_circle_rounded, color: color),
          ],
        ),
      ),
    );
  }
}
