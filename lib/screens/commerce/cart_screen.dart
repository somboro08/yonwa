import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/commerce_provider.dart';
import '../../theme/yonwa_theme.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cart = context.watch<CommerceProvider>().cart;

    return Scaffold(
      backgroundColor: isDark ? YonwaColors.neutral900 : YonwaColors.neutral50,
      appBar: AppBar(
        title: const Text('Panier'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: cart.isEmpty
          ? const Center(child: Text('Votre panier est vide'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: cart.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = cart[index];
                return _CartItemCard(item: item, isDark: isDark);
              },
            ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final CommerceItem item;
  final bool isDark;

  const _CartItemCard({required this.item, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(YonwaRadius.lg),
      onTap: () => _showDetails(context),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? YonwaColors.neutral800 : Colors.white,
          borderRadius: BorderRadius.circular(YonwaRadius.lg),
          border: Border.all(color: isDark ? YonwaColors.neutral700 : YonwaColors.neutral200),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(YonwaRadius.md),
              child: Image.network(item.image, width: 76, height: 76, fit: BoxFit.cover),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title, style: YonwaTextStyles.label.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(item.typeLabel, style: YonwaTextStyles.caption.copyWith(color: YonwaColors.neutral500)),
                  const SizedBox(height: 4),
                  Text(item.price, style: YonwaTextStyles.label.copyWith(color: YonwaColors.primary500)),
                ],
              ),
            ),
            IconButton(
              onPressed: () => context.read<CommerceProvider>().removeFromCart(item.id),
              icon: const Icon(Icons.delete_outline_rounded, color: YonwaColors.error),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.title, style: YonwaTextStyles.h2),
            const SizedBox(height: 8),
            Text(item.description, style: YonwaTextStyles.body),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => CheckoutScreen(item: item)));
                },
                child: Text(item.actionLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
