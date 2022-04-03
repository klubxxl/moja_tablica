import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mojatablica/Models/errors.dart';
import 'dart:convert';
import 'package:mojatablica/Providers/product_model.dart';

class Products with ChangeNotifier {
  Products(this._token, this._userId, this._items);
  final String _token, _userId;

  List<Product> _items;

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favItems {
    return [..._items.where((element) => element.isFavorite == true).toList()];
  }

  Future<void> addProduct(Product product) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://mytab-testapp-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$_token'),
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'creatorId': _userId,
        }),
      );

      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );

      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Product selectById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> updateById(String id, Product newProduct) async {
    int index = _items.indexWhere((element) => element.id == id);
    if (index >= 0) {
      final url = Uri.parse(
          'https://mytab-testapp-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json?auth=$_token');
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }));
      _items[index] = newProduct;
      notifyListeners();
    } else {
      print(id);
    }
  }

  Future<void> removeById(String id) async {
    final url = Uri.parse(
        'https://mytab-testapp-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json?auth=$_token');
    final existingItemIndex = _items.indexWhere((element) => element.id == id);
    var existingItem = _items[existingItemIndex];

    _items.removeWhere((element) => element.id == id);
    notifyListeners();

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items.insert(existingItemIndex, existingItem);
      notifyListeners();
      throw httpException("httpError");
    }
  }

  Future<void> loadProducts([bool onlyYour = false]) async {
    try {
      String filter = onlyYour ? 'orderBy="creatorId"&equalTo="$_userId"' : '';
      final response = await http.get(Uri.parse(
          'https://mytab-testapp-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$_token&$filter'));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      List<Product> _loadedProd = [];
      final favResponse = await http.get(Uri.parse(
          'https://mytab-testapp-default-rtdb.europe-west1.firebasedatabase.app/favProd/$_userId.json?auth=$_token&$filter'));
      final favResponseData = json.decode(favResponse.body);
      if (extractedData.isNotEmpty) {
        extractedData.forEach((prodId, prodData) {
          _loadedProd.add(Product(
              id: prodId,
              title: prodData['title'],
              description: prodData['description'],
              price: prodData['price'],
              imageUrl: prodData['imageUrl'],
              isFavorite: favResponseData == null
                  ? false
                  : (favResponseData[prodId] ?? false)));
        });
      }
      _items = _loadedProd;
      notifyListeners();
    } catch (error) {
      print(error.toString());
    }
  }
}
