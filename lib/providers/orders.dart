import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'cart.dart';
import 'package:http/http.dart' as http;

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

class Order extends ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrders(List<CartItem> products, double amount) async {
    const url = 'https://shopify-e3c1a.firebaseio.com/orders.json';
    try {
      final timeStamp = DateTime.now();
      final response = await http.post(url,
          body: json.encode({
            'amount': amount,
            'orderTime': timeStamp.toIso8601String(),
            'cartItems': products
                .map((e) => {
                      'id': e.id,
                      'title': e.title,
                      'price': e.price,
                      'quantity': e.quantity
                    })
                .toList(),
          }));
      _orders.insert(
          0,
          OrderItem(
              id: json.decode(response.body)['name'],
              amount: amount,
              cartItems: products,
              orderTime: timeStamp));
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> fetchAndSetProduct() async {
    try {
      const url = 'https://shopify-e3c1a.firebaseio.com/orders.json';
      final response = await http.get(url);
      final extractedOrders =
          json.decode(response.body) as Map<String, dynamic>;
      if(extractedOrders==null)return;
      List<OrderItem> loadedProducts = [];
      extractedOrders.forEach((orderId, orderData) {
        OrderItem orderItem = OrderItem(
            id: orderId,
            amount: orderData['amount'],
            cartItems: (orderData['cartItems'] as List<dynamic>)
                .map((value) => CartItem(
                    title: value['title'],
                    id: value['id'],
                    price: value['price'],
                    quantity: value['quantity']))
                .toList(),
            orderTime: DateTime.parse(orderData['orderTime']));
        loadedProducts.add(orderItem);
      });
      _orders = loadedProducts;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
