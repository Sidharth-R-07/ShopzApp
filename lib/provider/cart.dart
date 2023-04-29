import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final int quantity;
  CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalSum {
    double _total = 0.0;
    _items.forEach((key, cartItem) {
      _total += cartItem.price * cartItem.quantity;
    });
    return _total;
  }

  void addItem(String productid, String title, double price) {
    if (_items.containsKey(productid)) {
      //the Item is Already Exite.so change the quantity or update the Item.
      _items.update(
        productid,
        (exitingItem) => CartItem(
          id: exitingItem.id,
          title: exitingItem.title,
          price: exitingItem.price,
          quantity: exitingItem.quantity + 1,
        ),
      );
    } else {
      //Adding new item to the _items.
      _items.putIfAbsent(
        productid,
        () => CartItem(
          id: productid,
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void deleteItem(String productID) {
    _items.remove(productID);
    notifyListeners();
    print('Item delted');
  }

  void undoItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }

    if (_items[productId]!.quantity > 1) {
      _items.update(
          productId,
          (exiting) => CartItem(
              id: exiting.id,
              title: exiting.title,
              price: exiting.price,
              quantity: exiting.quantity - 1));
    } else {
      _items.remove(productId);
    }

    notifyListeners();
  }

  void clearAll() {
    _items = {};
    notifyListeners();
  }
}
