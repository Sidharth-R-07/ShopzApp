import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/cart.dart';
import '../provider/order.dart';

class OrderButton extends StatefulWidget {
  const OrderButton({super.key});

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<Cart>(context);
    return TextButton(
        onPressed: cartData.totalSum <= 0 || isLoading == true
            ? null
            : () async {
                //click the button to process the order.

                setState(() {
                  isLoading = true;
                });

                await Provider.of<Order>(context, listen: false).addOrder(
                    cartData.items.values.toList(), cartData.totalSum);
                cartData.clearAll();
                setState(() {
                  isLoading = false;
                });
              },
        child: isLoading
            ? const CircularProgressIndicator()
            : Text(
                'ORDER NOW',
                style: TextStyle(color: Colors.red.shade600),
              ));
  }
}
