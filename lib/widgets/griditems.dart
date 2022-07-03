import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapplication/providers/cart.dart';

import '../providers/product.dart';
import '../screens/productinfo.dart';

class GridItem extends StatelessWidget {
  const GridItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final neededProduct = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<CartList>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushNamed(ProductInfo.routeName, arguments: neededProduct.id);
        },
        child: GridTile(
          footer: GridTileBar(
            backgroundColor: Colors.black54,
            leading: Consumer<Product>(
              builder: (ctx, product, _) => IconButton(
                onPressed: () {
                  product.favoritetapped();
                },
                icon: Icon(
                  Icons.favorite_border,
                  color: product.isFavorite ? Colors.red : null,
                ),
              ),
            ),
            title: FittedBox(
                fit: BoxFit.fill,
                child: Text(
                  neededProduct.title,
                )),
            trailing: IconButton(
              icon: const Icon(Icons.shopping_cart_outlined),
              onPressed: () {
                cart.addItem(
                    neededProduct.id, neededProduct.price, neededProduct.title);
              },
            ),
          ),
          child: Image.network(
            neededProduct.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
