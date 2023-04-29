import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Screens/product_details_screen.dart';
import '../models/product_model.dart';
import '../provider/products.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:toast/toast.dart';
import '../provider/auth.dart';
import '../provider/cart.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = productsData.favoriteList;

    final cartData = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favorites',
          style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w400,
              letterSpacing: 1),
        ),
      ),
      body: SafeArea(
        child: products.isEmpty
            ? const Center(
                child: Text('No Favorites Products Now!'),
              )
            : MasonryGridView.count(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                crossAxisSpacing: 15,
                itemCount: products.length,
                mainAxisSpacing: 10,
                crossAxisCount: 2,
                itemBuilder: (context, index) {
                  final _product = products[index];
                  return ChangeNotifierProvider.value(
                    value: _product,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(
                                bottom: 10,
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(28),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.50),
                                        blurRadius: 5,
                                        spreadRadius: 1,
                                        offset: const Offset(1, 1))
                                  ]),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (ctx) => ProductDetailsScreen(
                                          product: _product)));
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(14.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(28),
                                        child: Hero(
                                          tag: _product.id!,
                                          child: Image.network(
                                            _product.imageUrl!,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                   Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, top: 8),
                                child: Text(
                                  _product.title!,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 5, top: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      '₹ ${_product.price!}',
                                      style: const TextStyle(
                                          fontSize: 18,
                                          letterSpacing: 1,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      textAlign: TextAlign.start,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      (_product.price! + 100).toString(),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(
                                          color: Colors.grey,
                                          decoration:
                                              TextDecoration.lineThrough,
                                          decorationColor: Colors.redAccent,
                                          decorationThickness: 2),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      onPressed: () {
                                        cartData.addItem(
                                          products[index].id!,
                                          products[index].title!,
                                          products[index].price!,
                                        );

                                        Toast.show(
                                          'Added Item to cart !',
                                          duration: 3,
                                          gravity: Toast.bottom,
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.add_shopping_cart_rounded,
                                        color: Colors.black,
                                        size: 26,
                                      ),
                                    ),]))
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                                right: 10,
                                top: 14,
                                child: Consumer<Product>(
                                  builder: (context, prod, _) => Container(
                                    height: 35,
                                    width: 35,
                                    decoration: const BoxDecoration(
                                        color: Colors.black,
                                        shape: BoxShape.circle),
                                    child: IconButton(
                                      onPressed: () {
                                        prod.togleisFavoriteStatus(
                                            authData.token!, authData.userId!);

                                        Toast.show(
                                          prod.isFavorite
                                              ? 'item liked'
                                              : 'item unliked',
                                          duration: 3,
                                          gravity: Toast.bottom,
                                        );
                                      },
                                      icon: prod.isFavorite
                                          ? const Icon(
                                              Icons.favorite,
                                              size: 18,
                                              color: Colors.red,
                                            )
                                          : const Icon(
                                              Icons.favorite,
                                              size: 18,
                                              color: Colors.white,
                                            ),
                                    ),
                                  ),
                                ))
                          ],
                        ),
                      ],
                    ),
                  );
                }),
      ),
    );
  }
}
