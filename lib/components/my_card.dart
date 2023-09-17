// ignore_for_file: camel_case_types, must_be_immutable, recursive_getters, unrelated_type_equality_checks
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:krishishop/components/my_snackbar.dart';
import 'package:krishishop/models/Cart.dart';

class myCard extends StatefulWidget {
  int index;
  String name = "";
  String description = "";
  String quantity = "";
  String price = "";
  String image = "";
  String pid = "";
  myCard(
      {super.key,
      required this.index,
      required this.name,
      required this.description,
      required this.quantity,
      required this.price,
      required this.image,
      required this.pid});

  @override
  State<myCard> createState() => _myCardState();
}

class _myCardState extends State<myCard> {
  Future<void> addToCart() async {
    var uid = FirebaseAuth.instance.currentUser!.uid;

    Cart cartProduct = Cart(
        image: widget.image,
        name: widget.name,
        pid: widget.pid,
        price: widget.price,
        quantity: "1",
        totalPrice: widget.price);
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(uid)
        .collection("Cart")
        .doc()
        .set(cartProduct.toJson());

    showErrorSnackBar(context, "Product added");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: widget.index,
        onPressed: () async {
          if (widget.quantity == "0") {
            showErrorSnackBar(context, "Product out of stock");
          } else {
            await addToCart();
          }
        },
        mini: true,
        backgroundColor: Colors.orange,
        child: const Icon(
          Icons.shopping_bag_outlined,
          color: Colors.white,
        ),
      ),
      body: Material(
        elevation: 3,
        color: Colors.white,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 110,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        widget.image,
                        fit: BoxFit.fill,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  widget.name,
                  style: TextStyle(color: Colors.grey.shade800, fontSize: 16),
                ),
              ),
              const SizedBox(height: 1),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  "₹ ${widget.price}",
                  style: TextStyle(
                      color: Colors.orange.shade800,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 1),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: widget.quantity == "0"
                    ? const Text(
                        "Out of Stock",
                        style: TextStyle(
                          color: Colors.redAccent,
                        ),
                      )
                    : Text(
                        widget.quantity,
                        style: const TextStyle(
                          color: Colors.green,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
