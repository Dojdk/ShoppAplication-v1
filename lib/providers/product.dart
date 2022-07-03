import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });
  // Product.empty({this.id='',this.description='',this.imageUrl='',this.isFavorite=false,this.price=0,this.title=''});
  void favoritetapped() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}

class ProductList with ChangeNotifier {
  final List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];
  // void notification(){
  //   notifyListeners();
  // }
  void addItem(Product prod) {
    _items.add(Product(
        id: DateTime.now().toString(),
        title: prod.title,
        description: prod.description,
        price: prod.price,
        imageUrl: prod.imageUrl));
        notifyListeners();
  }
  void updateProduct(Product prod){
    final productIndex=_items.indexWhere((element) => element.id==prod.id);
    if(productIndex>=0){
      _items[productIndex]=prod;
      notifyListeners();
    }
  }

  List<Product> get item {
    return [..._items];
  }

  List<Product> get favoriteitem {
    return _items.where((element) => element.isFavorite).toList();
  }

  Product byId(id) {
    return _items.firstWhere((element) => element.id == id);
  }

  void deleteItem(String productId) {
    _items.removeWhere(
      (element) => element.id == productId,
    );
    notifyListeners();
  }
}
