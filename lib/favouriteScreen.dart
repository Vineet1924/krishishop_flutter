import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:krishishop/components/my_card.dart';
import 'package:krishishop/models/Products.dart';
import 'package:krishishop/product_details.dart';

class favouriteScreen extends StatefulWidget {
  const favouriteScreen({super.key});

  @override
  State<favouriteScreen> createState() => _favouriteScreenState();
}

class _favouriteScreenState extends State<favouriteScreen> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  List<Products> favProducts = [];

  Future<List<Products>> getFavouriteProducts() async {
    List<String> pids = [];
    try {
      QuerySnapshot<Map<String, dynamic>> favouriteSnapshot =
          await FirebaseFirestore.instance
              .collection("Users")
              .doc(uid)
              .collection("Favourite")
              .get();

      favouriteSnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data();
        pids.add(data["pid"]);
      });

      List<Products> favouriteProducts = [];

      for (String pid in pids) {
        DocumentSnapshot<Map<String, dynamic>> productSnapshot =
            await FirebaseFirestore.instance
                .collection('Products')
                .doc(pid)
                .get();

        if (productSnapshot.exists) {
          favouriteProducts.add(Products.fromSnapshot(productSnapshot));
        }
      }

      return favouriteProducts;
    } catch (e) {
      print(e);
      List<Products> list = [];
      return list;
    }
  }

  @override
  void initState() {
    super.initState();

    getFavouriteProducts().then((loadedProducts) {
      setState(() {
        favProducts = loadedProducts;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12),
              controller: ScrollController(keepScrollOffset: false),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: favProducts.length,
              itemBuilder: (context, Index) {
                final product = favProducts[Index];
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
                    name: favProducts[Index].name,
                    description: favProducts[Index].description,
                    quantity: favProducts[Index].quantity,
                    price: favProducts[Index].price,
                    image: favProducts[Index].images[0],
                    pid: product.pid,
                  ),
                );
              }),
        ),
      ),
    );
  }
}
