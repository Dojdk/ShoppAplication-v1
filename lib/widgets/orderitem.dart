import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/order.dart';

class OrderItem extends StatefulWidget {
  final Order order;
  const OrderItem({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.order.amount.toStringAsFixed(2)}'),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime),
            ),
            trailing: _isExpanded
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        _isExpanded = false;
                      });
                    },
                    icon: const Icon(Icons.expand_less))
                : IconButton(
                    onPressed: () {
                      setState(() {
                        _isExpanded = true;
                      });
                    },
                    icon: const Icon(Icons.expand_more)),
          ),
          if (_isExpanded)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              height: min(widget.order.products.length * 20.0 + 10, 100),
              child: ListView(
                children: widget.order.products
                    .map((prod) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              prod.title,
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            Text('${prod.quantity}x'),
                            Text('\$${prod.price}'),
                          ],
                        ))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}
