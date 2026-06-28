import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../theme/yonwa_theme.dart';
import '../../providers/commerce_provider.dart';

class ProductDetailPage extends StatefulWidget {
  final CommerceItem item;

  const ProductDetailPage({super.key, required this.item});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  String? _selectedPaymentMethod;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'label': 'MTN Mobile Money',
      'icon': Icons.phone_android,
      'color': YonwaColors.primary500,
    },
    {
      'label': 'MOOV Mobile Money',
      'icon': Icons.phone_android,
      'color': YonwaColors.secondary,
    },
    {
      'label': 'Carte bancaire',
      'icon': Icons.credit_card,
      'color': YonwaColors.accent,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? YonwaColors.neutral900 : YonwaColors.neutral50,
      appBar: AppBar(
        title: const Text('Détails du produit'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(YonwaSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(YonwaRadius.xl),
              child: Image.network(
                widget.item.image,
                height: 280,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: YonwaSpacing.xl),

            // Product Info
            Text(
              widget.item.title,
              style: YonwaTextStyles.h1.copyWith(
                color: isDark ? YonwaColors.neutral0 : YonwaColors.neutral900,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: YonwaSpacing.sm),
            Text(
              widget.item.typeLabel,
              style: YonwaTextStyles.body.copyWith(
                color: YonwaColors.primary500,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: YonwaSpacing.md),

            // Price
            Container(
              padding: const EdgeInsets.all(YonwaSpacing.md),
              decoration: BoxDecoration(
                color: YonwaColors.primary100.withOpacity(0.2),
                borderRadius: BorderRadius.circular(YonwaRadius.md),
                border: Border.all(color: YonwaColors.primary300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Prix total',
                    style: YonwaTextStyles.label.copyWith(
                      color: isDark
                          ? YonwaColors.neutral300
                          : YonwaColors.neutral600,
                    ),
                  ),
                  Text(
                    widget.item.price,
                    style: YonwaTextStyles.h2.copyWith(
                      color: YonwaColors.primary500,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: YonwaSpacing.xl),

            // Date & Time Selection (for experiences)
            if (widget.item.type != CommerceItemType.product) ...[
              Text(
                'Date et heure',
                style: YonwaTextStyles.label.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? YonwaColors.neutral0 : YonwaColors.neutral900,
                ),
              ),
              const SizedBox(height: YonwaSpacing.md),
              Row(
                children: [
                  Expanded(child: _buildDateButton(context, isDark)),
                  const SizedBox(width: YonwaSpacing.md),
                  Expanded(child: _buildTimeButton(context, isDark)),
                ],
              ),
              const SizedBox(height: YonwaSpacing.xl),
            ],

            // Payment Method Selection
            Text(
              'Méthode de paiement',
              style: YonwaTextStyles.label.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? YonwaColors.neutral0 : YonwaColors.neutral900,
              ),
            ),
            const SizedBox(height: YonwaSpacing.md),
            Column(
              children: _paymentMethods.map((method) {
                final isSelected = _selectedPaymentMethod == method['label'];
                return Padding(
                  padding: const EdgeInsets.only(bottom: YonwaSpacing.md),
                  child: InkWell(
                    onTap: () => setState(
                      () => _selectedPaymentMethod = method['label'],
                    ),
                    borderRadius: BorderRadius.circular(YonwaRadius.md),
                    child: Container(
                      padding: const EdgeInsets.all(YonwaSpacing.md),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? method['color'].withOpacity(0.12)
                            : (isDark ? YonwaColors.neutral800 : Colors.white),
                        borderRadius: BorderRadius.circular(YonwaRadius.md),
                        border: Border.all(
                          color: isSelected
                              ? method['color']
                              : (isDark
                                    ? YonwaColors.neutral700
                                    : YonwaColors.neutral200),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: method['color'].withOpacity(0.1),
                              borderRadius: BorderRadius.circular(
                                YonwaRadius.md,
                              ),
                            ),
                            child: Icon(
                              method['icon'],
                              color: method['color'],
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: YonwaSpacing.md),
                          Expanded(
                            child: Text(
                              method['label'],
                              style: YonwaTextStyles.label.copyWith(
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                color: isSelected
                                    ? method['color']
                                    : (isDark
                                          ? YonwaColors.neutral200
                                          : YonwaColors.neutral700),
                              ),
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_circle_rounded,
                              color: method['color'],
                              size: 24,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: YonwaSpacing.xl),

            // Seller Info
            Container(
              padding: const EdgeInsets.all(YonwaSpacing.md),
              decoration: BoxDecoration(
                color: isDark ? YonwaColors.neutral800 : YonwaColors.neutral100,
                borderRadius: BorderRadius.circular(YonwaRadius.md),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: YonwaColors.primary100,
                    ),
                    child: const Icon(
                      Icons.person_outline,
                      color: YonwaColors.primary500,
                    ),
                  ),
                  const SizedBox(width: YonwaSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Vendeur',
                          style: YonwaTextStyles.caption.copyWith(
                            color: isDark
                                ? YonwaColors.neutral400
                                : YonwaColors.neutral600,
                          ),
                        ),
                        Text(
                          widget.item.seller,
                          style: YonwaTextStyles.label.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? YonwaColors.neutral0
                                : YonwaColors.neutral900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.verified, color: YonwaColors.success, size: 20),
                ],
              ),
            ),
            const SizedBox(height: YonwaSpacing.xl),

            // Description
            Text(
              'Description',
              style: YonwaTextStyles.label.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? YonwaColors.neutral0 : YonwaColors.neutral900,
              ),
            ),
            const SizedBox(height: YonwaSpacing.sm),
            Text(
              widget.item.description,
              style: YonwaTextStyles.body.copyWith(
                color: isDark ? YonwaColors.neutral400 : YonwaColors.neutral600,
              ),
            ),
            const SizedBox(height: YonwaSpacing.xl),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          left: YonwaSpacing.lg,
          right: YonwaSpacing.lg,
          top: YonwaSpacing.md,
          bottom: YonwaSpacing.lg + MediaQuery.of(context).padding.bottom,
        ),
        decoration: BoxDecoration(
          color: isDark ? YonwaColors.neutral800 : Colors.white,
          border: Border(
            top: BorderSide(
              color: isDark ? YonwaColors.neutral700 : YonwaColors.neutral200,
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_selectedPaymentMethod == null)
              Text(
                'Veuillez sélectionner une méthode de paiement',
                style: YonwaTextStyles.caption.copyWith(
                  color: YonwaColors.warning,
                ),
              ),
            if (_selectedPaymentMethod == null)
              const SizedBox(height: YonwaSpacing.sm),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedPaymentMethod != null
                    ? () => _processPayment(context)
                    : null,
                child: Text(widget.item.actionLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateButton(BuildContext context, bool isDark) {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now().add(const Duration(days: 1)),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (date != null) {
          setState(() => _selectedDate = date);
        }
      },
      borderRadius: BorderRadius.circular(YonwaRadius.md),
      child: Container(
        padding: const EdgeInsets.all(YonwaSpacing.md),
        decoration: BoxDecoration(
          color: isDark ? YonwaColors.neutral800 : Colors.white,
          borderRadius: BorderRadius.circular(YonwaRadius.md),
          border: Border.all(
            color: isDark ? YonwaColors.neutral700 : YonwaColors.neutral200,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date',
              style: YonwaTextStyles.caption.copyWith(
                color: isDark ? YonwaColors.neutral400 : YonwaColors.neutral600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _selectedDate == null
                  ? 'Sélectionner'
                  : DateFormat('dd/MM/yyyy', 'fr').format(_selectedDate!),
              style: YonwaTextStyles.label.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? YonwaColors.neutral0 : YonwaColors.neutral900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeButton(BuildContext context, bool isDark) {
    return InkWell(
      onTap: () async {
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (time != null) {
          setState(() => _selectedTime = time);
        }
      },
      borderRadius: BorderRadius.circular(YonwaRadius.md),
      child: Container(
        padding: const EdgeInsets.all(YonwaSpacing.md),
        decoration: BoxDecoration(
          color: isDark ? YonwaColors.neutral800 : Colors.white,
          borderRadius: BorderRadius.circular(YonwaRadius.md),
          border: Border.all(
            color: isDark ? YonwaColors.neutral700 : YonwaColors.neutral200,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Heure',
              style: YonwaTextStyles.caption.copyWith(
                color: isDark ? YonwaColors.neutral400 : YonwaColors.neutral600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _selectedTime == null
                  ? 'Sélectionner'
                  : _selectedTime!.format(context),
              style: YonwaTextStyles.label.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? YonwaColors.neutral0 : YonwaColors.neutral900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _processPayment(BuildContext context) {
    final commerce = context.read<CommerceProvider>();

    // Create an order
    final order = CommerceOrder(
      id: 'PAY-${DateTime.now().millisecondsSinceEpoch}',
      item: widget.item,
      paymentMethod: _selectedPaymentMethod!,
      status: CommerceOrderStatus.pending,
      createdAt: DateTime.now(),
    );

    commerce.addOrder(order);

    // Show success dialog
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Paiement initialisé'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Référence: ${order.id}'),
            const SizedBox(height: 8),
            Text('Montant: ${widget.item.price}'),
            const SizedBox(height: 8),
            Text('Méthode: $_selectedPaymentMethod'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close detail page
            },
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }
}
