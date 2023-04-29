import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../Screens/auth_screen.dart';
import '../Screens/edite_product_screen.dart';
import '../provider/cart.dart';
import '../provider/order.dart';
import '../provider/products.dart';

import './Screens/home_screen.dart';
import 'provider/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider(
        //   create: (context) => DummyProduct(),
        // ),
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (ctx) => Products('', '', '', []),
          update: (ctx, auth, prevaiouseProducts) => Products(
              auth.token,
              auth.userId == null ? '' : auth.userId!,
              prevaiouseProducts!.id,
              prevaiouseProducts == null ? [] : prevaiouseProducts.items),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Order>(
          create: (ctx) => Order('', '', []),
          update: (ctx, authData, previouseOrder) => Order(
              authData.token == null ? '' : authData.token!,
              authData.userId == null ? '' : authData.userId!,
              previouseOrder!.orderList == null
                  ? []
                  : previouseOrder.orderList),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          routes: {
            EditeProductScreen.routName: (context) =>
                const EditeProductScreen(),
          },
          debugShowCheckedModeBanner: false,
          title: 'SHOP APP',
          theme: ThemeData(
              primarySwatch: Colors.blueGrey,
              iconTheme: const IconThemeData(color: Colors.red),
              backgroundColor: Colors.white,
              appBarTheme:
                  AppBarTheme(backgroundColor: Colors.black.withOpacity(.80))),
          home: AnimatedSplashScreen(
            splash: SizedBox(
              width: double.infinity,
              height: 800,
              child: Lottie.asset('Asset/image/lottie/splash_lottie.json',
                  fit: BoxFit.cover),
            ),
            duration: 3500,
            splashTransition: SplashTransition.fadeTransition,
            backgroundColor: Colors.black,
            nextScreen: auth.isAuth
                ? const HomeScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authResult) =>
                        authResult.connectionState == ConnectionState.waiting
                            ? const Scaffold(
                                body: Center(
                                child: CircularProgressIndicator(),
                              ))
                            : AuthScreen(),
                  ),
          ),
        ),
      ),
    );
  }
}
