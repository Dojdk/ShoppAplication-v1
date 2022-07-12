import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/order.dart';

class CartButton extends StatefulWidget {
  final dynamic cart;
  const CartButton({Key? key, required this.cart}) : super(key: key);

  @override
  State<CartButton> createState() => _CartButtonState();
}

class _CartButtonState extends State<CartButton> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
            ? null
            : () async {
                setState(() {
                  _isLoading = true;
                });
                try {
                  await Provider.of<OrderList>(context, listen: false).addOrder(
                      widget.cart.item.values.toList(),
                      widget.cart.totalAmount);
                } catch (error) {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    backgroundColor: Colors.black,
                    duration: Duration(seconds: 1),
                    content: Text(
                      'Error ocured',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ));
                  return;
                } finally {
                  setState(() {
                    _isLoading = false;
                  });
                }

                widget.cart.clear();
              },
        child: _isLoading
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : const Text('ORDER NOW'));
  }
}
