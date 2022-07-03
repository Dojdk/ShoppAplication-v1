import 'package:flutter/foundation.dart';

class Cart {
  final String id;
  final String title;
  final int quantity;
  final double price;

  Cart(
      {required this.id,
      required this.price,
      required this.quantity,
      required this.title});
}

class CartList with ChangeNotifier {
  int idcount = 0;
  final Map<String, Cart> _items = {};

  Map<String, Cart> get item {
    return {..._items};
  }

  int get count {
    return _items.length;
  }

  int get overallcount {
    var count = 0;
    _items.forEach((key, cartItem) {
      count += cartItem.quantity;
    });
    return count;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void increaseQuant(String productId) {
    _items.update(
        productId,
        (value) => Cart(
            id: value.id,
            price: value.price,
            quantity: value.quantity + 1,
            title: value.title));
    notifyListeners();
  }

  void addItem(
    String productId,
    double price,
    String title,
  ) {
    if (_items.containsKey(productId)) {
      // change quantity...
      _items.update(
        productId,
        (existingCartItem) => Cart(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => Cart(
          id: idcount.toString(),
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }
    idcount++;
    notifyListeners();
  }

  void deleteoneItem(keyId) {
    _items.update(
      keyId,
      (existingCartItem) => Cart(
        id: existingCartItem.id,
        title: existingCartItem.title,
        price: existingCartItem.price,
        quantity: existingCartItem.quantity - 1,
      ),
    );
    if (_items[keyId]!.quantity == 0) _items.remove(keyId);
    notifyListeners();
  }

  void deleteItem(keyId) {
    _items.remove(keyId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
