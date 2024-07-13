// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Topbar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onMainButtonPressed;
  final VoidCallback onSecondaryButtonPressed;
  final String role;
  final int index;
  Topbar({required this.index, required this.role, required this.onMainButtonPressed, super.key, required this.onSecondaryButtonPressed});

  @override
  Size get preferredSize => Size.fromHeight(200);

  Widget buttonToShow() {
    if (this.role == 'Admin' && index == 1) {
      return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          backgroundColor: Color.fromARGB(255, 61, 132, 168),
          foregroundColor: Colors.white,
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(55.0),
            side: BorderSide.none,
          ),
        ),
        onPressed: onMainButtonPressed,
        icon: Icon(Icons.person_add_outlined, size: 20),
        label: Text(
          'Add user',
          style: TextStyle(
            fontWeight: FontWeight.w200,
            fontSize: 11,
          ),
        ),
      );
    } else if (this.role == 'Member') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              backgroundColor: Color.fromARGB(255, 61, 132, 168),
              foregroundColor: Colors.white,
              side: BorderSide.none,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(55.0),
                side: BorderSide.none,
              ),
            ),
            onPressed: onMainButtonPressed,
            icon: Icon(Icons.sell_outlined, size: 20),
            label: Text(
              'Sell item',
              style: TextStyle(
                fontWeight: FontWeight.w200,
                fontSize: 11,
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          //Cart button
          IconButton(
            onPressed: onSecondaryButtonPressed,
            icon: Icon(Icons.shopping_cart_outlined, size: 20),
            color: Color.fromARGB(255, 61, 132, 168),
            hoverColor: Color.fromARGB(255, 192, 192, 192),
            iconSize: 24.0,
          ),
        ],
      );
    } else {
      return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          backgroundColor: Color.fromARGB(255, 61, 132, 168),
          foregroundColor: Colors.white,
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(55.0),
            side: BorderSide.none,
          ),
        ),
        onPressed: onMainButtonPressed,
        icon: Icon(Icons.sell_outlined, size: 20),
        label: Text(
          'Sell item',
          style: TextStyle(
            fontWeight: FontWeight.w200,
            fontSize: 11,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate =
        DateFormat('EEEE, d\'th\' MMMM').format(DateTime.now());

    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Card(
        color: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 5.0,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              // Search TextField
              SizedBox(
                width: MediaQuery.sizeOf(context).width / 5,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search",
                    suffixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Color.fromARGB(255, 218, 218, 218),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  ),
                ),
              ),
              Spacer(),
              // Date
              Text(
                formattedDate,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              Spacer(),
              // Add User button
              buttonToShow()
            ],
          ),
        ),
      ),
    );
  }
}
