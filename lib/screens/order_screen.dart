import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopify/widgets/app_drawer.dart';

import '../providers/orders.dart' show Order;
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static String routeName='OrdersScreen';
  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: orderData.orders.length,
        itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
      ),
    );
  }
}
