import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopify/widgets/app_drawer.dart';

import '../providers/orders.dart' show Order;
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static String routeName = 'OrdersScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
          future:
              Provider.of<Order>(context, listen: false).fetchAndSetProduct(),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting)
              return Center(
                child: CircularProgressIndicator(),
              );
            else {
              if (dataSnapshot.error == null) {
                return Consumer<Order>(
                  builder: (c, orderData, child) {
                    return ListView.builder(
                      itemCount: orderData.orders.length,
                      itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
                    );
                  },
                );
              } else {
                return Center(
                  child: Text('An error Occurred!'),
                );
              }
            }
          }),
    );
  }
}
