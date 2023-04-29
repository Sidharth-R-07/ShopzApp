import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Exception/http_exception.dart';
import 'dart:convert';

import '../models/product_model.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
      Product(
        id: 'p1',
        title: 'Red Shirt',
        description: 'A red shirt - it is pretty red!',
        price: 100.99,
        imageUrl:
            'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
      ),
      Product(
        id: 'p2',
        title: 'Trousers',
        description: 'A nice pair of trousers.',
        price: 80.99,
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
      ),
      Product(
        id: 'p3',
        title: 'Yellow Scarf',
        description: 'Warm and cozy - exactly what you need for the winter.',
        price: 50.99,
        imageUrl:
            'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
      ),
      Product(
        id: 'p4',
        title: 'A Pan',
        description: 'Prepare any meal you want.',
        price: 199.99,
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
      ),
  ];

  String? authToken;
  final String userId;
  final String id;
  Products(this.authToken, this.userId, this.id, this._items);

  bool _isFav = false;
  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteChecking {
    if (_isFav) {
      return favoriteList;
    } else {
      return items;
    }
  }

  void isFavorite() {
    _isFav = true;
    notifyListeners();
    print('isFavortite functio');
  }

  void allProduct() {
    _isFav = false;
    notifyListeners();
  }

  List<Product> get favoriteList {
    return _items.where((element) => element.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> fetchingData([bool filterOpetion = false]) async {
    final filterString =
        filterOpetion ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://shopz-8507b-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString';
    final response = await http.get(Uri.parse(url));

    print(jsonDecode(response.body));
    final List<Product> loadedProduct = [];
    final extractedData = jsonDecode(response.body) as Map<String, dynamic>;

    url =
        'https://shopz-8507b-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken';

    final favoriteresponse = await http.get(Uri.parse(url));
    final favoriteData = jsonDecode(favoriteresponse.body);

    if (extractedData == null) {
      return;
    }
    extractedData.forEach((prodectId, product) {
      loadedProduct.insert(
          0,
          Product(
            id: prodectId,
            title: product['title'],
            description: product['description'],
            price: product['price'],
            imageUrl: product['imageUrl'],
            isFavorite:
                favoriteData == null ? false : favoriteData[prodectId] ?? false,
          ));
    });

    _items =[... loadedProduct];
    // notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://shopz-8507b-default-rtdb.firebaseio.com/products.json?auth=$authToken';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'dateTime': DateTime.now().toString(),
          'title': product.title,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'description': product.description,
          'creatorId': userId,
        }),
      );

      final newProduct = Product(
          id: json.decode(response.body)['name'],
          description: product.description,
          title: product.title,
          imageUrl: product.imageUrl,
          price: product.price);

      _items.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    final url =
        'https://shopz-8507b-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';

    if (prodIndex >= 0) {
      try {
        await http.patch(Uri.parse(url),
            body: jsonEncode({
              'title': newProduct.title,
              'price': newProduct.price,
              'description': newProduct.description,
              'imageUrl': newProduct.imageUrl,
            }));
      } catch (e) {
        print(e.toString());
      }

      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('....');
    }
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    // _items.removeWhere((prod) => prod.id == id);
    final url =
        'https://shopz-8507b-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';

    final productIndex = _items.indexWhere((prod) => prod.id == id);
    Product? existingProduct = _items[productIndex];

    _items.removeAt(productIndex);
    notifyListeners();

    final response = await http.delete(Uri.parse(url));

    if (response.statusCode >= 400) {
      _items.insert(productIndex, existingProduct);
      notifyListeners();
      throw HttpExceptions('Could not detete product.');
    }

    existingProduct = null;
    notifyListeners();
  }














//     getDummyProducts(BuildContext ctx) async {
//     final url = Uri.parse('https://fakestoreapi.com/products');

//     final respones = await http.get(url);
//     final fetchedData = json.decode(respones.body) as List<dynamic>;

//     print('dummmy 11111111111111');
// // print(fetchedData);

//     final prodList = fetchedData.map<DummyProduct>((prod) {
//       return DummyProduct.fromJson(prod);
//     }).toList();

//     print('dummmy 2222222222');
//     print(prodList);

//   final _products=  prodList
//         .map<Product>((e) {
//           final prod= Product(
//             id: e.id.toString(),
//             imageUrl: e.image,
//             description: e.description,
//             price: double.parse(e.price!),
//             isFavorite: false,
//             title: e.title);

//           addProduct(prod);

//             return prod;
//         })
//         .toList();

//     print('dummmy 333333333333');
//     _items=[..._products];
//     print('dummmy 4444444444');
//     print(_items);


//   }
}
