import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopify/providers/orders.dart';
import 'package:shopify/widgets/cart_item.dart';

import '../providers/cart.dart' show Cart;

class CartScreen extends StatelessWidget {
  static const routeName = 'CartScreen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Theme.of(context).primaryTextTheme.title.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  Container(
                    child: OrderButton(cart: cart),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, i) => CartItem(
                cart.items.values.toList()[i].id,
                cart.items.keys.toList()[i],
                cart.items.values.toList()[i].price,
                cart.items.values.toList()[i].quantity,
                cart.items.values.toList()[i].title,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
 bool _isLoading=false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: _isLoading?CircularProgressIndicator():Text('ORDER NOW'),
      onPressed: widget.cart.totalAmount<=0?null:()async {
        final orderData=Provider.of<Order>(context,listen: false);
        setState(() {
          _isLoading=true;
        });
        await orderData.addOrders(widget.cart.items.values.toList(), widget.cart.totalAmount);
        setState(() {
          _isLoading=false;
        });
        widget.cart.clearCart();
      },
      textColor: Theme.of(context).primaryColor,
    );
  }
}
