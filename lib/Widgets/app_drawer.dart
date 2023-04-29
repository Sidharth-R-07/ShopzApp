import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopz/Screens/auth_screen.dart';

import '../Screens/home_screen.dart';
import '../Screens/orders_screen.dart';
import '../Screens/user_products_screen.dart';
import '../Screens/favorites_screen.dart';
import '../provider/auth.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: [
        AppBar(
          title: const Text(
            'Hello friend !',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500,
            ),
          ),
          automaticallyImplyLeading: false,
        ),
        const SizedBox(height: 20),
        ListTile(
          title: const Text(
            'Home',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: const Icon(Icons.home),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (ctx) => const HomeScreen()),
            );
          },
        ),
        const Divider(),
        ListTile(
          title: const Text(
            'Favorites',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: const Icon(Icons.favorite),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (ctx) => const FavoritesScreen()),
            );
          },
        ),
        const Divider(),
        ListTile(
          title: const Text(
            'Orders',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: const Icon(Icons.shop),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (ctx) => const OrdersScreen()),
            );
          },
        ),
        const Divider(),
        ListTile(
          title: const Text(
            'User Products',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: const Icon(Icons.edit_note_outlined),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (ctx) => const UserProductsScreen()),
            );
          },
        ),
        const Divider(),
        ListTile(
          title: const Text(
            'Logout',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: const Icon(Icons.exit_to_app),
          onTap: () {
            Navigator.of(context).pop();
            Provider.of<Auth>(context, listen: false)
                .logoutUser()
                .then((value) => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const AuthScreen(),
                    ),
                    (route) => false));
          },
        ),
      ],
    ));
  }
}
