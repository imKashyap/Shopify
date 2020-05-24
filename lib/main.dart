import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopify/providers/auth.dart';
import 'package:shopify/providers/cart.dart';
import 'package:shopify/providers/orders.dart';
import 'package:shopify/providers/products.dart';
import 'package:shopify/screens/auth_screen.dart';
import 'package:shopify/screens/cart_screen.dart';
import 'package:shopify/screens/edit_Product_Screen.dart';
import 'package:shopify/screens/order_screen.dart';
import 'package:shopify/screens/product_detail_screen.dart';
import 'package:shopify/screens/products_overview_screen.dart';
import 'package:shopify/screens/splash_screen.dart.dart';
import 'package:shopify/screens/user_products_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>.value(value: Auth()),
        ChangeNotifierProxyProvider<Auth,Products>(create: (context) => Products(), update: (BuildContext context, Auth auth, Products previous)=>previous..update(auth.token,auth.userId,previous.items==null?[]:previous.items)),
        ChangeNotifierProvider<Cart>.value(value: Cart()),
        ChangeNotifierProxyProvider<Auth,Order>(create:(context)=> Order(),update: (context, auth, previous) => previous..update(auth.token,auth.userId,previous.orders==null?[]:previous.orders),),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, child) {
          return MaterialApp(
            theme: ThemeData(
                primarySwatch: Colors.purple,
                accentColor: Colors.orange,
                fontFamily: 'Lato'),
            debugShowCheckedModeBanner: false,
            home: auth.isAuth?ProductsOverviewScreen():FutureBuilder(
              future: auth.tryAutoLogin(),
              builder: (context, snapshot) => snapshot.connectionState==ConnectionState.waiting?SplashScreen():AuthScreen(),
            ),
            // initialRoute: auth.isAuth? ProductsOverviewScreen.routeName:AuthScreen.routeName,
            routes: {
              ProductsOverviewScreen.routeName: (ctx) =>
                  ProductsOverviewScreen(),
              ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrdersScreen.routeName: (ctx) => OrdersScreen(),
              UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
              EditProductScreen.routeName: (ctx) => EditProductScreen(),
              AuthScreen.routeName: (ctx) => AuthScreen(),
            },
          );
        },
      ),
    );
  }
}
