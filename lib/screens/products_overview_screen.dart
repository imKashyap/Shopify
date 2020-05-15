import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopify/providers/cart.dart';
import 'package:shopify/providers/product.dart';
import 'package:shopify/providers/products.dart';
import 'package:shopify/screens/cart_screen.dart';
import 'package:shopify/widgets/app_drawer.dart';
import 'package:shopify/widgets/badge.dart.dart';
import 'package:shopify/widgets/product_item.dart';

import '../providers/product.dart';

enum filterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  static const String routeName = 'ProductsOverviewScreen';

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool showFavs = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopify'),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (filterOptions selectedValue) {
              setState(() {
                if (selectedValue == filterOptions.Favorites) {
                  showFavs = true;
                }
                else {
                  showFavs = false;
                }
              });
            },
            itemBuilder: (BuildContext context) =>
            [
              PopupMenuItem(
                child: Text('Show Favorites',),
                value: filterOptions.Favorites,),
              PopupMenuItem(child: Text('Show All'),
                value: filterOptions.All,)
            ],
          ),
          Consumer<Cart>(
            builder: (BuildContext context, Cart value, Widget ch) =>
                IconButton(icon: Badge(
                  value:value.itemOnCartCount.toString(),
                  child: ch,
                ),
                  onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                  },),
            child: Icon(Icons.shopping_cart),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body:
      ProductGrid
        (
          showFavs
      )
      ,
    );
  }
}

class ProductGrid extends StatelessWidget {
  final bool showFavs;

  const ProductGrid(this.showFavs);

  @override
  Widget build(BuildContext context) {
    final Products products = Provider.of<Products>(context);
    final List<Product> visibleProducts = !showFavs ? products.items : products
        .favoriteItems;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
        childAspectRatio: 1.5,
      ),
      itemBuilder: (ctx, index) =>
      ChangeNotifierProvider<Product>.value(
        value: visibleProducts[index],
        child: ProductItem(),
      ),
      itemCount: visibleProducts.length,
    );
  }
}
