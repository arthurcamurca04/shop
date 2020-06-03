import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/data/dummy_data.dart';
import 'package:shop/providers/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = dummyData;

  List<Product> get items {
    return _items;
  }

  int get itemCount => _items.length;

  List<Product> get favoritIitems {
    return _items.where((p) => p.isFavorited).toList();
  }

  void addProduct(Product newProduct) {
    _items.add(Product(
      id: Random().nextDouble().toString(),
      title: newProduct.title,
      description: newProduct.description,
      price: newProduct.price,
      imageUrl: newProduct.imageUrl,
    ));
    notifyListeners();
  }

  void updateProduct(Product product) 
  {
    if(product != null || product.id != null)
    {
      return;
    }

    final index = _items.indexWhere((prod) => prod.id == product.id);

    if(index >= 0)
    {
      _items[index] = product;
      notifyListeners();
    }
  }

  void removeProduct(String id)
  {
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }
}
