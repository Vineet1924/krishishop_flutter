// ignore_for_file: unused_label

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:krishishop/cart_screen.dart';
import 'package:krishishop/components/my_card.dart';
import 'package:krishishop/product_details.dart';
import 'models/Products.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  bool doCartAnimation = false;
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
        title: Text(
          "Krishishop",
          style: TextStyle(color: Colors.white),
        ),
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
        Padding(
            padding: const EdgeInsets.all(12.0),
            child: StreamBuilder(
                stream: productStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    print("inside waiting state");
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    print("Inside error state");
                    return Text("Error ${snapshot.error}");
                  } else {
                    final documents = snapshot.data?.docs;
                    List<Products> products = documents!
                        .map((products) => Products(
                            description: products['description'],
                            name: products['name'],
                            quantity: products['quantity'],
                            images: products['images'],
                            price: products['price'],
                            pid: products.id))
                        .toList();

                    return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12),
                        controller: ScrollController(keepScrollOffset: false),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: products.length,
                        itemBuilder: (context, Index) {
                          final product = products[Index];
                          EasyLoading.dismiss();
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  (MaterialPageRoute(
                                      builder: (context) =>
                                          productDetails(product: product))));
                            },
                            child: myCard(
                              index: Index,
                              name: products[Index].name,
                              description: products[Index].description,
                              quantity: products[Index].quantity,
                              price: products[Index].price,
                              image: products[Index].images[0],
                              pid: product.pid,
                            ),
                          );
                        });
                  }
                })),
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
    );
  }
}
