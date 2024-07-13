// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:typed_data';

import 'package:cooperative_platform/main.dart';
import 'package:flutter/material.dart';
import 'package:cooperative_platform/models/item.dart'; // Assuming Item model is defined
import 'package:firebase_storage/firebase_storage.dart'; // Add the firebase_storage package if not added

class UserMarket extends StatefulWidget {
  @override
  _UserMarketState createState() => _UserMarketState();
}

class _UserMarketState extends State<UserMarket> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  Map<String, Uint8List?> imageCache = {};
  Item? selectedItem;

  @override
  void initState() {
    super.initState();
    _preloadImages();
  }

  Future<void> _preloadImages() async {
    for (Item item in allItems) {
      try {
        final url = await _getImageUrl(item.imageUrl);
        final data = await storage.ref().child(url).getData(10000000);
        setState(() {
          imageCache[item.imageUrl] = data;
        });
      } catch (e) {
        print('Error loading image for ${item.name}: $e');
      }
    }
  }

  Future<String> _getImageUrl(String imagePath) async {
    try {
      final ref = FirebaseStorage.instance.ref().child(imagePath);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Error fetching image URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: DefaultTabController(
        length: 2,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Scaffold(
            appBar: AppBar(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              bottom: TabBar(
                indicatorColor: Color.fromARGB(255, 61, 132, 168),
                labelColor: Color.fromARGB(255, 61, 132, 168),
                tabs: [
                  Tab(text: 'Community Marketplace'),
                  Tab(text: 'COOP Marketplace'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                _buildMarketView(), // Community Marketplace
                _buildMarketView(), // COOP Marketplace
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMarketView() {
    return ListView.builder(
      itemCount: allItems.length,
      itemBuilder: (context, index) {
        Item item = allItems[index];
        return Card(
          elevation: 5,
          surfaceTintColor: Colors.white,
          borderOnForeground: false,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0), side: BorderSide.none),
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ExpansionTile(
            title: Text(item.name),
            leading: _buildItemImage(item.imageUrl),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  margin: EdgeInsets.zero, // Remove default margin
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10.0), // Rounded corners
                  ),
                  elevation: 0, // No shadow
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 200,
                        width: 300,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: _buildItemImage(item.imageUrl),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Price: ${item.price} PHP',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        item.description,
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                        ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 20),
                                backgroundColor:
                                    Color.fromARGB(255, 61, 132, 168),
                                foregroundColor: Colors.white,
                                side: BorderSide.none,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(55.0),
                                  side: BorderSide.none,
                                ),
                              ),
                              onPressed: () {
                                bool itemExistsInCart = false;

                                // Check if item already exists in cart
                                for (Item cartItem
                                    in currentUser!.itemsInCart) {
                                  if (cartItem.name == item.name) {
                                    setState(() {
                                      cartItem
                                          .quantity++; // Increment quantity if item exists
                                    });
                                    itemExistsInCart = true;
                                    break;
                                  }
                                }

                                // If item does not exist in cart, add it with quantity 1
                                if (!itemExistsInCart) {
                                  setState(() {
                                    currentUser!.itemsInCart.add(
                                      Item(
                                        name: item.name,
                                        category: item.category,
                                        price: item.price,
                                        description: item.description,
                                        imageUrl: item.imageUrl,
                                        quantity: 1,
                                      ),
                                    );
                                  });
                                }
                              },
                              icon: Icon(Icons.add_shopping_cart_rounded,
                                  size: 20),
                              label: Text(
                                'Add to cart',
                                style: TextStyle(
                                  fontWeight: FontWeight.w200,
                                  fontSize: 11,
                                ),
                              ),
                            ),
  ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildItemImage(String imagePath) {
    Uint8List? imageBytes = imageCache[imagePath];
    if (imageBytes != null) {
      return Image.memory(
        imageBytes,
        height: 100,
        width: 100,
        fit: BoxFit.cover,
      );
    } else {
      return Container(
        height: 100,
        width: 100,
        color: Colors.grey[300],
        child: Center(child: CircularProgressIndicator()),
      );
    }
  }
}
