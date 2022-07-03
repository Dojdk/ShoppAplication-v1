import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../widgets/griditems.dart';

class ProductGrid extends StatelessWidget {
  final bool showfavs;
  const ProductGrid({Key? key,required this.showfavs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProductList>(context,);
    // final forlisten= Provider.of<Product>(context);
    final product = showfavs ? productData.favoriteitem : productData.item;
    return Container(
      margin: const EdgeInsets.all(10),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 1,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemCount: product.length,
        itemBuilder: (context, index) => ChangeNotifierProvider.value(
          value: product[index],
          child: const GridItem(),
        ),
      ),
    );
  }
}
