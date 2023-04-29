
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// import 'package:shopz/models/product_model.dart';
// import 'package:shopz/provider/products.dart';

// class DummyProduct with ChangeNotifier {
//   int? id;
//   String? title;
//   String? price;
//   String? description;
//   String? category;
//   String? image;
//   Rating? rating;

//   DummyProduct(
//       {this.id,
//       this.title,
//       this.price,
//       this.description,
//       this.category,
//       this.image,
//       this.rating});

//   DummyProduct.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     title = json['title'];
//     price = json['price'].toString();
//     description = json['description'];
//     category = json['category'];
//     image = json['image'];
//     rating = (json['rating'] != null ? Rating.fromJson(json['rating']) : null)!;
//   }

//   // static List<DummyProduct> dummyProdList = [];

// }

// class Rating {
//   String? rate;
//   int? count;

//   Rating({this.rate, this.count});

//   Rating.fromJson(Map<String, dynamic> json) {
//     rate = json['rate'].toString();
//     count = json['count'];
//   }
// }
