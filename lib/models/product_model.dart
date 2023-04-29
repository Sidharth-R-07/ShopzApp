import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String? id;
  final String? title;
  final String? description;
  final double? price;
  final String? imageUrl;
  bool isFavorite;

  Product({
    this.description,
    this.id,
    this.imageUrl,
    this.title,
    this.price,
    this.isFavorite = false,
  });

  Future<String> togleisFavoriteStatus(String authToken, String userId) async {
    String result = 'Something went wrong!try again.';
    final oldValue = isFavorite;
    isFavorite = !isFavorite;
    final url =
        'https://shopz-8507b-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$authToken';

    try {
      final response =
          await http.put(Uri.parse(url), body: json.encode(isFavorite));
      result = isFavorite ? 'product liked' : 'product unliked';
      if (response.statusCode >= 400) {
        isFavorite = oldValue;
        notifyListeners();
      }
    } catch (e) {
      isFavorite = oldValue;
      notifyListeners();
    }

    // print('result  :$result');
    notifyListeners();

    return result;
  }
}
