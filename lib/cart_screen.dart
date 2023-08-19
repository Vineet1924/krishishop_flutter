import 'package:flutter/material.dart';
import 'package:krishishop/components/my_button.dart';
import 'package:lottie/lottie.dart';

class cartScreen extends StatefulWidget {
  const cartScreen({super.key});

  @override
  State<cartScreen> createState() => _cartScreenState();
}

class _cartScreenState extends State<cartScreen> {
  final cart = ["1"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Text(
            "Krishishop",
            style: TextStyle(color: Colors.white),
          )),
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
