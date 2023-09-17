// ignore_for_file: must_be_immutable
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:krishishop/models/Cart.dart';
import 'package:lottie/lottie.dart';
import 'models/Products.dart';

class productDetails extends StatefulWidget {
  final Products product;

  productDetails({super.key, required this.product});

  @override
  State<productDetails> createState() => _productDetailsState();
}

class _productDetailsState extends State<productDetails> {
  List<dynamic> images = [];
  String pid = "";
  String name = "";
  String description = "";
  String quantity = "";
  String price = "";
  int selectedQuantity = 1;
  bool animateButton = false;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  bool isAvailable = false;
  bool doCartAnimation = false;
  bool error = false;
  int newQuantity = 0;

  Future<bool> isFavourite() async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(uid)
        .collection("Favourite")
        .doc(pid)
        .get()
        .then((documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          isAvailable = true;
        });

        return true;
      } else {
        setState(() {
          isAvailable = false;
        });
        return false;
      }
    });

    return false;
  }

  void doAnimation() {
    setState(() {
      animateButton = true;
    });

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        animateButton = false;
      });
    });
  }

  Future<void> addToCart() async {
    print(quantity);
    if (quantity == "0") {
      final snackBar = SnackBar(
        content: Text(
          'Product out of stock',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      Cart cartProduct = Cart(
          image: images[0],
          name: name,
          pid: pid,
          price: price,
          quantity: quantity,
          totalPrice: (int.parse(price) * (selectedQuantity)).toString());
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(uid)
          .collection("Cart")
          .doc()
          .set(cartProduct.toJson());

      setState(() {
        doCartAnimation = true;

        Future.delayed(Duration(seconds: 3), () {
          setState(() {
            doCartAnimation = false;
          });
        });
      });
    }
  }

  void showSnackBar(BuildContext context) {
    if (quantity == "0") {
      print("Equal");
      final snackBar = SnackBar(
        content: Text(
          'Product out of stock',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void initState() {
    super.initState();
    images.addAll(widget.product.images);
    name = widget.product.name;
    description = widget.product.description;
    quantity = widget.product.quantity;
    price = widget.product.price;
    pid = widget.product.pid;
    isFavourite();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 340,
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.white),
          child: ListView.builder(
              itemCount: images.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Container(
                    height: 340,
                    width: 380,
                    decoration: BoxDecoration(color: Colors.white),
                    child: Image.network(
                      images[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }),
        ),
        Positioned(
          top: 330,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              width: 388,
              height: 425,
              decoration: BoxDecoration(color: Colors.transparent),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        name,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 32,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "₹ ${price}",
                        style: TextStyle(
                            color: Colors.orange,
                            fontSize: 32,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      quantity == "0"
                          ? Text(
                              "Out of Stock",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 32,
                              ),
                            )
                          : Text(
                              quantity,
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 32,
                              ),
                            ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Description",
                        style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 32,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        description,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 24,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 310,
          left: 320,
          child: FloatingActionButton(
            backgroundColor: const Color.fromARGB(255, 255, 165, 157),
            onPressed: () async {
              if (isAvailable) {
                await FirebaseFirestore.instance
                    .collection("Users")
                    .doc(uid)
                    .collection("Favourite")
                    .doc(pid)
                    .delete();

                setState(() {
                  isAvailable = false;
                });
              } else {
                await FirebaseFirestore.instance
                    .collection("Users")
                    .doc(uid)
                    .collection("Favourite")
                    .doc(pid)
                    .set({"pid": pid});

                setState(() {
                  isAvailable = true;
                });
              }
            },
            child: isAvailable
                ? Icon(
                    Icons.favorite,
                    color: const Color.fromARGB(255, 255, 9, 58),
                    size: 35,
                  )
                : Icon(
                    Icons.favorite_border,
                    color: const Color.fromARGB(255, 255, 9, 58),
                    size: 35,
                  ),
          ),
        ),
        Positioned(
          top: 780,
          child: Container(
            height: 120,
            width: 413,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20, bottom: 20, left: 20, right: 8),
                  child: GestureDetector(
                    onTap: () async {
                      showSnackBar(context);
                      doAnimation();
                      await addToCart();
                    },
                    child: animateButton
                        ? Container(
                            width: 240,
                            height: 100,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(100)),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ))
                        : Container(
                            width: 240,
                            height: 100,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(100)),
                            child: Center(
                                child: Text(
                              "Add to cart",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            )),
                          ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (selectedQuantity != 1) {
                        selectedQuantity -= 1;
                      }
                    });
                  },
                  child: Container(
                    child: Icon(
                      Icons.remove,
                      color: Colors.grey.shade700,
                    ),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(100)),
                  ),
                ),
                SizedBox(width: 15),
                Text(
                  "${selectedQuantity}",
                  style: TextStyle(fontSize: 22, color: Colors.grey.shade700),
                ),
                SizedBox(width: 15),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (selectedQuantity != 15) {
                        selectedQuantity += 1;
                      }
                    });
                  },
                  child: Container(
                    child: Icon(
                      Icons.add,
                      color: Colors.grey.shade700,
                    ),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(100)),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 785,
          left: 178,
          child: Container(
            width: 50,
            height: 6,
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(100)),
          ),
        ),
        if (doCartAnimation)
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Center(
              child: LottieBuilder.asset(
                "assets/animation/addedtocart.json",
                height: 100,
                width: 100,
                repeat: false,
              ),
            ),
          ]),
      ],
    );
  }
}
