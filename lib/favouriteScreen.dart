import 'package:flutter/material.dart';
import 'package:krishishop/cart_screen.dart';
import 'package:krishishop/components/my_button.dart';
import 'package:krishishop/models/Cart.dart';
import 'package:lottie/lottie.dart';

class favouriteScreen extends StatefulWidget {
  const favouriteScreen({super.key});

  @override
  State<favouriteScreen> createState() => _favouriteScreenState();
}

class _favouriteScreenState extends State<favouriteScreen> {
  final List<Cart> cart = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          "Krishishop",
          style: TextStyle(color: Colors.white),
        ),
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
                  "1",
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
      body: SafeArea(
        child: cart.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LottieBuilder.asset(
                      "assets/animation/emptycart.json",
                      height: 200.0,
                      repeat: true,
                      reverse: false,
                      animate: true,
                    )
                  ],
                ),
              )
            : Stack(children: [
                Positioned(
                  top: 15,
                  left: 15,
                  child: Container(
                    width: 380,
                    height: 704,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: GridView.builder(
                        itemCount: 10,
                        controller: ScrollController(keepScrollOffset: false),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 4,
                            mainAxisSpacing: 4),
                        itemBuilder: (context, index) {
                          return Container(
                            width: 200,
                            height: 100,
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(12)),
                          );
                        }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 640, bottom: 5),
                  child: MyButton(onTap: () {}, title: "Checkout"),
                )
              ]),
      ),
    );
  }
}
