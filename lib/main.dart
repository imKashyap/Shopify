import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopify/providers/cart.dart';
import 'package:shopify/providers/orders.dart';
import 'package:shopify/providers/products.dart';
import 'package:shopify/screens/cart_screen.dart';
import 'package:shopify/screens/order_screen.dart';
import 'package:shopify/screens/product_detail_screen.dart';
import 'package:shopify/screens/products_overview_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Products>.value(value: Products()),
        ChangeNotifierProvider<Cart>.value(value: Cart()),
        ChangeNotifierProvider<Order>.value(value: Order()),
      ],
      child: MaterialApp(
        home: ProductsOverviewScreen(),
        theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.orange,
            fontFamily: 'Lato'),
        debugShowCheckedModeBanner: false,
        initialRoute: ProductsOverviewScreen.routeName,
        routes: {
          ProductsOverviewScreen.routeName: (ctx) => ProductsOverviewScreen(),
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrdersScreen.routeName: (ctx)=>OrdersScreen(),
        },
      ),
    );
  }
}
