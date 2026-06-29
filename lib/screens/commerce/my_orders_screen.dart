import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../theme/yonwa_theme.dart';
import '../../providers/commerce_provider.dart';
import '../../core/responsive/responsive_layout.dart';
import '../../core/layout/app_shell.dart';
import '../../shared/widgets/floating_navbar.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  CommerceOrderStatus? _selectedFilter;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final orders = context.watch<CommerceProvider>().orders;

    // Filter orders
    final filteredOrders = _selectedFilter == null
        ? orders
        : orders.where((order) => order.status == _selectedFilter).toList();

    final body = Column(
        children: [
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('Tous'),
                  selected: _selectedFilter == null,
                  onSelected: (_) => setState(() => _selectedFilter = null),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('En attente'),
                  selected: _selectedFilter == CommerceOrderStatus.pending,
                  onSelected: (_) => setState(
                    () => _selectedFilter = CommerceOrderStatus.pending,
                  ),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Payé'),
                  selected: _selectedFilter == CommerceOrderStatus.paid,
                  onSelected: (_) => setState(
                    () => _selectedFilter = CommerceOrderStatus.paid,
                  ),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Réservé'),
                  selected: _selectedFilter == CommerceOrderStatus.reserved,
                  onSelected: (_) => setState(
                    () => _selectedFilter = CommerceOrderStatus.reserved,
                  ),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Annulé'),
                  selected: _selectedFilter == CommerceOrderStatus.cancelled,
                  onSelected: (_) => setState(
                    () => _selectedFilter = CommerceOrderStatus.cancelled,
                  ),
                ),
              ],
            ),
          ),
          // Orders list
          Expanded(
            child: filteredOrders.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_bag_outlined,
                          size: 64,
                          color: isDark
                              ? YonwaColors.neutral600
                              : YonwaColors.neutral300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Aucune réservation',
                          style: YonwaTextStyles.label.copyWith(
                            color: isDark
                                ? YonwaColors.neutral400
                                : YonwaColors.neutral600,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    itemCount: filteredOrders.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final order = filteredOrders[index];
                      return _OrderCard(order: order, isDark: isDark);
                    },
                  ),
          ),
        ],
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
    return InkWell(
      borderRadius: BorderRadius.circular(YonwaRadius.lg),
      onTap: () => _showOrderDetails(context),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? YonwaColors.neutral800 : Colors.white,
          borderRadius: BorderRadius.circular(YonwaRadius.lg),
          border: Border.all(
            color: isDark ? YonwaColors.neutral700 : YonwaColors.neutral200,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(YonwaRadius.md),
                  child: Image.network(
                    order.item.image,
                    width: 76,
                    height: 76,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.item.title,
                        style: YonwaTextStyles.label.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        order.item.typeLabel,
                        style: YonwaTextStyles.caption.copyWith(
                          color: isDark
                              ? YonwaColors.neutral400
                              : YonwaColors.neutral600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        order.item.price,
                        style: YonwaTextStyles.label.copyWith(
                          color: YonwaColors.primary500,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _StatusBadge(status: order.status),
                    const SizedBox(height: 8),
                    Text(
                      DateFormat('dd/MM/yy', 'fr').format(order.createdAt),
                      style: YonwaTextStyles.caption.copyWith(
                        color: isDark
                            ? YonwaColors.neutral400
                            : YonwaColors.neutral600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showOrderDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark
                      ? YonwaColors.neutral700
                      : YonwaColors.neutral300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              'Détails de la réservation',
              style: YonwaTextStyles.h2.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Product image
            ClipRRect(
              borderRadius: BorderRadius.circular(YonwaRadius.lg),
              child: Image.network(
                order.item.image,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),

            // Product info
            Text(
              order.item.title,
              style: YonwaTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              order.item.typeLabel,
              style: YonwaTextStyles.label.copyWith(
                color: YonwaColors.primary500,
              ),
            ),
            const SizedBox(height: 16),

            // Divider
            Divider(
              color: isDark ? YonwaColors.neutral700 : YonwaColors.neutral200,
            ),
            const SizedBox(height: 16),

            // Order details
            _DetailRow(label: 'Référence', value: order.id, isDark: isDark),
            const SizedBox(height: 12),
            _DetailRow(label: 'Prix', value: order.item.price, isDark: isDark),
            const SizedBox(height: 12),
            _DetailRow(
              label: 'Méthode de paiement',
              value: order.paymentMethod,
              isDark: isDark,
            ),
            const SizedBox(height: 12),
            _DetailRow(
              label: 'Date',
              value: DateFormat('dd MMMM yyyy', 'fr').format(order.createdAt),
              isDark: isDark,
            ),
            const SizedBox(height: 12),
            _DetailRow(
              label: 'Statut',
              value: _getStatusLabel(order.status),
              isDark: isDark,
              valueColor: _getStatusColor(order.status),
            ),
            const SizedBox(height: 24),

            // Action buttons
            if (order.status == CommerceOrderStatus.pending)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Confirmer le paiement'),
                ),
              ),
            if (order.status != CommerceOrderStatus.cancelled)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Annuler la réservation'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;
  final Color? valueColor;

  const _DetailRow({
    required this.label,
    required this.value,
    required this.isDark,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: YonwaTextStyles.label.copyWith(
            color: isDark ? YonwaColors.neutral400 : YonwaColors.neutral600,
          ),
        ),
        Text(
          value,
          style: YonwaTextStyles.label.copyWith(
            fontWeight: FontWeight.bold,
            color:
                valueColor ??
                (isDark ? YonwaColors.neutral0 : YonwaColors.neutral900),
          ),
          textAlign: TextAlign.end,
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final CommerceOrderStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withOpacity(0.12),
        borderRadius: BorderRadius.circular(YonwaRadius.full),
      ),
      child: Text(
        _getStatusLabel(status),
        style: YonwaTextStyles.caption.copyWith(
          color: _getStatusColor(status),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

String _getStatusLabel(CommerceOrderStatus status) {
  switch (status) {
    case CommerceOrderStatus.pending:
      return 'En attente';
    case CommerceOrderStatus.paid:
      return 'Payé';
    case CommerceOrderStatus.reserved:
      return 'Réservé';
    case CommerceOrderStatus.cancelled:
      return 'Annulé';
  }
}

Color _getStatusColor(CommerceOrderStatus status) {
  switch (status) {
    case CommerceOrderStatus.pending:
      return YonwaColors.warning;
    case CommerceOrderStatus.paid:
      return YonwaColors.success;
    case CommerceOrderStatus.reserved:
      return YonwaColors.primary500;
    case CommerceOrderStatus.cancelled:
      return YonwaColors.error;
  }
}
