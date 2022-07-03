import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/product.dart';
import './providers/cart.dart';
import './providers/order.dart';

import './screens/mainpage.dart';
import './screens/productinfo.dart';
import './screens/cartscreen.dart';
import './screens/orderscreen.dart';
import './screens/managescreen.dart';
import './screens/editscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider(
        //   create: (_) => Product.empty(),
        // ),
        ChangeNotifierProvider(
          create: (_) => ProductList(),
        ),
        ChangeNotifierProvider(
          create: (_) => CartList(),
        ),
        ChangeNotifierProvider(
          create: (_) => OrderList(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Shop',
        theme: ThemeData(
          colorScheme: const ColorScheme.dark(),
          appBarTheme: const AppBarTheme(backgroundColor: Colors.black12),
          fontFamily: 'Poppins',
        ),
        routes: {
          '/': (context) => const MainPage(),
          ProductInfo.routeName: (context) => const ProductInfo(),
          CartScreen.routeName: (context) => const CartScreen(),
          OrderScreen.routeName: (context) => const OrderScreen(),
          ManageScreen.routeName:(context) => const ManageScreen(),
          EditScreen.routeName:(context) => const EditScreen(),
        },
      ),
    );
  }
}
