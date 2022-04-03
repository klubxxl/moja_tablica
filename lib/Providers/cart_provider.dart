// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/foundation.dart';

class CartItem {
  final String id, title;
  final int count;
  final double price;
  CartItem(
    @required this.id,
    @required this.title,
    @required this.count,
    @required this.price,
  );
}

class CartItems with ChangeNotifier {
  Map<String, CartItem> _cartItems = {};

  Map<String, CartItem> get cartItems {
    return {..._cartItems};
  }

  double get priceOfProducts {
    double prices = 0;
    _cartItems.forEach((key, value) {
      prices += value.price * value.count;
    });
    return prices;
  }

  int get itemsCount {
    return _cartItems.length;
  }

  void addCardItem(String id, String title, double price) {
    if (_cartItems.containsKey(id)) {
      _cartItems.update(
          id, (value) => CartItem(value.id, title, value.count + 1, price));
    } else {
      _cartItems.putIfAbsent(
          id, () => CartItem(DateTime.now().toString(), title, 1, price));
    }

    notifyListeners();
  }

  void removeById(String id) {
    if (_cartItems.containsKey(id)) {
      _cartItems.remove(id);
      notifyListeners();
    }
  }

  void removeSingleProduct(String id) {
    if (_cartItems.containsKey(id)) {
      if (_cartItems[id]!.count > 1)
        _cartItems.update(
            id,
            (value) =>
                CartItem(value.id, value.title, value.count - 1, value.price));
      else
        _cartItems.remove(id);
    }

    notifyListeners();
  }

  void clear() {
    _cartItems = {};
    notifyListeners();
  }
}
