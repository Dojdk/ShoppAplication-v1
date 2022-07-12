import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapplication/screens/mainpage.dart';

import './providers/product.dart';
import './providers/cart.dart';
import './providers/order.dart';
import './providers/auth.dart';

// import './screens/justscreen.dart';
import './screens/authsreen.dart';
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
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductList>(
          create: (context) => ProductList(),
          update: (_, auth, previousprod) =>
              previousprod!..update(auth.token, auth.userId),
        ),
        ChangeNotifierProvider(
          create: (_) => CartList(),
        ),
        ChangeNotifierProxyProvider<Auth, OrderList>(
          create: (context) => OrderList(),
          update: (_, auth, previousorder) =>
              previousorder!..update(auth.token, auth.userId),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Shop',
          theme: ThemeData(
            colorScheme: const ColorScheme.dark(),
            appBarTheme: const AppBarTheme(backgroundColor: Colors.black12),
            fontFamily: 'Poppins',
          ),
          home: auth.isAuth
              ? const MainPage()
              // : FutureBuilder(
              //     future: auth.tryautologin(),
              //     builder: (context, dataSnap) =>
              //         dataSnap.connectionState == ConnectionState.waiting
              //             ? const JustScreen()
              : const AuthScreen(),
          routes: {
            ProductInfo.routeName: (context) => const ProductInfo(),
            CartScreen.routeName: (context) => const CartScreen(),
            OrderScreen.routeName: (context) => const OrderScreen(),
            ManageScreen.routeName: (context) => const ManageScreen(),
            EditScreen.routeName: (context) => const EditScreen(),
          },
        ),
      ),
    );
  }
}
