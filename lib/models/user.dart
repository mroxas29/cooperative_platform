import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooperative_platform/admin_utils/services.dart';
import 'package:cooperative_platform/main.dart';
import 'package:cooperative_platform/models/item.dart';
import 'package:cooperative_platform/models/service.dart';

class user {
  String uid;
  String firstName;
  String lastName;
  String role;
  List<ServicesOffered> servicesOffered;
  List<Item> itemsSelling;
  String mobileNumber;
  String email;
  String address;
  List<Item> itemsInCart;
  List<Item> purchaseHistory;
  List<ServicesOffered> servicesHistory;
  
  user({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.servicesOffered,
    required this.itemsSelling,
    required this.mobileNumber,
    required this.email,
    required this.address,
    required this.itemsInCart,
    required this.purchaseHistory,
    required this.servicesHistory
  });
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'role': role,
      'servicesOffered': servicesOffered,
      'itemsSelling': itemsSelling,
      'mobileNumber': mobileNumber,
      'email': email,
      'address': address,
      'itemsInCart': itemsInCart,
      'purchaseHistory' : purchaseHistory,
      'servicesHistory': servicesHistory,
    };
  }
}

Future<List<user>> getAllUsers() async {
  users.clear();
  try {
    // Access the 'users' collection in Firestore
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    // Iterate through the documents snapshot and convert each to User object
    querySnapshot.docs.forEach((doc) {
      user NewUser = user(
        uid: doc['uid'],
        firstName: doc['firstName'],
        lastName: doc['lastName'],
        role: doc['role'],
        servicesOffered: List<ServicesOffered>.from(
          doc['servicesOffered'].map((service) => ServicesOffered(
                name: service['name'],
                description: service['description'],
                price: service['price'].toDouble(),
                availableDays: List<String>.from(service['availableDays']),
              )),
        ),
        itemsSelling: List<Item>.from(
          doc['itemsSelling'].map((item) => Item(
            quantity: item['quantity'],
                name: item['name'],
                category: item['category'],
                price: item['price'].toDouble(),
                description: item['description'],
                imageUrl: item['imageUrl']
              )),
        ),
        mobileNumber: doc['mobileNumber'],
        email: doc['email'],
        address: doc['address'],
        itemsInCart: List<Item>.from(
          doc['itemsInCart'].map((item) => Item(
                name: item['name'],
                category: item['category'],
                price: item['price'].toDouble(),
                description: item['description'],
                imageUrl: item['imageUrl'],
                quantity: item['quantity']
              )),
        ),
         purchaseHistory: List<Item>.from(
          doc['purchaseHistory'].map((item) => Item(
                name: item['name'],
                category: item['category'],
                price: item['price'].toDouble(),
                description: item['description'],
                imageUrl: item['imageUrl'],
                quantity: item['quantity']
              )),
        ),
        servicesHistory: List<ServicesOffered>.from(
          doc['servicesOffered'].map((service) => ServicesOffered(
                name: service['name'],
                description: service['description'],
                price: service['price'].toDouble(),
                availableDays: List<String>.from(service['availableDays']),
              )),
        ),
      );
      users.add(NewUser);
      for(Item item in NewUser.itemsSelling){
        allItems.add(item);
      }

      for (ServicesOffered service in NewUser.servicesOffered) {
        allServices.add(service);
      }
    });

    return users;
  } catch (e) {
    // Handle errors
    print('Error getting users: $e');
    return [];
  }
}
