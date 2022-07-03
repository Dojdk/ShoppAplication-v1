import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/screens/editscreen.dart';

import '../widgets/drawer.dart';
import '../widgets/manageitem.dart';

import '../providers/product.dart';

class ManageScreen extends StatelessWidget {
  static const routeName = '/manage-screen';
  const ManageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final neededProd = Provider.of<ProductList>(context, );
    return Scaffold(
        appBar: AppBar(
          title: const Text('Manage Products'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(EditScreen.routeName,);
                },
                icon: const Icon(Icons.add))
          ],
        ),
        drawer: const Drawer(
          child: DrawerItem(),
        ),
        body: ListView.builder(
            itemCount: neededProd.item.length,
            itemBuilder: (context, i) {
              return Column(
                children: [
                  ManageItem(
                      id: neededProd.item[i].id,
                      title: neededProd.item[i].title,
                      url: neededProd.item[i].imageUrl),
                  const Divider(),
                ],
              );
            }));
  }
}
