import 'package:flutter/material.dart';
import 'package:mojatablica/Providers/auth_provider.dart';
import 'package:mojatablica/Screens/auth_screen.dart';
import 'package:mojatablica/helpers/custom_route.dart';
import 'package:provider/provider.dart';
import 'package:mojatablica/Models/constans.dart';
import 'package:mojatablica/Providers/order_provider.dart';
import 'package:mojatablica/Providers/products_provider.dart';
import 'package:mojatablica/Screens/addProduct_screen.dart';
import 'package:mojatablica/Screens/productlist_screen.dart';
import 'package:mojatablica/Screens/cart_screen.dart';
import 'package:mojatablica/Screens/myproducts_screen.dart';
import 'package:mojatablica/Screens/orders_screen.dart';
import 'Providers/cart_provider.dart';
import 'Screens/productdetail_screen.dart';
import 'Screens/productlist_screen.dart';
import 'Screens/cart_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => Auth()),
          ChangeNotifierProxyProvider<Auth, Products>(
            update: (context, auth, previous) => Products(
                auth.getToken != null ? auth.getToken as String : '',
                auth.getUserId != null ? auth.getUserId as String : '',
                previous == null ? [] : previous.items),
            create: (context) => Products('', '', []),
          ),
          ChangeNotifierProvider(create: (context) => CartItems()),
          ChangeNotifierProxyProvider<Auth, OrderItems>(
            update: (context, auth, previous) => OrderItems(
                auth.getToken != null ? auth.getToken as String : '',
                auth.getUserId != null ? auth.getUserId as String : '',
                previous == null ? [] : previous.gerOrders()),
            create: (context) => OrderItems('', '', []),
          )
        ],
        child: Consumer<Auth>(
          builder: (context, auth, _) => MaterialApp(
            theme: ThemeData(
                pageTransitionsTheme: PageTransitionsTheme(builders: {
                  TargetPlatform.android: CustomPageTransitionBuilder(),
                  TargetPlatform.iOS: CustomPageTransitionBuilder(),
                }),
                primaryColor: kPrimaryColor,
                backgroundColor: kBackgroundColor,
                scaffoldBackgroundColor: kBackgroundColor,
                secondaryHeaderColor: kSecondaryColor,
                cardColor: kPrimaryColor),
            home: auth.isToken
                ? SProductList()
                : FutureBuilder(
                    future: auth.checkAuthentication(),
                    builder: (context, snapshot) => snapshot.connectionState ==
                            ConnectionState.waiting
                        ? const Scaffold(body: Center(child: Text("Loading")))
                        : const AuthScreen(),
                  ),
            routes: {
              SProductList.routName: (ctx) => SProductList(),
              SCart.routName: (ctx) => SCart(),
              SProductDetail.routName: (ctx) => SProductDetail(),
              SOrderScreen.routName: (ctx) => SOrderScreen(),
              SMyProducts.routName: (ctx) => SMyProducts(),
              SAddProduct.routName: (ctx) => const SAddProduct(),
            },
          ),
        ));
  }
}
