import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:krishishop/components/my_card.dart';
import 'models/Products.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  List<Products> products = [];

  @override
  void initState() {
    super.initState();

    fetchProducts();
  }

  void fetchProducts() async {
    var documents =
        await FirebaseFirestore.instance.collection("Products").get();
    mapProducts(documents);
  }

  mapProducts(QuerySnapshot<Map<String, dynamic>> documents) {
    var productsList = documents.docs
        .map((products) => Products(
            description: products['description'],
            name: products['name'],
            quantity: products['quantity'],
            images: products['images'],
            price: products['price']))
        .toList();

    setState(() {
      products = productsList;
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12),
            controller: ScrollController(keepScrollOffset: false),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: products.length,
            itemBuilder: (context, Index) {
              return Container(
                height: 350,
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.grey.shade400, width: 2)),
                child: myCard(
                  index: Index,
                  name: products[Index].name,
                  description: products[Index].description,
                  quantity: products[Index].quantity,
                  price: products[Index].price,
                  image: products[Index].images[0],
                ),
              );
            }),
      ),
    );
  }
}
