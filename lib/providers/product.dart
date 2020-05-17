import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product extends ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      @required this.isFavorite });

  Future<void> toggleFavoriteStatus() async {
    try {
      final String url =
          'https://shopify-e3c1a.firebaseio.com/products/$id.json';
      isFavorite = !isFavorite;
      final response=await http.patch(
        url,
        body: json.encode({'isFavorite': isFavorite}),
      );
      if(response.statusCode>=400)isFavorite = !isFavorite;
      notifyListeners();
    } catch (error) {
      isFavorite = !isFavorite;
      print(error);
      notifyListeners();
      throw error;
    }
  }
}
