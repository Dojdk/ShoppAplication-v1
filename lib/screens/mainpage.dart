import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/cart.dart';
import '../widgets/productgrid.dart';
import '../widgets/drawer.dart';
import 'cartscreen.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool _firsinit = true;
  bool _isLoading = false;

  Future<void> reloadingScreen(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<ProductList>(context, listen: false).getData();
    setState(() {
      _isLoading = false;
    });
  }

  // Future<void> updateScreen(BuildContext context) async {
  //   await Provider.of<ProductList>(context, listen: false).getData();
  // }

  @override
  void didChangeDependencies() {
    if (_firsinit) {
      reloadingScreen(context);
    }
    _firsinit = false;
    super.didChangeDependencies();
  }

  var showfavs = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(child: DrawerItem()),
      appBar: AppBar(
        title: const Text('Shop'),
        actions: [
          PopupMenuButton(
              onSelected: (value) {
                if (value == 0) {
                  setState(() {
                    showfavs = true;
                  });
                }
                if (value == 1) {
                  setState(() {
                    showfavs = false;
                  });
                }
              },
              itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: 0,
                      child: Text('Only Favorites'),
                    ),
                    PopupMenuItem(
                      value: 1,
                      child: Text('Show All'),
                    ),
                  ]),
          Consumer<CartList>(
            builder: (ctx, cart, _) => Badge(
              showBadge: cart.overallcount==0?false:true,
              badgeContent: Text('${cart.overallcount}'),
              toAnimate: false,
              position: const BadgePosition(bottom: 25, start: 23),
              child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(CartScreen.routeName);
                  },
                  icon: const Icon(Icons.shopping_cart_outlined)),
            ),
          ),
          const SizedBox(
            width: 15,
          )
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () => reloadingScreen(context),
              child: ProductGrid(showfavs: showfavs)),
    );
  }
}
