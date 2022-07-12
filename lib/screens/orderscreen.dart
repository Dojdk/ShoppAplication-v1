import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/order.dart';

import '../widgets/drawer.dart';
import '../widgets/orderitem.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/order-screen';
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late Future _ordersFuture;
  Future _obtainOrder(){
    return Provider.of<OrderList>(context, listen: false).getData();
  }

  @override
  void initState() {
    _ordersFuture=_obtainOrder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const Drawer(
          child: DrawerItem(),
        ),
        appBar: AppBar(
          title: const Text('Orders'),
        ),
        body: FutureBuilder(
          future: _ordersFuture,
          builder: (context, dataSnap) {
            if (dataSnap.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (dataSnap.error != null) {
              return const Center(child: Text('I think we have error there.Try after some time'),);
            }
            return Consumer<OrderList>(
                builder: (ctx, order, _) => ListView.builder(
                    itemCount: order.list.length,
                    itemBuilder: (context, i) {
                      return OrderItem(order: order.list[i]);
                    }));
          },
        ));
  }
}
