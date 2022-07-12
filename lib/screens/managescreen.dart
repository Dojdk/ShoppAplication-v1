import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/screens/editscreen.dart';

import '../widgets/drawer.dart';
import '../widgets/manageitem.dart';

import '../providers/product.dart';

class ManageScreen extends StatelessWidget {
  static const routeName = '/manage-screen';
  const ManageScreen({Key? key}) : super(key: key);
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ProductList>(context, listen: false).getData(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Manage Products'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    EditScreen.routeName,
                  );
                },
                icon: const Icon(Icons.add))
          ],
        ),
        drawer: const Drawer(
          child: DrawerItem(),
        ),
        body: FutureBuilder(
          future: _refreshProducts(context),
          builder: (context, dataSnap) {
            return dataSnap.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Consumer<ProductList>(
                    builder: (context, neededProd, child) => ListView.builder(
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
          },
        ));
  }
}
