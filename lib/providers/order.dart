import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

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
  late String authToken;
  late String userID;

  void update(token, id) {
    authToken = token;
    userID = id;
  }

  List<Order> _list = [];

  List<Order> get list {
    return [..._list];
  }

  Future<void> getData() async {
    final url = Uri.parse(
        'https://shopaplication-f3a16-default-rtdb.europe-west1.firebasedatabase.app/orders/$userID.json?auth=$authToken');

    final response = await http.get(url);
    final extractedData = jsonDecode(response.body) as Map<String, dynamic>;
    if (extractedData.isEmpty) return;
    final List<Order> listofproducts = [];
    extractedData.forEach((key, value) {
      listofproducts.add(Order(
          id: key,
          amount: value['amount'],
          products: (value['products'] as List<dynamic>).map((item) {
            return Cart(
                id: item['id'],
                price: item['price'],
                quantity: item['quantity'],
                title: item['title']);
          }).toList(),
          dateTime: DateTime.parse(value['dateTime'])));
    });
    _list = listofproducts;
    notifyListeners();
  }

  Future<void> addOrder(List<Cart> cartProducts, double total) async {
    final url = Uri.parse(
        'https://shopaplication-f3a16-default-rtdb.europe-west1.firebasedatabase.app/orders/$userID.json?auth=$authToken');
    final time = DateTime.now();
    try {
      final response = await http.post(url,
          body: json.encode({
            'amount': total,
            'dateTime': time.toIso8601String(),
            'products': cartProducts
                .map((prod) => {
                      'id': prod.id,
                      'price': prod.price,
                      'quantity': prod.quantity,
                      'title': prod.title
                    })
                .toList(),
          }));
      _list.insert(
        0,
        Order(
          id: jsonDecode(response.body)['name'],
          amount: total,
          dateTime: time,
          products: cartProducts,
        ),
      );
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
