import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import './cart_screen.dart';
import '../widgets/app_drawer.dart';

enum Filteroption {
  Favorites,
  All,
}

class ProductOverView extends StatefulWidget {
  @override
  State<ProductOverView> createState() => _ProductOverViewState();
}

class _ProductOverViewState extends State<ProductOverView> {
  var _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (Filteroption selectedvalue) {
              setState(() {
                if (selectedvalue == Filteroption.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                  child: Text('Only Favorites'), value: Filteroption.Favorites),
              PopupMenuItem(child: Text('Show All'), value: Filteroption.All),
            ],
          ),
          Consumer<cart>(
            builder: (_, Cart, _2) => Badge(
              child: IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(cart_screen.routename);
                },
              ),
              value: Cart.itemCount.toString(),
              color: Colors.redAccent,
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: ProductsGrid(_showOnlyFavorites),
    );
  }
}
