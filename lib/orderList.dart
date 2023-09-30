import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:krishishop/models/Order.dart';
import 'package:krishishop/orderTracking.dart';

class orderList extends StatefulWidget {
  const orderList({super.key});

  @override
  State<orderList> createState() => _orderListState();
}

class _orderListState extends State<orderList> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> orderStream;
  String user_Id = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();

    orderStream = FirebaseFirestore.instance
        .collection("Orders")
        .where('user_Id', isEqualTo: user_Id)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders"),
        centerTitle: true,
      ),
      body: Padding(
          padding: EdgeInsets.all(12),
          child: StreamBuilder(
            stream: orderStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("");
              } else if (snapshot.hasError) {
                return const Text("");
              } else {
                final documents = snapshot.data!.docs;
                List<OrderModel> orders = documents
                    .map((order) => OrderModel(
                        order_Id: order['order_Id'],
                        user_Id: order['user_Id'],
                        totalAmount: order['totalAmount'],
                        orderDate: order['orderDate'],
                        items: order['items'],
                        order_status: order['order_status'],
                        email: order['email'],
                        imageLink: order['imageLink'],
                        address: order['address'],
                        packageDate: order['packageDate'],
                        deliveryDate: order['deliveryDate'],
                        shippmentDate: order['shippmentDate'],
                        customerName: order['customerName']))
                    .toList();
                return ListView.builder(
                    controller: ScrollController(keepScrollOffset: false),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => orderTracking(order: orders[index],)));
                        },
                        child: ListTile(
                          leading: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(150),
                            ),
                            child: ClipOval(
                                child: Image.network(orders[index].imageLink,
                                    fit: BoxFit.cover)),
                          ),
                          title: Padding(
                              padding: EdgeInsets.only(left: 5, top: 5),
                              child: Text(
                                orders[index].email,
                                style: TextStyle(
                                    color: Colors.grey.shade800,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                              )),
                          subtitle: Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Text(
                              orders[index].address,
                              style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          trailing: Text(
                            "₹ ${orders[index].totalAmount}",
                            style: TextStyle(
                                color: Colors.green.shade500,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      );
                    });
              }
            },
          )),
    );
  }
}
