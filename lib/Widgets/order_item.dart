import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'dart:math';

import '../provider/order.dart';

class OrderItemTile extends StatefulWidget {
  final OrderItem order;
  const OrderItemTile(this.order, {super.key});

  @override
  State<OrderItemTile> createState() => _OrderItemTileState();
}

class _OrderItemTileState extends State<OrderItemTile> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('Total: ${widget.order.amount.toStringAsFixed(2)}'),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime),
            ),
            trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  //show more detailse on yours order.

                  setState(() {
                    _expanded = !_expanded;
                  });
                }),
          ),
          _expanded
              ? Container(
                  height: min(widget.order.products.length * 50 + 10, 300),
                  width: double.infinity,
                  color: Colors.grey.shade100,
                  child: ListView(
                    children: widget.order.products
                        .map((prod) => Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width: 250,
                                    child: Text(
                                      prod.title,
                                      style:
                                          Theme.of(context).textTheme.bodyMedium,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                  Text(
                                    '${prod.quantity} x ${prod.price} Rs',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  )
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
