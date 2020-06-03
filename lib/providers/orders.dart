import 'dart:math';

import 'package:flutter/material.dart';
import 'cart.dart';

class Order {
  final String id;
  final double total;
  final List<CartItem> products;
  final DateTime date;

  Order({this.id, this.total, this.products, this.date});
}

class Orders with ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders => _orders;

  int get itemsCount => _orders.length;

  void addOrder(List<CartItem> products) {

    final combine = (total, prod) => total + (prod.price * prod.quantity);
    final total = products.fold(0.0, combine); 

    _orders.insert(0, Order(
      id: Random().nextDouble().toString(),
      products: products,
      total: total,
      date: DateTime.now(),
    ));

    notifyListeners();
  }
}
