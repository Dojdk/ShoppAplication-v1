import 'package:flutter/foundation.dart';

import 'cart.dart';

class Order {
  final String id;
  final double amount;
  final List<Cart> products;
  final DateTime dateTime;

  Order({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class OrderList with ChangeNotifier {
  final List<Order> _list = [];

  List<Order> get list {
    return [..._list];
  }

  void addOrder(List<Cart> cartProducts, double total) {
    _list.insert(
      0,
      Order(
        id: DateTime.now().toString(),
        amount: total,
        dateTime: DateTime.now(),
        products: cartProducts,
      ),
    );
    notifyListeners();
  }
}
