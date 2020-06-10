import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../providers/product.dart';
import '../utils/firebase_urls.dart';

class Products with ChangeNotifier {
  final String _baseUrl = '${FirebaseURLs.BASE_API_URL}/products';
  List<Product> _items = [];
  String _token;
  String _userId;

  Products([this._token, this._userId, this._items = const []]);

  List<Product> get items {
    return [..._items];
  }

  int get itemCount => _items.length;

  List<Product> get favoritIitems {
    return _items.where((p) => p.isFavorited).toList();
  }

  Future<void> loadProducts() async {
    final response = await http.get("$_baseUrl.json?auth=$_token");
    Map<String, dynamic> data = json.decode(response.body);
    final favResponse = await http.get(
        "${FirebaseURLs.BASE_API_URL}/userFavorites/$_userId.json?auth=$_token");
    final favMap = json.decode(favResponse.body);

    _items.clear();
    if (data != null) {
      data.forEach((productId, productData) {
        final isFavorited = favMap == null ? false : favMap[productId] ?? false;
        _items.add(Product(
          id: productId,
          title: productData['title'],
          description: productData['description'],
          price: productData['price'],
          imageUrl: productData['imageUrl'],
          isFavorited: isFavorited,
        ));
      });
      notifyListeners();
    }

    return Future.value();
  }

  Future<void> addProduct(Product newProduct) async {
    await http
        .post("$_baseUrl.json?auth=$_token",
            body: json.encode({
              'title': newProduct.title,
              'description': newProduct.description,
              'price': newProduct.price,
              'imageUrl': newProduct.imageUrl,
            }))
        .then((response) {
      var id = json.decode(response.body)['name'];
      print(id);
      _items.add(Product(
        id: id,
        title: newProduct.title,
        description: newProduct.description,
        price: newProduct.price,
        imageUrl: newProduct.imageUrl,
      ));
      notifyListeners();
      return Future.value();
    });
  }

  Future<void> updateProduct(Product product) async {
    if (product == null || product.id == null) {
      return;
    }

    final index = _items.indexWhere((prod) => prod.id == product.id);

    if (index >= 0) {
      try {
        await http.patch(
          '$_baseUrl/${product.id}.json?auth=$_token',
          body: json.encode({
            "title": product.title,
            "description": product.description,
            "price": product.price,
            "imageUrl": product.imageUrl
          }),
        );
        _items[index] = product;
        notifyListeners();
      } catch (e) {
        print(e.toString());
      }
    }
  }

  Future<void> removeProduct(String id) async {
    final index = _items.indexWhere((prod) => prod.id == id);

    if (index >= 0) {
      final product = _items[index];
      _items.remove(product);
      notifyListeners();

      final response =
          await http.delete('$_baseUrl/${product.id}.json?auth=$_token');

      if (response.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();
      }
    }
  }
}
