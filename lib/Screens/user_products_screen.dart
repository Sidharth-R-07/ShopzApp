import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Screens/edite_product_screen.dart';
import '../Widgets/app_drawer.dart';
import '../Widgets/user_product_item.dart';
import '../provider/products.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Your Products',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              onPressed: () {
                //add new product.

                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const EditeProductScreen(),
                ));
              },
              icon: const Icon(Icons.add),
            )
          ]),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future:
            Provider.of<Products>(context, listen: false).fetchingData(true),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Consumer<Products>(
                    builder: (context, productsData, _) => Padding(
                      padding: const EdgeInsets.all(10),
                      child: ListView.separated(
                          separatorBuilder: (context, index) => const Divider(),
                          itemCount: productsData.items.length,
                          itemBuilder: (context, index) {
                            final product = productsData.items[index];

                            if (product.id == null) {
                              return const SizedBox();
                            }

                            return UserProductItem(
                              title: product.title!,
                              imgUrl: product.imageUrl!,
                              id: product.id!,
                            );
                          }),
                    ),
                  ),
      ),
    );
  }
}
