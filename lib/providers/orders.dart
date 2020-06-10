import 'dart:convert';
import 'cart.dart';

import '../utils/firebase_urls.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Order {
  final String id;
  final double total;
  final List<CartItem> products;
  final DateTime date;

  Order({this.id, this.total, this.products, this.date});
}

class Orders with ChangeNotifier {
  final String _baseUrl = '${FirebaseURLs.BASE_API_URL}/orders';

  String _token;
  String _userId;

  List<Order> _orders = [];

  Orders([this._token, this._userId, this._orders = const[]]);

  List<Order> get orders => [..._orders];

  int get itemsCount => _orders.length;

  Future<void> loadOrders() async {
    List<Order> loadedOrders = [];
    final response = await http.get("$_baseUrl/$_userId.json?auth=$_token");
    Map<String, dynamic> data = json.decode(response.body);

    print(data);
    try {
      if (data != null) {
        data.forEach((orderId, orderData) {
          loadedOrders.add(Order(
            id: orderId,
            total: orderData['total'],
            date: DateTime.parse(orderData['date']),
            products: (orderData['products'] as List<dynamic>).map((item){
              return CartItem(
                id: item['id'],
                price: item['price'],
                productID: item['productID'],
                quantity: item['quantity'],
                title: item['title'],
              );
            }).toList(),
          ));
        });
        notifyListeners();
      }
      _orders = loadedOrders.reversed.toList();
    } catch (e) {
      print(e.toString());
    }
    return Future.value();
  }

  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();

    try {
      final response = await http.post('$_baseUrl/$_userId.json?auth=$_token',
          body: json.encode({
            'products': cart.items.values
                .map((ci) => {
                      'id': ci.id,
                      'price': ci.price,
                      'title': ci.title,
                      'productID': ci.productID,
                      'quantity': ci.quantity
                    })
                .toList(),
            'total': cart.totalAmount,
            'date': date.toIso8601String(),
          }));

      _orders.insert(
          0,
          Order(
            id: json.decode(response.body)['name'],
            products: cart.items.values.toList(),
            total: cart.totalAmount,
            date: date,
          ));
      print(json.decode(response.body));
      notifyListeners();
    } catch (e) {
      print(e.toString());
      print('Não deu certo');
    }
  }
}
