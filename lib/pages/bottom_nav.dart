import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/pages/home.dart';
import 'package:pharmacy_app/pages/profile.dart';
import 'package:pharmacy_app/pages/wallet.dart';
import 'package:pharmacy_app/pages/order.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  late List<Widget> pages;
  late Home home;
  late OrderPage order;
  late Wallet wallet;
  late Profile profile;
  int currentTabIndex = 0;
  @override
  void initState() {
    home = Home();
    order = OrderPage();
    wallet = Wallet();
    profile = Profile();
    pages = [home, order, wallet, profile];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 60,
        backgroundColor: Color.fromARGB(253, 280, 193, 181),
        animationDuration: Duration(milliseconds: 500),
        onTap: (int index) {
          setState(() {
            currentTabIndex = index;
          });
        },
        items: [
          currentTabIndex == 0 ? Icon(Icons.home, color: Colors.white) : Icon(Icons.home) ,
          currentTabIndex == 1 ? Icon(Icons.home, color: Colors.white) : Icon(Icons.home),
          currentTabIndex == 2 ? Icon(Icons.home, color: Colors.white) : Icon(Icons.home),
          currentTabIndex == 3 ? Icon(Icons.home, color: Colors.white) : Icon(Icons.home)   
        ],
      ),
      body: pages[currentTabIndex],
    );
  }
}
