import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopify/widgets/app_drawer.dart';

import '../providers/orders.dart' show Order;
import '../widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static String routeName = 'OrdersScreen';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool _isLoading=false;
  @override
  void initState() {
    Future.delayed(Duration.zero)
        .then((_) async{
          setState(() {
            _isLoading=true;
          });
      await Provider.of<Order>(context,listen: false).fetchAndSetProduct();
      setState(() {
        _isLoading=false;
      });
    } );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: _isLoading?Center(child: CircularProgressIndicator(),):ListView.builder(
        itemCount: orderData.orders.length,
        itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
      ),
    );
  }
}
