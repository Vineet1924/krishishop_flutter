// ignore_for_file: must_be_immutable, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:krishishop/cart_screen.dart';
import 'package:krishishop/components/my_snackbar.dart';

class listCart extends StatefulWidget {
  String image = "";
  String name = "";
  String price = "";
  String total_price = "";
  String quantity = "";
  String pid = "";
  int index = 0;

  listCart(
      {super.key,
      required this.index,
      required this.image,
      required this.name,
      required this.price,
      required this.quantity,
      required this.total_price,
      required this.pid});

  @override
  State<listCart> createState() => _listCartState();
}

class _listCartState extends State<listCart> {
  var uid = FirebaseAuth.instance.currentUser!.uid;

  deleteDocument(var docid) async {
    try {
      CollectionReference reference = await FirebaseFirestore.instance
          .collection("Users")
          .doc(uid)
          .collection("Cart");

      QuerySnapshot<Object?> querySnapshot = await reference
          .where('pid', isEqualTo: widget.pid)
          .where('quantity', isEqualTo: widget.quantity)
          .get();

      // Delete each document that meets the condition
      for (QueryDocumentSnapshot<Object?> doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      showErrorSnackBar(context, e.toString());
    }

    setState(() {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => cartScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      child: Container(
        width: double.maxFinite,
        height: 160,
        decoration: BoxDecoration(
            color: Colors.transparent, borderRadius: BorderRadius.circular(12)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: double.maxFinite,
              width: 150,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Image.network(
                  widget.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                width: 120,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${widget.name}",
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 20),
                    ),
                    Text("${widget.quantity} qty",
                        style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    Text(
                      "₹ ${widget.price}",
                      style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                    Text("₹ ${widget.total_price}",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 30,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                    child: FloatingActionButton(
                  mini: true,
                  heroTag: widget.index,
                  backgroundColor: const Color.fromARGB(255, 255, 200, 196),
                  onPressed: () async {
                    var document = await FirebaseFirestore.instance
                        .collection("Users")
                        .doc(uid)
                        .collection("Cart")
                        .where("pid", isEqualTo: widget.pid)
                        .get();
                    document.docs.forEach((doc) {
                      String docId = doc.id;
                      deleteDocument(docId);
                    });
                  },
                  child: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
