import 'package:flutter/material.dart';
import '../../theme/yonwa_theme.dart';
import '../../models/models.dart';

class PaymentBottomSheet extends StatefulWidget {
  final double amount;
  final Function(PaymentMethod, Map<String, dynamic>) onPaymentConfirmed;

  const PaymentBottomSheet({
    super.key,
    required this.amount,
    required this.onPaymentConfirmed,
  });

  @override
  State<PaymentBottomSheet> createState() => _PaymentBottomSheetState();
}

class _PaymentBottomSheetState extends State<PaymentBottomSheet> {
  PaymentMethod? _selectedMethod;
  final GlobalKey<FormState> _mobileMoneyFormKey = GlobalKey<FormState>();
  final TextEditingController _phoneNumberController = TextEditingController();

  final GlobalKey<FormState> _creditCardFormKey = GlobalKey<FormState>();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: YonwaSpacing.md,
        right: YonwaSpacing.md,
        top: YonwaSpacing.md,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payer ${widget.amount.toInt()} FCFA',
            style: YonwaTextStyles.h3.copyWith(
              color: isDark ? YonwaColors.neutral0 : YonwaColors.neutral800,
            ),
          ),
          const SizedBox(height: YonwaSpacing.lg),

          Text(
            'Choisissez une méthode de paiement',
            style: YonwaTextStyles.body.copyWith(color: YonwaColors.neutral500),
          ),
          const SizedBox(height: YonwaSpacing.md),

          // Dropdown pour les méthodes de paiement
          DropdownButtonFormField<PaymentMethod>(
            initialValue: _selectedMethod,
            decoration: InputDecoration(
              hintText: 'Sélectionner une méthode',
              prefixIcon: Icon(Icons.payment_rounded, color: YonwaColors.primary500),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(YonwaRadius.md),
                borderSide: BorderSide(
                  color: isDark ? YonwaColors.neutral700 : YonwaColors.neutral200,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(YonwaRadius.md),
                borderSide: BorderSide(
                  color: isDark ? YonwaColors.neutral700 : YonwaColors.neutral200,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(YonwaRadius.md),
                borderSide: BorderSide(
                  color: YonwaColors.primary500,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: isDark ? YonwaColors.neutral800 : Colors.white,
            ),
            items: const [
              DropdownMenuItem(
                value: PaymentMethod.cinetpay,
                child: Text('Mobile Money (CinetPay)'),
              ),
              DropdownMenuItem(
                value: PaymentMethod.creditCard,
                child: Text('Carte Bancaire'),
              ),
            ],
            onChanged: (method) {
              setState(() {
                _selectedMethod = method;
              });
            },
            dropdownColor: isDark ? YonwaColors.neutral800 : Colors.white,
            style: YonwaTextStyles.label.copyWith(
              color: isDark ? YonwaColors.neutral0 : YonwaColors.neutral800,
            ),
          ),

          if (_selectedMethod != null) const SizedBox(height: YonwaSpacing.xl),

          // Formulaires dynamiques
          if (_selectedMethod == PaymentMethod.cinetpay)
            _buildMobileMoneyForm(isDark),
          if (_selectedMethod == PaymentMethod.creditCard)
            _buildCreditCardForm(isDark),

          const SizedBox(height: YonwaSpacing.xl),

          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _selectedMethod != null ? _processPayment : null,
              child: const Text('Confirmer le paiement', style: YonwaTextStyles.button),
            ),
          ),
          const SizedBox(height: YonwaSpacing.lg),
        ],
      ),
    );
  }

  Widget _buildMobileMoneyForm(bool isDark) {
    return Form(
      key: _mobileMoneyFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Numéro de téléphone',
            style: YonwaTextStyles.body.copyWith(color: YonwaColors.neutral500),
          ),
          const SizedBox(height: YonwaSpacing.sm),
          TextFormField(
            controller: _phoneNumberController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: 'Ex: 97000000',
              prefixIcon: Icon(Icons.phone_android_rounded, color: YonwaColors.primary500),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(YonwaRadius.md),
              ),
              filled: true,
              fillColor: isDark ? YonwaColors.neutral800 : Colors.white,
            ),
            validator: (value) {
              if (value == null || value.isEmpty || value.length < 8) {
                return 'Veuillez entrer un numéro de téléphone valide';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCreditCardForm(bool isDark) {
    return Form(
      key: _creditCardFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Numéro de carte',
            style: YonwaTextStyles.body.copyWith(color: YonwaColors.neutral500),
          ),
          const SizedBox(height: YonwaSpacing.sm),
          TextFormField(
            controller: _cardNumberController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'XXXX XXXX XXXX XXXX',
              prefixIcon: Icon(Icons.credit_card_rounded, color: YonwaColors.primary500),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(YonwaRadius.md),
              ),
              filled: true,
              fillColor: isDark ? YonwaColors.neutral800 : Colors.white,
            ),
            validator: (value) {
              if (value == null || value.isEmpty || value.length < 16) {
                return 'Veuillez entrer un numéro de carte valide';
              }
              return null;
            },
          ),
          const SizedBox(height: YonwaSpacing.md),
          Text(
            'Nom sur la carte',
            style: YonwaTextStyles.body.copyWith(color: YonwaColors.neutral500),
          ),
          const SizedBox(height: YonwaSpacing.sm),
          TextFormField(
            controller: _cardHolderController,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              hintText: 'Nom complet',
              prefixIcon: Icon(Icons.person_rounded, color: YonwaColors.primary500),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(YonwaRadius.md),
              ),
              filled: true,
              fillColor: isDark ? YonwaColors.neutral800 : Colors.white,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer le nom du titulaire';
              }
              return null;
            },
          ),
          const SizedBox(height: YonwaSpacing.md),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Date d'expiration (MM/AA) ",
                      style: YonwaTextStyles.body.copyWith(color: YonwaColors.neutral500),
                    ),
                    const SizedBox(height: YonwaSpacing.sm),
                    TextFormField(
                      controller: _expiryDateController,
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                        hintText: 'MM/AA',
                        prefixIcon: Icon(Icons.date_range_rounded, color: YonwaColors.primary500),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(YonwaRadius.md),
                        ),
                        filled: true,
                        fillColor: isDark ? YonwaColors.neutral800 : Colors.white,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty || !value.contains('/')) {
                          return 'Format MM/AA invalide';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: YonwaSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CVV',
                      style: YonwaTextStyles.body.copyWith(color: YonwaColors.neutral500),
                    ),
                    const SizedBox(height: YonwaSpacing.sm),
                    TextFormField(
                      controller: _cvvController,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'XXX',
                        prefixIcon: Icon(Icons.lock_rounded, color: YonwaColors.primary500),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(YonwaRadius.md),
                        ),
                        filled: true,
                        fillColor: isDark ? YonwaColors.neutral800 : Colors.white,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty || value.length < 3) {
                          return 'CVV invalide';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _processPayment() {
    // For testing PDF generation, bypass all validation and just confirm payment
    // and close the sheet if a method is selected.
    if (_selectedMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner une méthode de paiement.')),
      );
      return;
    }

    // Dummy payment details for testing
    Map<String, dynamic> paymentDetails = {
      'method': _selectedMethod!.name,
      'status': 'Simulé',
      'amount': widget.amount,
    };

    widget.onPaymentConfirmed(_selectedMethod!, paymentDetails);
    Navigator.pop(context); // Ferme le bottom sheet
  }
}


