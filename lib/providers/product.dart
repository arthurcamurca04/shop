import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorited;

  Product(
      {this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavorited = false});

  void _toggleFavorite() {
    isFavorited = !isFavorited;
    notifyListeners();
  }

  Future<void> toggleFavorite() async {
    _toggleFavorite();
    final String _baseUrl =
        'https://nn-gamez-18bff.firebaseio.com/products/$id.json';

    try {
       final response = await http.patch('$_baseUrl',
        body: json.encode({'isFavorited': isFavorited}));

        if(response.statusCode >= 400){
          _toggleFavorite();
        }
    } catch (e) {
      _toggleFavorite();
    }

   
  }
}
