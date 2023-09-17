import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:krishishop/components/my_card.dart';
import 'package:krishishop/models/Products.dart';
import 'package:krishishop/product_details.dart';

class searchScreen extends StatefulWidget {
  const searchScreen({super.key});

  @override
  State<searchScreen> createState() => _searchScreenState();
}

class _searchScreenState extends State<searchScreen> {
  final searchController = TextEditingController();
  List<Products> allProducts = [];
  List<Products> displayedProducts = [];
  bool isEmpty = false;

  Future<List<Products>> fetchProducts() async {
    List<Products> productList = [];

    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('Products').get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> doc
        in querySnapshot.docs) {
      Products product = Products.fromSnapshot(doc);
      productList.add(product);
    }

    return productList;
  }

  @override
  void initState() {
    super.initState();

    fetchProducts().then((loadedProducts) {
      setState(() {
        allProducts = loadedProducts;
        displayedProducts = loadedProducts;
      });
    });
  }

  void runSearch(String keyword) {
    List<Products> result = [];

    if (keyword.isEmpty) {
      result = allProducts;
    } else {
      result = allProducts
          .where((Products) =>
              Products.name.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    }

    setState(() {
      displayedProducts = result;
      isEmpty = result.isEmpty;
      print(isEmpty);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                border: Border.all(color: Colors.grey.shade400),
                color: Colors.grey.shade200,
              ),
              child: TextField(
                controller: searchController,
                onChanged: (keyword) => runSearch(keyword),
                decoration: InputDecoration(
                  disabledBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintText: "Search",
                  contentPadding: EdgeInsets.all(12.0),
                  suffixIcon: Icon(
                    Icons.search_rounded,
                    color: Colors.grey.shade600,
                  ),
                ),
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
            SizedBox(height: 20),
            if (!isEmpty)
              GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12),
                  controller: ScrollController(keepScrollOffset: false),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: displayedProducts.length,
                  itemBuilder: (context, Index) {
                    final product = displayedProducts[Index];
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
                        name: displayedProducts[Index].name,
                        description: displayedProducts[Index].description,
                        quantity: displayedProducts[Index].quantity,
                        price: displayedProducts[Index].price,
                        image: displayedProducts[Index].images[0],
                        pid: product.pid,
                      ),
                    );
                  }),
            if (isEmpty)
              Text(
                "Result not found",
                style: TextStyle(fontSize: 40, color: Colors.grey.shade700),
              ),
          ],
        ),
      ),
    );
  }
}
