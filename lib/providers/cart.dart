import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final int quantity;

  const CartItem(
      {@required this.title,
      @required this.id,
      @required this.price,
      @required this.quantity});
}

class Cart extends ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemOnCartCount {
    return _items.length;
  }

  void addItemToCart(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingValue) => CartItem(
              id: existingValue.id,
              title: existingValue.title,
              price: existingValue.price,
              quantity: existingValue.quantity + 1));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
                title: title,
                quantity: 1,
                price: price,
                id: DateTime.now().toString(),
              ));
    }
    notifyListeners();
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  bool isInCart(String productId) {
    return _items.containsKey(productId);
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  void removeThisItem(String productId) {
    if (!_items.containsKey(productId))
      return;
    else {
      if (_items[productId].quantity > 1)
        _items.update(
            productId,
            (existingValue) => CartItem(
                title: existingValue.title,
                id: existingValue.id,
                price: existingValue.price,
                quantity: existingValue.quantity - 1));
      else
        _items.remove(productId);
    }
    notifyListeners();
  }
}
