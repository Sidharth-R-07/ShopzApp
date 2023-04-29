import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Screens/edite_product_screen.dart';
import '../provider/products.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imgUrl;

  const UserProductItem({
    super.key,
    required this.title,
    required this.imgUrl,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    final scaffoldmessanger = ScaffoldMessenger.of(context);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 26),
          ),
        ),
        leading: SizedBox(
          width: 50,
          height: 50,
          child: Image.network(
            imgUrl,
            fit: BoxFit.cover,
          ),
        ),
        trailing: SizedBox(
          width: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(EditeProductScreen.routName, arguments: id);
                },
                icon: const Icon(Icons.edit),
              ),
              IconButton(
                onPressed: () async {
                  try {
                    await Provider.of<Products>(context, listen: false)
                        .deleteProduct(id);
                  } catch (e) {
                    scaffoldmessanger.showSnackBar(
                        const SnackBar(content: Text('Deleting failed!')));
                  }
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.redAccent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
