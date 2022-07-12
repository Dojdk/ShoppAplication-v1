import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final String title;
  final int count;

  const CartItem({
    Key? key,
    required this.count,
    required this.id,
    required this.price,
    required this.productId,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(id),
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 10),
        child: const Icon(
          Icons.delete,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<CartList>(context, listen: false).deleteItem(productId);
      },
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: FittedBox(child: Text('$price')),
            ),
          ),
          title: Text(title),
          subtitle: Text('Price: ${(price * count).toStringAsFixed(2)}'),
          trailing: SizedBox(
            width: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton( 
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    Provider.of<CartList>(context, listen: false)
                        .deleteoneItem(productId);
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.black,
                        duration: Duration(seconds: 1),
                        content: Text(
                          'Swap to delte all',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.arrow_left),
                ),
                Text(
                  '$count X',
                  style: const TextStyle(
                    fontSize: 17,
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    Provider.of<CartList>(context, listen: false)
                        .increaseQuant(productId);
                  },
                  icon: const Icon(Icons.arrow_right),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
