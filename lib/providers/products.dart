import "package:flutter/foundation.dart";

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double amount;
  final String imageUrl;
  bool isFaviorate;

  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.amount,
      required this.imageUrl,
      this.isFaviorate = false});

  void toggleFavStatus() {
    isFaviorate = !isFaviorate;
    notifyListeners();
  }
}
