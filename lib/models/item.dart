import 'dart:typed_data';

class Item {
  String name;
  String category;
  double price;
  String description;
  String imageUrl;
  int quantity;
  Item({
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.quantity
  });
    Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'price': price,
      'description': description,
      'imageUrl': imageUrl,
      'quantity': quantity,
    };
  }
}

List<Item> allItems = [];
