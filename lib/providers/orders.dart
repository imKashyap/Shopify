import 'package:flutter/foundation.dart';
import 'cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> cartItems;
  final DateTime orderTime;

  const OrderItem({
    @required this.id,
    @required this.amount,
    @required this.cartItems,
    @required this.orderTime,
  });
}

class Order extends ChangeNotifier{
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrders(List<CartItem> products, double amount) {
    _orders.insert(
        0,
        OrderItem(
            id: DateTime.now().toString(),
            amount: amount,
            cartItems: products,
            orderTime: DateTime.now()));
    notifyListeners();
  }
}
