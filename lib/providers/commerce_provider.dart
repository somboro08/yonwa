import 'package:flutter/material.dart';

enum CommerceItemType { product, touristExperience, artisticExperience }

enum CommerceOrderStatus { pending, paid, reserved, cancelled }

class CommerceItem {
  final String id;
  final String title;
  final String price;
  final String image;
  final String seller;
  final String description;
  final CommerceItemType type;

  const CommerceItem({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.seller,
    required this.description,
    required this.type,
  });

  int get amount {
    final digits = price.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(digits) ?? 0;
  }

  String get actionLabel {
    switch (type) {
      case CommerceItemType.product:
        return 'Acheter';
      case CommerceItemType.touristExperience:
        return 'Reserver l experience';
      case CommerceItemType.artisticExperience:
        return 'Reserver l atelier';
    }
  }

  String get typeLabel {
    switch (type) {
      case CommerceItemType.product:
        return 'Produit';
      case CommerceItemType.touristExperience:
        return 'Experience touristique';
      case CommerceItemType.artisticExperience:
        return 'Experience artistique';
    }
  }
}

class CommerceOrder {
  final String id;
  final CommerceItem item;
  final String paymentMethod;
  final CommerceOrderStatus status;
  final DateTime createdAt;

  const CommerceOrder({
    required this.id,
    required this.item,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
  });
}

class CommerceProvider extends ChangeNotifier {
  final List<CommerceItem> _cart = [];
  final List<CommerceOrder> _orders = [
    CommerceOrder(
      id: 'PAY-2406',
      item: const CommerceItem(
        id: 'demo-indigo',
        title: 'Pagne tisse indigo',
        price: '15 000 FCFA',
        image: 'assets/images/hero2.jpg',
        seller: 'Amina Cisse',
        description: 'Commande de demonstration payee via Mobile Money.',
        type: CommerceItemType.product,
      ),
      paymentMethod: 'MTN Mobile Money',
      status: CommerceOrderStatus.paid,
      createdAt: DateTime(2026, 6, 20),
    ),
  ];

  List<CommerceItem> get cart => List.unmodifiable(_cart);
  List<CommerceOrder> get orders => List.unmodifiable(_orders);

  void addToCart(CommerceItem item) {
    if (!_cart.any((cartItem) => cartItem.id == item.id)) {
      _cart.add(item);
      notifyListeners();
    }
  }

  void removeFromCart(String id) {
    _cart.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void createOrder(CommerceItem item, String paymentMethod) {
    final order = CommerceOrder(
      id: 'YON-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      item: item,
      paymentMethod: paymentMethod,
      status: item.type == CommerceItemType.product
          ? CommerceOrderStatus.paid
          : CommerceOrderStatus.reserved,
      createdAt: DateTime.now(),
    );
    _orders.insert(0, order);
    _cart.removeWhere((cartItem) => cartItem.id == item.id);
    notifyListeners();
  }

  void addOrder(CommerceOrder order) {
    _orders.insert(0, order);
    notifyListeners();
  }
}
