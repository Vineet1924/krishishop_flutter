import 'package:flutter/material.dart';
import 'package:krishishop/home_screen.dart';
import 'package:krishishop/profile_screen.dart';
import 'package:krishishop/search_screen.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'cart_screen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int currentIndex = 0;
  static const List<Widget> screens = <Widget>[
    home(),
    searchScreen(),
    cartScreen(),
    profileScreen()
  ];
  var pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        PageView(
          children: screens,
          onPageChanged: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          controller: pageController,
        ),
      ]),
      bottomNavigationBar: Stack(children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(color: Colors.black),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: GNav(
                backgroundColor: Colors.black,
                color: Colors.white,
                activeColor: Colors.white,
                tabBackgroundColor: Colors.grey.shade800,
                gap: 8,
                padding: EdgeInsets.all(16),
                tabs: [
                  GButton(
                    icon: Icons.apps,
                    text: "Home",
                  ),
                  GButton(
                    icon: Icons.search,
                    text: "Search",
                  ),
                  GButton(
                    icon: Icons.shopping_cart_outlined,
                    text: "Cart",
                  ),
                  GButton(
                    icon: Icons.person,
                    text: "Profile",
                  ),
                ],
                selectedIndex: currentIndex,
                onTabChange: (index) {
                  setState(() {
                    currentIndex = index;
                    pageController.animateToPage(currentIndex,
                        duration: Duration(microseconds: 200),
                        curve: Curves.linear);
                  });
                },
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
