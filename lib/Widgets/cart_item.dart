import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/cart.dart';

class CartSingleItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final String title;
  final int quantity;

  const CartSingleItem(
      this.id, this.productId, this.price, this.title, this.quantity,
      {super.key});

  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<Cart>(context, listen: false);
    return Dismissible(
      key: ValueKey(productId),
      background: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 15,
        ),
        alignment: Alignment.centerRight,
        color: Theme.of(context).errorColor,
        child: const Padding(
          padding: EdgeInsets.all(15.0),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: const Text('Are you sure ? '),
                  content: const Text('Do you want to remove from cart ?'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: const Text('NO')),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: const Text('YES')),
                  ],
                ));
      },
      onDismissed: ((direction) {
        cartData.deleteItem(productId);
      }),
      child: Card(
        margin: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 15,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    FittedBox(child: Text(price.toStringAsFixed(2).toString())),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total : ${price * quantity}'),
            trailing: Text(
              '${quantity.toString()} x',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
            ),
          ),
        ),
      ),
    );
  }
}
