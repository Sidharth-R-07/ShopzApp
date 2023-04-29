import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/order.dart';
import '../Widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final ordersData = Provider.of<Order>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: FutureBuilder(
        future: Provider.of<Order>(context, listen: false).fetchingDataOrder(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.error != null) {
              return AlertDialog(
                title: const Text('An error !'),
                content: const Text('Something went wrong. try again !'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('close'))
                ],
              );
            } else {
              return Consumer<Order>(
                builder: (context, ordersData, _) {
                  return ordersData == null
                      ? const Center(child: Text('No Orders yet !'))
                      : ListView.builder(
                          itemCount: ordersData.orderList.length,
                          itemBuilder: (context, index) =>
                              OrderItemTile(ordersData.orderList[index]),
                        );
                },
              );
            }
          }
        },
      ),
    );
  }
}
