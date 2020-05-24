import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopify/providers/auth.dart';
import 'package:shopify/providers/cart.dart';
import 'package:shopify/providers/product.dart';
import 'package:shopify/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: product.id);
          },
          child: Hero(
            tag: product.id,
                      child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: GridTileBar(
          leading: Consumer<Product>(
            builder: (ctx, product, child) => IconButton(
                icon: Icon(product.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border),
                color: Theme.of(context).accentColor,
                onPressed: () async {
                  await product.toggleFavoriteStatus(auth.token,auth.userId);
                }),
          ),
          backgroundColor: Colors.black87,
          title: Text(product.title),
          trailing: Consumer<Cart>(
            builder: (ctx, cart, child) => IconButton(
              icon: Icon(cart.isInCart(product.id)
                  ? Icons.shopping_cart
                  : Icons.add_shopping_cart),
              color: Theme.of(context).accentColor,
              onPressed: () {
                cart.addItemToCart(product.id, product.title, product.price);
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('Item added to cart'),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cart.removeThisItem(product.id);
                    },
                  ),
                ));
              },
            ),
          ),
        ),
      ),
    );
  }
}
