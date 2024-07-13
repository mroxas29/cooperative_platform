// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:cooperative_platform/coop_utils/coop_market.dart';
import 'package:cooperative_platform/coop_utils/coop_services.dart';
import 'package:cooperative_platform/models/user.dart';

import 'package:cooperative_platform/profile.dart';
import 'package:cooperative_platform/welcome.dart';

import 'package:flutter/material.dart';

class CoopScreen extends StatefulWidget {
  final user? currentUser;

  CoopScreen({super.key, this.currentUser});
  @override
  State<CoopScreen> createState() => _CoopScreenState();
}

class _CoopScreenState extends State<CoopScreen> {
  final NotchBottomBarController _pageController = NotchBottomBarController();
  int pageToView = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 181, 194, 202),
      body: getPage(pageToView),
      bottomNavigationBar: Row(
        children: [
          SizedBox(
            width: 10,
          ),
          Spacer(),
          AnimatedNotchBottomBar(
            notchBottomBarController: _pageController,
            bottomBarItems: [
              BottomBarItem(
                  inActiveItem: Icon(
                    Icons.home,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.home,
                    color: Color.fromARGB(255, 61, 132, 168),
                  ),
                  itemLabel: " "),
       
              BottomBarItem(
                  inActiveItem: Icon(
                    Icons.store,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.store,
                    color: Color.fromARGB(255, 61, 132, 168),
                  ),
                  itemLabel: " "),
              BottomBarItem(
                  inActiveItem: Icon(
                    Icons.design_services_outlined,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.design_services_outlined,
                    color: Color.fromARGB(255, 61, 132, 168),
                  ),
                  itemLabel: " "),
              BottomBarItem(
                  inActiveItem: Icon(
                    Icons.person_2_outlined,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.person_2_outlined,
                    color: Color.fromARGB(255, 61, 132, 168),
                  ),
                  itemLabel: " "),
            ],
            onTap: (int value) {
              setState(() {
                pageToView = value;
                print(pageToView);
              });
            },
            kIconSize: 18,
            kBottomRadius: 8,
          ),
          Spacer(),
          SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }

  Widget getPage(int page) {
    switch (page) {
      case 0:
        return Welcome();
      case 1:
        return CoopMarket();
      case 2:
        return CoopServices();
      case 3:
         return UserProfile(
          firstName: widget.currentUser!.firstName,
          lastName: widget.currentUser!.lastName,
        );
      default:
        return Welcome(); // Default to Dashboard page
    }
  }
}
