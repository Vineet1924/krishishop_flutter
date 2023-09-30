import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:krishishop/cart_screen.dart';
import 'package:krishishop/favouriteScreen.dart';
import 'package:krishishop/home_screen.dart';
import 'package:krishishop/profile_screen.dart';
import 'package:krishishop/search_screen.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

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
    favouriteScreen(),
    profileScreen()
  ];
  var pageController = PageController();
  var uid = FirebaseAuth.instance.currentUser!.uid;
  late Stream<QuerySnapshot<Map<String, dynamic>>> productStream;
  late Stream<int> cartLengthStream;
  int cart_Length = 0;

  @override
  void initState() {
    super.initState();

    EasyLoading.show(status: "Loading");
    cartLengthStream = streamCartLength();
    productStream =
        FirebaseFirestore.instance.collection("Products").snapshots();
  }

  Stream<int> streamCartLength() {
    CollectionReference cartRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('Cart');

    Query cartQuery = cartRef;

    return cartQuery.snapshots().map<int>((QuerySnapshot<Object?> snapshots) {
      setState(() {
        cart_Length = snapshots.size;
      });
      return snapshots.size;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Krishishop"),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => cartScreen()));
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Badge(
                textColor: Colors.white,
                label: Text(
                  cart_Length.toString(),
                  style: TextStyle(fontSize: 10),
                ),
                backgroundColor: Colors.blue,
                child: Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
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
        StreamBuilder<int>(
          stream: cartLengthStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('');
            } else if (snapshot.hasError) {
              return Text('');
            } else {
              return Text('');
            }
          },
        )
      ]),
      bottomNavigationBar: Stack(children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              border: Border.all(color: Colors.black),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: GNav(
                backgroundColor: Colors.grey.shade900,
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
                    icon: Icons.favorite_border_outlined,
                    text: "Favourite",
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
