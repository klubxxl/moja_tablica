import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  String title;
  String description;
  String imageUrl;
  double price;
  bool isFavorite;

  Product(
      {required this.id,
      required this.description,
      required this.title,
      required this.imageUrl,
      required this.price,
      this.isFavorite = false});

  void _setFavorite(bool newStatus) {
    isFavorite = newStatus;
    notifyListeners();
  }

  Future<void> changeIsFavorite(String token, String userId) async {
    bool oldStatus = isFavorite;
    _setFavorite(!isFavorite);

    final url = Uri.parse(
        'https://mytab-testapp-default-rtdb.europe-west1.firebasedatabase.app/favProd/$userId/$id.json?auth=$token');
    try {
      final p = await http.put(url, body: json.encode(isFavorite));
      if (p.statusCode >= 400) {
        _setFavorite(oldStatus);
        print(p.statusCode);
      }
    } catch (error) {
      _setFavorite(oldStatus);
      print(error.toString());
    }
  }
}
