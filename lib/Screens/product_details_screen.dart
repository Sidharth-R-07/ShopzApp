import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import '../models/product_model.dart';
import '../provider/auth.dart';
import '../provider/cart.dart';
import '../theme/theme.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int itemCount = 1;
  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<Auth>(context, listen: false);
    final cartData = Provider.of<Cart>(context, listen: false);

    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            ChangeNotifierProvider<Product>.value(
              value: widget.product,
              child: SliverAppBar(
                automaticallyImplyLeading: false,
                leading: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        size: 35,
                        color: Colors.grey.shade700,
                      )),
                ),
                pinned: true,
                // backgroundColor:,
                expandedHeight: 400,
                flexibleSpace: FlexibleSpaceBar(
                  title: Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.50),
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(25),
                            bottomLeft: Radius.circular(25))),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    height: 50,
                    // width: double.infinity/2,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Text(
                            widget.product.title!,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(color: Colors.white),
                            maxLines: 2,
                            textScaleFactor: ScaleSize.textScaleFactor(context),
                          ),
                        ),
                        Consumer<Product>(
                          builder: (context, value, _) => IconButton(
                            onPressed: () {
                              value.togleisFavoriteStatus(
                                  authData.token!, authData.userId!);
                              Toast.show(
                                value.isFavorite
                                    ? 'item liked'
                                    : 'item unliked',
                                duration: 3,
                                gravity: Toast.bottom,
                              );
                            },
                            icon: value.isFavorite
                                ? const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                    size: 28,
                                  )
                                : const Icon(
                                    Icons.favorite_border,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  background: Container(
                    color: Colors.white,
                    child: Hero(
                      tag: widget.product.id!,
                      child: Image.network(
                        widget.product.imageUrl!,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Price :',
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                letterSpacing: .5),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                (widget.product.price! + 100).toString(),
                                style: const TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    decorationColor: Colors.red,
                                    decorationThickness: 2,
                                    fontSize: 12,
                                    color: Colors.grey),
                              ),
                              Text(widget.product.price!.toStringAsFixed(2),
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: .5)),
                              const Text(
                                '25% Discount Added',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10),
                              ),
                              const Text(
                                '+ 45(Delivery Charge included)',
                                style: TextStyle(
                                    color: Colors.grey,
                                    letterSpacing: .5,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        'Product Details',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5),
                      ),
                      const Divider(
                        thickness: .5,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.product.description!,
                        style: const TextStyle(
                            fontSize: 15,
                            letterSpacing: .5,
                            fontWeight: FontWeight.w400),
                        textScaleFactor: ScaleSize.textScaleFactor(context),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black87,
        tooltip: 'add to cart!',
        onPressed: () {
          cartData.addItem(
            widget.product.id!,
            widget.product.title!,
            widget.product.price!,
          );

          Toast.show(
            'Added Item to cart !',
            duration: 3,
            gravity: Toast.bottom,
          );
        },
        child: const Icon(Icons.add_shopping_cart),
      ),
    );
  }
}
