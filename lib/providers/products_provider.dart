import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/providers/product.dart';

class Products with ChangeNotifier {
  final String _baseUrl = 'https://nn-gamez-18bff.firebaseio.com/products';
  List<Product> _items = [];

  List<Product> get items {
    return _items;
  }

  int get itemCount => _items.length;

  List<Product> get favoritIitems {
    return _items.where((p) => p.isFavorited).toList();
  }

  Future<void> loadProducts() async {
    final response = await http.get("$_baseUrl.json");
    Map<String, dynamic> data = json.decode(response.body);
    _items.clear();
    if (data != null) {
      data.forEach((productId, productData) {
        _items.add(Product(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            price: productData['price'],
            imageUrl: productData['imageUrl'],
            isFavorited: productData['isFavorited']));
      });
      notifyListeners();
    }

    return Future.value();
  }

  Future<void> addProduct(Product newProduct) async {
    await http
        .post("$_baseUrl.json",
            body: json.encode({
              'title': newProduct.title,
              'description': newProduct.description,
              'price': newProduct.price,
              'imageUrl': newProduct.imageUrl,
              'isFavorited': newProduct.isFavorited,
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
          '$_baseUrl/${product.id}.json',
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

      final response = await http.delete('$_baseUrl/${product.id}.json');

      if(response.statusCode >= 400){
        _items.insert(index, product);
         notifyListeners();
      }

  
    }
  }
}
 