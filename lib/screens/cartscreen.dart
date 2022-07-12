import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/cartitem.dart';
import '../widgets/cartbutton.dart';
import '../providers/cart.dart';


class CartScreen extends StatelessWidget {
  static const routeName = '/cart-screen';
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartList>(
      context,
    );
    return Scaffold(
        appBar: AppBar(title: const Text('Cart')),
        body: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            Card(
              child: Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  const Spacer(),
                  Text(
                    (cart.totalAmount).toStringAsFixed(2),
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  CartButton(cart:cart),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: cart.count,
                itemBuilder: (BuildContext context, int i) {
                  return CartItem(
                      count: cart.item.values.toList()[i].quantity,
                      id: cart.item.values.toList()[i].id,
                      price: cart.item.values.toList()[i].price,
                      productId: cart.item.keys.toList()[i],
                      title: cart.item.values.toList()[i].title);
                },
              ),
            ),
          ],
        ));
  }
}
