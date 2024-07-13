// ignore_for_file: prefer_const_constructors, prefer_final_fields

import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooperative_platform/main.dart';
import 'package:cooperative_platform/models/item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for FilteringTextInputFormatter
import 'package:file_picker/file_picker.dart';

class Sell extends StatefulWidget {
  @override
  _SellState createState() => _SellState();
}

class _SellState extends State<Sell> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  PlatformFile? _imageFile; // State variable to store the selected image file

  @override
  void initState() {
    super.initState();
    // Initialize input formatters for quantity and price text fields
    _quantityController = TextEditingController();
    _priceController = TextEditingController();
  }

  @override
  void dispose() {
    // Clean up controllers when not needed to avoid memory leaks
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (result == null) return;

      setState(() {
        _imageFile = result.files.first;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Sell Item",
              style: TextStyle(
                color: Color.fromARGB(255, 61, 132, 168),
                fontSize: 44.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: _pickImage, // Call _pickImage function on tap
              child: Container(
                height: 200,
                width: double.infinity,
                child: _imageFile == null
                    ? Center(
                        child: Icon(
                          Icons.add_a_photo,
                          size: 60,
                          color: Colors.grey[400],
                        ),
                      )
                    : Image.memory(Uint8List.fromList(_imageFile!.bytes!)),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _categoryController,
              decoration: InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(
                labelText: 'Price (PHP)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            RawMaterialButton(
              fillColor: Color.fromARGB(255, 61, 132, 168),
              elevation: 5,
              padding: EdgeInsets.symmetric(vertical: 15),
              onPressed: () async {
                try {
                  // Define the path for the image in Firebase Storage
                  String imagePath =
                      '${currentUser!.email}/${_nameController.text}.jpg';
                  Uint8List imageBytes = _imageFile!.bytes!;

                  // Create a reference to the location you want to upload the image
                  final ref = FirebaseStorage.instance.ref().child(imagePath);

                  // Upload the image file to Firebase Storage
                  await ref.putData(imageBytes);

                  // Create a new item to add to itemsSelling
                  Item newItem = Item(
                    name: _nameController.text,
                    category: _categoryController.text,
                    price: double.parse(_priceController.text),
                    description: _descriptionController.text,
                    imageUrl: imagePath,
                    quantity: int.parse(_quantityController.text),
                  );

                  // Update the current user's itemsSelling list
                  currentUser!.itemsSelling.add(newItem);

                  // Reference to the current user's document in Firestore
                  final userRef = FirebaseFirestore.instance
                      .collection('users')
                      .doc(currentUser!.uid);

                  // Update itemsSelling in Firestore
                  await userRef.update({
                    'itemsSelling': FieldValue.arrayUnion([newItem.toJson()])
                  });

                  // Show a SnackBar to indicate success
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Item posted'),
                    ),
                  );

                  // Close the current screen
                  Navigator.pop(context);
                } catch (e) {
                  // Handle any errors that occur during the upload or update process
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to post item: $e'),
                    ),
                  );
                }
              },
              child: Text(
                "Sell item",
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            )
          ],
        ),
      ),
    );
  }
}
