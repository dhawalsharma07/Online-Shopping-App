import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../main.dart';
import '../widgets/cart_item.dart' as ci;
import '../providers/orders.dart';

class cart_screen extends StatelessWidget {
  static const routename = '/cart';
  @override
  Widget build(BuildContext context) {
    final Carts = Provider.of<cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total Items',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${Carts.totalamt.toStringAsFixed(2)}',
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  FlatButton(
                    child: Text('ORDER NOW'),
                    onPressed: () {
                      Provider.of<Orders>(context, listen: false).addOrder(
                        Carts.items.values.toList(),
                        Carts.totalamt,
                      );
                      Carts.clearcart();
                    },
                    textColor: Theme.of(context).primaryColor,
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: Carts.itemCount,
              itemBuilder: (ctx, i) => ci.CartItem(
                Carts.items.values.toList()[i].id,
                Carts.items.keys.toList()[i],
                Carts.items.values.toList()[i].price,
                Carts.items.values.toList()[i].quantity,
                Carts.items.values.toList()[i].title,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
