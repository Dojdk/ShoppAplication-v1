import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/order.dart';

import '../widgets/drawer.dart';
import '../widgets/orderitem.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/order-screen';
  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final order = Provider.of<OrderList>(context);
    return Scaffold(
      drawer: const Drawer(
        child: DrawerItem(),
      ),
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: ListView.builder(itemCount: order.list.length, itemBuilder: (context,i) {
        return OrderItem(order: order.list[i]);
      }),
    );
  }
}
