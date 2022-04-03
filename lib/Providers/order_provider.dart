// ignore_for_file: prefer_final_fields

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mojatablica/Providers/cart_provider.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime date;

  OrderItem(this.id, this.amount, this.products, this.date);
}

class OrderItems with ChangeNotifier {
  OrderItems(this._token, this._userId, this._orders);
  List<OrderItem> _orders = [];
  String _token, _userId;

  Future<void> addOrder(List<CartItem> items, double totalAmount) async {
    final orderDate = DateTime.now();
    final url = Uri.parse(
        'https://mytab-testapp-default-rtdb.europe-west1.firebasedatabase.app/orders/$_userId.json?auth=$_token');
    try {
      final response = await http.post(url,
          body: json.encode({
            'amount': totalAmount,
            'date': orderDate.toIso8601String(),
            'products': items
                .map((e) => {
                      'id': e.id,
                      'title': e.title,
                      'count': e.count,
                      'price': e.price
                    })
                .toList(),
          }));
      _orders.insert(
          0,
          OrderItem(json.decode(response.body)['name'], totalAmount, items,
              orderDate));
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  List<OrderItem> gerOrders() {
    return [..._orders];
  }

  Future<void> loadOrders() async {
    final url = Uri.parse(
        'https://mytab-testapp-default-rtdb.europe-west1.firebasedatabase.app/orders/$_userId.json?auth=$_token');
    final response = await http.get(url);
    List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) != null
        ? json.decode(response.body) as Map<String, dynamic>
        : {};
    if (extractedData.isNotEmpty) {
      extractedData.forEach((key, value) {
        loadedOrders.add(OrderItem(
            key,
            value['amount'],
            (value['products'] as List<dynamic>)
                .map((e) =>
                    CartItem(e['id'], e['title'], e['count'], e['price']))
                .toList(),
            DateTime.parse(value['date'])));
      });
    }
    _orders = loadedOrders;
    notifyListeners();
  }
}
