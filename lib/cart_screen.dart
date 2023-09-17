import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:krishishop/components/cart_list.dart';
import 'package:krishishop/components/my_button.dart';
import 'package:krishishop/models/Cart.dart';
import 'package:krishishop/order_summary.dart';
import 'package:lottie/lottie.dart';

class cartScreen extends StatefulWidget {
  const cartScreen({super.key});

  @override
  State<cartScreen> createState() => _cartScreenState();
}

class _cartScreenState extends State<cartScreen> {
  List<Cart> cartProducts = [];
  var uid = FirebaseAuth.instance.currentUser!.uid;
  int totalPrice = 0;

  @override
  void initState() {
    super.initState();
    EasyLoading.show(status: "Loading");
    fetchProducts();
  }

  void fetchProducts() async {
    var documents = await FirebaseFirestore.instance
        .collection("Users")
        .doc(uid)
        .collection("Cart")
        .get();
    mapProducts(documents);
  }

  mapProducts(QuerySnapshot<Map<String, dynamic>> documents) {
    var productsList = documents.docs
        .map((products) => Cart(
              image: products['image'],
              name: products['name'],
              pid: products['pid'],
              price: products['price'],
              quantity: products['quantity'],
              totalPrice: products['total_price'],
            ))
        .toList();

    setState(() {
      cartProducts.addAll(productsList);
      for (var product in cartProducts) {
        totalPrice += int.parse(product.totalPrice.toString());
        int quantity = (int.parse(product.totalPrice.toString()) ~/
            int.parse(product.price.toString()));
        product.quantity = quantity.toString();
      }
      EasyLoading.dismiss();
    });
  }

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
        child: cartProducts.isEmpty
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
                Padding(
                  padding: const EdgeInsets.only(
                      left: 12, right: 12, top: 12, bottom: 115),
                  child: Container(
                    child: ListView.builder(
                        itemCount: cartProducts.length,
                        itemBuilder: (context, index) {
                          return listCart(
                            index: index,
                            image: cartProducts[index].image,
                            name: cartProducts[index].name,
                            price: cartProducts[index].price,
                            quantity: cartProducts[index].quantity,
                            total_price: cartProducts[index].totalPrice,
                            pid: cartProducts[index].pid,
                          );
                        }),
                  ),
                ),
                Positioned(
                  top: 680,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 120,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20))),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 80,
                            height: 7,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(20)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                  flex: 7,
                                  child: MyButton(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    OrderSammary(
                                                      items:
                                                          cartProducts.length,
                                                      totalAmount: totalPrice,
                                                      order_items: cartProducts,
                                                    )));
                                      },
                                      title: "Checkout")),
                              Expanded(
                                  flex: 2,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Total",
                                        style: TextStyle(
                                            color: Colors.greenAccent.shade400,
                                            fontSize: 24,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        "₹ ${totalPrice}",
                                        style: TextStyle(
                                            color: Colors.greenAccent.shade700,
                                            fontSize: 21,
                                            fontWeight: FontWeight.w400),
                                      )
                                    ],
                                  ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ]),
      ),
    );
  }
}
