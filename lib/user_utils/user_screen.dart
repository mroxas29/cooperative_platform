// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:cooperative_platform/admin_utils/market.dart';
import 'package:cooperative_platform/admin_utils/services.dart';
import 'package:cooperative_platform/cart.dart';
import 'package:cooperative_platform/main.dart';
import 'package:cooperative_platform/models/user.dart';
import 'package:cooperative_platform/profile.dart';
import 'package:cooperative_platform/sell.dart';
import 'package:cooperative_platform/ui/top_bar.dart';
import 'package:cooperative_platform/user_utils/user_market.dart';
import 'package:cooperative_platform/user_utils/user_services.dart';
import 'package:cooperative_platform/welcome.dart';

import 'package:flutter/material.dart';

class UserScreen extends StatefulWidget {
  final user? currentUser;

  UserScreen({super.key, this.currentUser});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final NotchBottomBarController _pageController = NotchBottomBarController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String type = ''; // Initialize type with an empty string
  int pageToView = 0;

  void _openEndDrawer() {
    _scaffoldKey.currentState!.openEndDrawer();
  }

  void _closeEndDrawer() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: Topbar(
        index: pageToView,
        role: widget.currentUser!.role,
        onMainButtonPressed: () {
          setState(() {
            type = 'Sell'; // Update type to 'Sell'
          });
          _openEndDrawer();
        },
        onSecondaryButtonPressed: () {
          setState(() {
            type = 'Cart'; // Update type to 'Cart'
          });
          _openEndDrawer();
        },
      ),
      backgroundColor: Color.fromARGB(255, 181, 194, 202),
      body: getPage(pageToView),
      bottomNavigationBar: Row(
        children: [
          SizedBox(width: 10),
          Spacer(),
          AnimatedNotchBottomBar(
            notchBottomBarController: _pageController,
            bottomBarItems: [
              BottomBarItem(
                inActiveItem: Icon(Icons.home, color: Colors.blueGrey),
                activeItem:
                    Icon(Icons.home, color: Color.fromARGB(255, 61, 132, 168)),
                itemLabel: " ",
              ),
              BottomBarItem(
                inActiveItem: Icon(Icons.store, color: Colors.blueGrey),
                activeItem:
                    Icon(Icons.store, color: Color.fromARGB(255, 61, 132, 168)),
                itemLabel: " ",
              ),
              BottomBarItem(
                inActiveItem: Icon(Icons.design_services_outlined,
                    color: Colors.blueGrey),
                activeItem: Icon(Icons.design_services_outlined,
                    color: Color.fromARGB(255, 61, 132, 168)),
                itemLabel: " ",
              ),
              BottomBarItem(
                inActiveItem:
                    Icon(Icons.person_2_outlined, color: Colors.blueGrey),
                activeItem: Icon(Icons.person_2_outlined,
                    color: Color.fromARGB(255, 61, 132, 168)),
                itemLabel: " ",
              ),
            ],
            onTap: (int value) {
              setState(() {
                pageToView = value;
              });
            },
            kIconSize: 18,
            kBottomRadius: 8,
          ),
          Spacer(),
          SizedBox(width: 10),
        ],
      ),
      endDrawer: ClipRRect(
        borderRadius: BorderRadius.zero,
        child: Drawer(
          width: MediaQuery.sizeOf(context).width / 3,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.75,
            child: getEndDrawer(pageToView, type),
          ),
        ),
      ),
    );
  }

  Widget getEndDrawer(int page, String type) {
    if (page == 0) {
      return Welcome();
    } else if (page == 1) {
      if (type == 'Sell') {
        return Sell();
      } else {
        return Cart();
      }
    } else if (page == 2) {
      return Market();
    } else if (page == 3) {
      return Services();
    } else if (page == 4) {
      return UserProfile(
        firstName: widget.currentUser!.firstName,
        lastName: widget.currentUser!.lastName,
      );
    } else {
      return Welcome(); // Default to Welcome page if none of the conditions match
    }
  }

  Widget getPage(int page) {
    switch (page) {
      case 0:
        return Welcome();
      case 1:
        return UserMarket();
      case 2:
        return UserServices();
      case 3:
        return UserProfile(
          firstName: widget.currentUser!.firstName,
          lastName: widget.currentUser!.lastName,
        );
      default:
        return Welcome(); // Default to Welcome page
    }
  }
}
