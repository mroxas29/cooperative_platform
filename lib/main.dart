// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables

import 'package:cooperative_platform/coop_utils/coop_screen.dart';
import 'package:cooperative_platform/firebase_options.dart';
import 'package:cooperative_platform/admin_utils/admin_screen.dart';
import 'package:cooperative_platform/models/user.dart';
import 'package:cooperative_platform/user_utils/user_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

late user? currentUser;
List<user> users = [];
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'commUnity Connect',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _initializeFirebase(),
        builder: (contxt, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return LoginScreen();
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      backgroundColor: Colors.white,
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  void signIn(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Incorrect email or password');
      }
    }

    route(email);
  }

  void route(String email) async {
    User? authuser = FirebaseAuth.instance.currentUser;
    await getAllUsers();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(authuser!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        currentUser =
            users.firstWhere((element) => element.email == authuser.email);
        if (currentUser!.role == "Admin") {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => AdminScreen(
                        currentUser: currentUser,
                      )));
        }
        if (currentUser!.role == "Manager") {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => CoopScreen(
                        currentUser: currentUser,
                      )));
        }
        if (currentUser!.role == "Member") {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => UserScreen(
                        currentUser: currentUser,
                      )));
        }
      }
    });
  }

  

  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage('assets/coop_logo.png'),
                ),
              ],
            ),
          ),
          SizedBox(
            width: MediaQuery.sizeOf(context).width / 4,
            child: Container(
              decoration: BoxDecoration(
                color:
                    Color.fromARGB(200, 255, 255, 255), // Semi-white background
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255, 177, 177, 177)
                        .withOpacity(0.5), // Shadow color with opacity
                    spreadRadius: 5, // How far the shadow spreads
                    blurRadius: 7, // How blurry the shadow is
                    offset: Offset(-3,
                        0), // Horizontal offset, negative for left side shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(44.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Login",
                      style: TextStyle(
                        color: Color.fromARGB(255, 61, 132, 168),
                        fontSize: 44.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 44,
                    ),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          hintText: "Enter email",
                          prefixIcon: Icon(
                            Icons.mail,
                            color: Color.fromARGB(255, 61, 132, 168),
                          )),
                    ),
                    SizedBox(
                      height: 26,
                    ),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: "Enter password",
                          prefixIcon: Icon(
                            Icons.security,
                            color: Color.fromARGB(255, 61, 132, 168),
                          )),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    TextButton(
                        onPressed: () {},
                        child: Text(
                          "Forgot your password?",
                          style: TextStyle(color: Color.fromARGB(125, 0, 0, 0)),
                        )),
                    SizedBox(
                      height: 88,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: RawMaterialButton(
                        fillColor: Color.fromARGB(255, 61, 132, 168),
                        elevation: 5,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                        onPressed: () async {
                          signIn(
                              _emailController.text, _passwordController.text);
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
