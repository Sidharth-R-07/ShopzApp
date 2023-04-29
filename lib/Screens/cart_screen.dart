import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Widgets/cart_item.dart';
import '../Widgets/order_button.dart';
import '../provider/cart.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<Cart>(
      context,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Cart',
          style: TextStyle(fontSize: 28),
        ),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Spacer(),
                  Chip(
                    label: Text(
                        'Rs ${cartData.totalSum.toStringAsFixed(2).toString()}'),
                    backgroundColor:
                        Theme.of(context).primaryColor.withOpacity(.40),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const OrderButton()
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: (context, index) {
              return CartSingleItem(
                cartData.items.values.toList()[index].id,
                cartData.items.keys.toList()[index],
                cartData.items.values.toList()[index].price,
                cartData.items.values.toList()[index].title,
                cartData.items.values.toList()[index].quantity,
              );
            },
            itemCount: cartData.itemCount,
          ))
        ],
      ),
    );
  }
}
