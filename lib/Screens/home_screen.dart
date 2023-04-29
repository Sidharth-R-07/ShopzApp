import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Screens/cart_screen.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../Widgets/app_drawer.dart';
import '../Widgets/badge.dart';

import '../Widgets/product_grid_view.dart';
import '../provider/cart.dart';
import 'package:toast/toast.dart';

import '../provider/products.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isInt = true;
  bool isLoading = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _refreshHome(BuildContext context) async {
    // await Provider.of<Products>(context, listen: false).fetchingData();
  }

  @override
  void didChangeDependencies() {
    if (isInt) {
      setState(() {
        isLoading = true;
      });
      Provider.of<Products>(context).fetchingData().then((_) {
        setState(() {
          isLoading = false;
        });
      });
    }
    isInt = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);

    final productData = Provider.of<Products>(context).items;
    // Provider.of<Products>(context).getDummyProducts(context,);

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.black38,
        drawer: const AppDrawer(),
        body: SafeArea(
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                _headerIconButton(Icons.menu, () {
                  _scaffoldKey.currentState!.openDrawer();
                }),
                Text(
                  'SHOPZ',
                  style: TextStyle(
                    color: Colors.grey.shade200,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      top: 20, left: 20, bottom: 15, right: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade500,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Consumer<Cart>(
                    builder: (context, cart, chd) => MyBadge(
                      value: cart.itemCount.toString(),
                      child: chd!,
                    ),
                    child: IconButton(
                        splashRadius: 5,
                        icon: const Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (ctx) => const CartScreen()),
                          );
                        }),
                  ),
                ),
              ]),
              isLoading
                  ? Center(
                      child: LoadingAnimationWidget.hexagonDots(
                        color: Colors.white70,
                        size: 50,
                      ),
                    )
                  : productData.isEmpty
                      ? const Center(
                          child: SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                            child: Image(
                              image: AssetImage(
                                  'Asset/image/product-not-found.jpg'),
                              fit: BoxFit.contain,
                            ),
                          ),
                        )
                      : Expanded(
                          child: RefreshIndicator(
                            onRefresh: () => _refreshHome(context),
                            child: Container(
                              // margin: const EdgeInsets.only(top: 80),
                              padding: const EdgeInsets.only(top: 5),
                              width: double.infinity,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(40),
                                    topRight: Radius.circular(40)),
                              ),
                              child: ProductGridView(),
                            ),
                          ),
                        ),
            ],
          ),
        ));
  }

  Container _headerIconButton(
    IconData icon,
    Function() onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20, bottom: 15, right: 20),
      decoration: BoxDecoration(
        color: Colors.grey.shade500,
        borderRadius: BorderRadius.circular(14),
      ),
      child: IconButton(
        splashRadius: 5,
        onPressed: onTap,
        icon: Icon(
          icon,
          color: Colors.white,
          size: 25,
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
