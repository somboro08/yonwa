import 'package:flutter/material.dart';
import '../providers/commerce_provider.dart';

class BookingProvider extends ChangeNotifier {
  final List<CommerceOrder> _bookings = [];

  List<CommerceOrder> get bookings => List.unmodifiable(_bookings);

  void addBooking(CommerceItem item, String paymentMethod) {
    final booking = CommerceOrder(
      id: 'BOOK-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      item: item,
      paymentMethod: paymentMethod,
      status: CommerceOrderStatus.reserved,
      createdAt: DateTime.now(),
    );
    _bookings.insert(0, booking);
    notifyListeners();
  }

  void cancelBooking(String id) {
    // In a real app, this would involve an API call.
    // For now, we mock the status change.
    final index = _bookings.indexWhere((order) => order.id == id);
    if (index != -1) {
      // Create a new list to maintain immutability and replace the cancelled order
      final booking = _bookings[index];
      _bookings[index] = CommerceOrder(
        id: booking.id,
        item: booking.item,
        paymentMethod: booking.paymentMethod,
        status: CommerceOrderStatus.cancelled,
        createdAt: booking.createdAt,
      );
      notifyListeners();
    }
  }
}
