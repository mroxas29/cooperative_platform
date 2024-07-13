// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooperative_platform/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final _auth = FirebaseAuth.instance;
  bool isSamePassword = true;
  void signUp(String email, String password, user newUser) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    newUser.uid = userCredential.user!.uid;
    postDetailsToFirestore(
      newUser,
    );
  }

  void postDetailsToFirestore(user newUser) async {
    CollectionReference ref = FirebaseFirestore.instance.collection('users');
    await ref.doc(newUser.uid).set(newUser.toJson());
     SnackBar(
      content: Text('Successfully created user'),
    );

  }

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  String selectedRole = "Member";
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(44.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Add User",
                      style: TextStyle(
                        color: Color.fromARGB(255, 61, 132, 168),
                        fontSize: 44.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 44),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _firstNameController,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              hintText: "Enter first name",
                              prefixIcon: Icon(
                                Icons.person,
                                color: Color.fromARGB(255, 61, 132, 168),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: TextField(
                            controller: _lastNameController,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              hintText: "Enter last name",
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 26),
                    DropdownButtonFormField<String>(
                      value: 'Member', // Initial value
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedRole = newValue!;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Enter role",
                        prefixIcon: Icon(
                          Icons.business,
                          color: Color.fromARGB(255, 61, 132, 168),
                        ),
                      ),
                      items: <String>['Administrator', 'Manager', 'Member']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 26),
                    TextField(
                      controller: _mobileNumberController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: "Enter mobile number",
                        prefixIcon: Icon(
                          Icons.phone,
                          color: Color.fromARGB(255, 61, 132, 168),
                        ),
                      ),
                    ),
                    SizedBox(height: 26),
                    TextField(
                      controller: _addressController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: "Enter address",
                        prefixIcon: Icon(
                          Icons.location_on_outlined,
                          color: Color.fromARGB(255, 61, 132, 168),
                        ),
                      ),
                    ),
                    SizedBox(height: 26),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "Enter email",
                        prefixIcon: Icon(
                          Icons.mail,
                          color: Color.fromARGB(255, 61, 132, 168),
                        ),
                      ),
                    ),
                    SizedBox(height: 26),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      onChanged: (value) {
                        setState(() {
                          isSamePassword =
                              (value == _confirmPassController.text);
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Enter password",
                        prefixIcon: Icon(
                          Icons.security,
                          color: Color.fromARGB(255, 61, 132, 168),
                        ),
                      ),
                    ),
                    SizedBox(height: 26),
                    TextField(
                      controller: _confirmPassController,
                      obscureText: true,
                      onChanged: (value) {
                        setState(() {
                          isSamePassword = (value == _passwordController.text);
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Confirm password",
                        prefixIcon: Icon(
                          Icons.security,
                          color: isSamePassword
                              ? Color.fromARGB(255, 61, 132, 168)
                              : Colors.red,
                        ),
                        errorText:
                            isSamePassword ? null : "Passwords do not match",
                      ),
                    ),
                    SizedBox(height: 88),
                    SizedBox(
                      width: double.infinity,
                      child: RawMaterialButton(
                        fillColor: Color.fromARGB(255, 61, 132, 168),
                        elevation: 5,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        onPressed: () async {
                          final newUser = user(
                            uid: '',
                            firstName: _firstNameController.text,
                            lastName: _lastNameController.text,
                            role: selectedRole,
                            mobileNumber: _mobileNumberController.text,
                            email: _emailController.text,
                            servicesOffered: [],
                            itemsSelling: [],
                            address: _addressController.text,
                            itemsInCart: [],
                            purchaseHistory: [],
                            servicesHistory: [],
                          );

                          signUp(_emailController.text,
                              _passwordController.text, newUser);

                          Navigator.pop(context);
                         
                          // Add user creation logic here
                        },
                        child: Text(
                          "Add User",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
