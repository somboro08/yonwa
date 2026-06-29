import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/commerce_provider.dart';
import '../../theme/yonwa_theme.dart';
import '../../core/responsive/responsive_layout.dart';
import '../../core/layout/app_shell.dart';
import '../../shared/widgets/floating_navbar.dart';

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final orders = context.watch<CommerceProvider>().orders;

    final body = orders.isEmpty
        ? const Center(child: Text('Aucune reservation pour le moment'))
        : ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            itemCount: orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final order = orders[index];
              return _OrderCard(order: order, isDark: isDark);
            },
          );

    return ResponsiveLayout(
      mobile: Scaffold(
        backgroundColor: isDark ? YonwaColors.neutral900 : YonwaColors.neutral50,
        drawer: const Drawer(),
        body: SafeArea(
          child: Builder(
            builder: (context) => Column(
              children: [
                FloatingNavbar(onMenuPressed: () => Scaffold.of(context).openDrawer()),
                Expanded(child: body),
              ],
            ),
          ),
        ),
      ),
      desktop: AppShell(child: body),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final CommerceOrder order;
  final bool isDark;

  const _OrderCard({required this.order, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(order.status);
    return InkWell(
      onTap: () => _showDetails(context),
      borderRadius: BorderRadius.circular(YonwaRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? YonwaColors.neutral800 : Colors.white,
          borderRadius: BorderRadius.circular(YonwaRadius.lg),
          border: Border.all(color: isDark ? YonwaColors.neutral700 : YonwaColors.neutral200),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(YonwaRadius.md),
              child: Image.network(order.item.image, width: 76, height: 76, fit: BoxFit.cover),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(order.item.title, style: YonwaTextStyles.label.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(order.item.typeLabel, style: YonwaTextStyles.caption.copyWith(color: YonwaColors.neutral500)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(YonwaRadius.full),
                        ),
                        child: Text(
                          _statusLabel(order.status),
                          style: YonwaTextStyles.caption.copyWith(color: color, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(order.item.price, style: YonwaTextStyles.caption.copyWith(color: YonwaColors.primary500)),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: YonwaColors.neutral400),
          ],
        ),
      ),
    );
  }

  void _showDetails(BuildContext context) {
    final date = DateFormat('dd MMM yyyy, HH:mm', 'fr').format(order.createdAt);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(order.item.title, style: YonwaTextStyles.h2),
            const SizedBox(height: 8),
            Text(order.item.description, style: YonwaTextStyles.body),
            const Divider(height: 28),
            _detail('Reference', order.id),
            _detail('Statut', _statusLabel(order.status)),
            _detail('Montant', order.item.price),
            _detail('Paiement', order.paymentMethod),
            _detail('Date', date),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _detail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: YonwaTextStyles.caption.copyWith(color: YonwaColors.neutral500)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: YonwaTextStyles.label.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(CommerceOrderStatus status) {
    switch (status) {
      case CommerceOrderStatus.pending:
        return YonwaColors.warning;
      case CommerceOrderStatus.paid:
        return YonwaColors.success;
      case CommerceOrderStatus.reserved:
        return YonwaColors.info;
      case CommerceOrderStatus.cancelled:
        return YonwaColors.error;
    }
  }

  String _statusLabel(CommerceOrderStatus status) {
    switch (status) {
      case CommerceOrderStatus.pending:
        return 'En attente';
      case CommerceOrderStatus.paid:
        return 'Paiement effectue';
      case CommerceOrderStatus.reserved:
        return 'Reservation confirmee';
      case CommerceOrderStatus.cancelled:
        return 'Annule';
    }
  }
}
