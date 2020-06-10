import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/firebase_urls.dart';

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

  Future<void> toggleFavorite(String token, String userId) async {
    _toggleFavorite();
    final String _baseUrl ='${FirebaseURLs.BASE_API_URL}/userFavorites/$userId/$id.json?auth=$token';

    try {
       final response = await http.put('$_baseUrl',
        body: json.encode(isFavorited));

        if(response.statusCode >= 400){
          _toggleFavorite();
        }
    } catch (e) {
      _toggleFavorite();
    }

   
  }
}
