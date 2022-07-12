import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


import '../models/exception.dart';

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
  Future<void> favoritetapped(String token,String userID) async {
    final oldstatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = Uri.parse(
        'https://shopaplication-f3a16-default-rtdb.europe-west1.firebasedatabase.app/UserFavorites/$userID/$id.json?auth=$token');
    final response =
        await http.put(url, body: jsonEncode(isFavorite));
    if (response.statusCode >= 400) {
      isFavorite = oldstatus;
      notifyListeners();
      throw HttpException('Can\'t update product');
    }
  }
}

class ProductList with ChangeNotifier {

  
  late String authToken;
  late String userID;

  void update(token,id){
    authToken=token;
    userID=id;
  }

  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  // void notification(){
  //   notifyListeners();
  // }


  Future<void> getData([bool filter=false]) async {
    final continuestate= filter?'orderBy="creatorId"&equalTo="$userID"':'';
    final url = Uri.parse(
        'https://shopaplication-f3a16-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$authToken&$continuestate');

    final response = await http.get(url);
    final extractedData = jsonDecode(response.body) as Map<String, dynamic>;
    final favurl = Uri.parse(
        'https://shopaplication-f3a16-default-rtdb.europe-west1.firebasedatabase.app/UserFavorites/$userID.json?auth=$authToken');
    final favResponse=await http.get(favurl);
    final favData=jsonDecode(favResponse.body);
    final List<Product> listofproducts = [];
    extractedData.forEach((key, value) {
      listofproducts.add(Product(
          id: key,
          title: value['title'],
          description: value['description'],
          price: value['price'],
          imageUrl: value['imageUrl'],
          isFavorite: favData==null?false: favData[key]?? false));
    });
    _items = listofproducts;
    notifyListeners();
  }

  Future<void> addItem(Product prod) async {
    final url = Uri.parse(
        'https://shopaplication-f3a16-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$authToken');
    try {
      final response = await http.post(url,
          body: jsonEncode({
            'title': prod.title,
            'description': prod.description,
            'price': prod.price,
            'imageUrl': prod.imageUrl,
            'creatorId': userID,
          }));
      _items.add(Product(
          id: jsonDecode(response.body)['name'],
          title: prod.title,
          description: prod.description,
          price: prod.price,
          imageUrl: prod.imageUrl));
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateProduct(Product prod) async {
    final productIndex = _items.indexWhere((element) => element.id == prod.id);
    if (productIndex >= 0) {
      final url = Uri.parse(
          'https://shopaplication-f3a16-default-rtdb.europe-west1.firebasedatabase.app/products/${prod.id}.json?auth=$authToken');
      final response = await http.patch(url,
          body: jsonEncode({
            'title': prod.title,
            'description': prod.description,
            'price': prod.price,
            'imageUrl': prod.imageUrl,
          }));
      if (response.statusCode >= 400) {
        throw HttpException('Can\'t update product');
      }
      _items[productIndex] = prod;
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

  Future<void> deleteItem(String productId) async {
    final url = Uri.parse(
        'https://shopaplication-f3a16-default-rtdb.europe-west1.firebasedatabase.app/products/$productId.json?auth=$authToken');
    final productIndex =
        _items.indexWhere((element) => element.id == productId);
    var product = _items[productIndex];
    _items.removeWhere(
      (element) => element.id == productId,
    );
    notifyListeners();
    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items.insert(productIndex, product);
      notifyListeners();
      throw HttpException('Can\'t delete product');
    }
    product.dispose();
  }
}
