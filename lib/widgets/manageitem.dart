import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';

import '../screens/editscreen.dart';

class ManageItem extends StatelessWidget {
  final String id;
  final String url;
  final String title;
  const ManageItem(
      {Key? key, required this.id, required this.title, required this.url})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(url),
      ),
      title: Text(title),
      trailing: SizedBox(
        width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(onPressed: () {
              Navigator.of(context).pushNamed(EditScreen.routeName,arguments: id);
            }, icon: const Icon(Icons.edit)),
            IconButton(
                onPressed: () {
                  Provider.of<ProductList>(context, listen: false)
                      .deleteItem(id);
                },
                icon: const Icon(Icons.delete))
          ],
        ),
      ),
    );
  }
}
