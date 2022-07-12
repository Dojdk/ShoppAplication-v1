import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';

class ProductInfo extends StatelessWidget {
  static const routeName='/product-info';
  const ProductInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prodId=ModalRoute.of(context)!.settings.arguments as String;
    final neededProd= Provider.of<ProductList>(context,listen: false).byId(prodId);
    return Scaffold(
      appBar: AppBar(title: Text(neededProd.title)),
      body: Column(children: [
        Image.network(neededProd.imageUrl),
        Text('${neededProd.price}'),
        Text(neededProd.description)
      ],),
    );
  }
}