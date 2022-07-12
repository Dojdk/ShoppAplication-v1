import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

import '../screens/orderscreen.dart';
import '../screens/managescreen.dart';

class DrawerItem extends StatelessWidget {
  const DrawerItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          // decoration: BoxDecoration(color: Colors.black54),
          title: const Text('Hello my friend'),
          automaticallyImplyLeading: false,
        ),
        ListTile(
          leading: const Icon(Icons.shop_rounded),
          title: const Text('Shop'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.payment),
          title: const Text('Orders'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.edit),
          title: const Text('Manage Products'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(ManageScreen.routeName);
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.exit_to_app),
          title: const Text('Log Out'),
          onTap: () {
            Provider.of<Auth>(context,listen: false).logout();
          },
        ),
        const Divider(),
      ],
    );
  }
}
