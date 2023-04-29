import 'dart:convert';

import 'package:flutter/Material.dart';
import '../provider/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Order with ChangeNotifier {
  List<OrderItem> _orderList = [];
  final String authToken;
  final String userId;
  Order(this.authToken, this.userId, this._orderList);

  

  List<OrderItem> get orderList {
    return [..._orderList];
  }

  Future<void> fetchingDataOrder() async {
    final url =
        'https://shopz-8507b-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    final response = await http.get(Uri.parse(url));

    final List<OrderItem> loadedOrders = [];

    final extractData = json.decode(response.body) as Map<String, dynamic>;

    if (extractData == null) {
      return;
    }
    extractData.forEach((orderiId, orderData) {
      loadedOrders.add(OrderItem(
          id: orderiId,
          amount: orderData['amount'],
          products: (orderData['products'] as List<dynamic>).map((items) {
            return CartItem(
                id: items['id'],
                title: items['title'],
                price: items['price'],
                quantity: items['quantity']);
          }).toList(),
          dateTime: DateTime.parse(orderData['dateTime'])));
    });

    _orderList = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {

    try{




  final url =
        'https://shopz-8507b-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    final timeStamp = DateTime.now();

    final response = await http.post(Uri.parse(url),
        body: json.encode({
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'products': cartProducts
              .map((cartprd) => {
                    'id': cartprd.id,
                    'title': cartprd.title,
                    'price': cartprd.price,
                    'quantity': cartprd.quantity,
                  })
              .toList()
        }));

      final data=json.decode(response.body);
      print(data);

    _orderList.insert(
      0,
      OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          dateTime: timeStamp,
          products: cartProducts),
    );
    notifyListeners();



    }catch(err){


      print('Error found  : $err');

    }


  
  }
}
