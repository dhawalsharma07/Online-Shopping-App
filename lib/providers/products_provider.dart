import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'products.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      amount: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      amount: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      amount: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      amount: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  var _showFavouritesOnly = false;
  List<Product> get items {
    // if (_showFavouritesOnly) {
    //   return items.where((prodItem) => prodItem.isFaviorate).toList();
    // }
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFaviorate).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  void addProduct(Product product) {
    var url = Uri.parse(
        'https://online-shopping-app-90845-default-rtdb.firebaseio.com/products.json');
    http
        .post(url as Uri,
            body: json.encode({
              'title': product.title,
              'description': product.description,
              'imageurl': product.imageUrl,
              'amount': product.amount,
              'isFavorite': product.isFaviorate,
            }))
        .then((response) {
      print(json.decode(response.body));
      final newProduct = Product(
        title: product.title,
        description: product.description,
        amount: product.amount,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      notifyListeners();
    });
  }

  void updateProduct(String id, Product prod) {
    final proind = _items.indexWhere((prod) => prod.id == id);
    if (proind >= 0) {
      _items[proind] = prod;
      notifyListeners();
    } else {
      print('...');
    }
  }

  void deleteProduct(String idx) {
    _items.removeWhere((prod) => prod.id == idx);
    notifyListeners();
  }
}
