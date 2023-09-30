// ignore_for_file: must_be_immutable, unused_local_variable
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:krishishop/components/icon_tile.dart';
import 'package:krishishop/components/my_button.dart';
import 'package:krishishop/components/my_textfield.dart';
import 'package:krishishop/dasboard.dart';
import 'package:krishishop/models/Cart.dart';
import 'package:krishishop/models/user.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:krishishop/models/Order.dart';

class OrderSammary extends StatefulWidget {
  int items = 0;
  int totalAmount = 0;
  List<Cart> order_items;

  OrderSammary({
    super.key,
    required this.items,
    required this.totalAmount,
    required this.order_items,
  });

  @override
  State<OrderSammary> createState() => _OrderSammaryState();
}

class _OrderSammaryState extends State<OrderSammary> {
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final usernameController = TextEditingController();
  bool showSuffixIcon = false;
  String currentLocation = '';
  var razorpay = Razorpay();
  User? auth = FirebaseAuth.instance.currentUser;
  userModel? getUser;

  @override
  void initState() {
    super.initState();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentFailure);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
    loadUser();
  }

  Future<void> loadUser() async {
    getUser =
        await userModel.getUserData(FirebaseAuth.instance.currentUser!.uid);
    setState(() {
      if (getUser?.address != null) {
        addressController.text = getUser!.address!;
      } else {
        addressController.text = "";
      }

      if (getUser?.phone != null) {
        phoneController.text = getUser!.phone!;
      } else {
        phoneController.text = "";
      }

      if (getUser?.username != null) {
        usernameController.text = getUser!.username!;
      } else {
        usernameController.text = "";
      }
    });
  }

  Future<void> updateProductQuantity(List<Cart> items) async {
    final firestore = FirebaseFirestore.instance;

    try {
      for (Cart cartItem in items) {
        String pid = cartItem.pid;
        int decrementAmount = int.parse(cartItem.quantity);

        final ref = firestore.collection("Products").doc(pid);
        await firestore.runTransaction((transaction) async {
          DocumentSnapshot<Map<String, dynamic>> productSnapshot =
              await transaction.get(ref);

          if (productSnapshot.exists) {
            final currentQuantity = productSnapshot['quantity'] ?? 0;
            final newQuantity = int.parse(currentQuantity) - decrementAmount;

            if (newQuantity >= 0) {
              transaction.update(ref, {'quantity': newQuantity.toString()});
            } else {
              transaction.update(ref, {'quantity': '0'});
            }
          }
        });

        print("Quantity updated");
      }
    } catch (e) {
      print("Error ${e}");
    }
  }

  String generateOrderId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final random = Random().nextInt(10000);
    final uniqueId = '$timestamp$random';
    return uniqueId;
  }

  String formatDate(DateTime dateTime) {
    final formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(dateTime);
  }

  Future<void> cleanCart() async {
    final userCollection = FirebaseFirestore.instance
        .collection("Users")
        .doc(auth!.uid)
        .collection("Cart");
    final querySnapshot = await userCollection.get();

    for (final cartDocument in querySnapshot.docs) {
      await cartDocument.reference.delete();
    }
  }

  Future<void> createOrder() async {
    final userDoc = await FirebaseFirestore.instance
        .collection("Users")
        .doc(auth?.uid)
        .get();
    CollectionReference<Map<String, dynamic>> orderCollection =
        FirebaseFirestore.instance.collection("Orders");

    try {
      DateTime dateTime = DateTime.now();
      String order_Id = generateOrderId();
      String user_Id = FirebaseAuth.instance.currentUser!.uid;
      String totalAmount = widget.totalAmount.toString();
      String orderDate = formatDate(dateTime).toString();
      String order_status = "Placed";
      String? email = auth?.email;
      String imageLink = widget.order_items[0].image;
      String address = addressController.text;
      String name = usernameController.text;
      List<String>? items = [];

      for (Cart item in widget.order_items) {
        print(item.pid);
        items.add(item.pid);
      }
      var order = OrderModel(
          order_Id: order_Id,
          user_Id: user_Id,
          totalAmount: totalAmount,
          orderDate: orderDate,
          items: items,
          order_status: order_status,
          email: email!,
          imageLink: imageLink,
          address: address,
          customerName: name,
          deliveryDate: "",
          packageDate: "",
          shippmentDate: "");
      await orderCollection.doc(order.order_Id).set(order.toJson());
      print("Order saved");
    } catch (e) {
      print(e);
    }
  }

  Future<void> handlePaymentSuccess(PaymentSuccessResponse response) async {
    print("Payment Success");
    EasyLoading.show(status: "Placing Order");
    await updateProductQuantity(widget.order_items);
    await createOrder();
    await cleanCart();
    EasyLoading.dismiss();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Dashboard()));
  }

  void handlePaymentFailure(PaymentFailureResponse response) {
    print("Payment Fail");
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    print("Payment External Wallet");
  }

  @override
  void dispose() {
    addressController.dispose();
    razorpay.clear();
    super.dispose();
  }

  Future<void> fetchLocation() async {
    EasyLoading.show(status: "Fetching Location");
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      print('Location permission denied. Please enable it in settings.');
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      Placemark placemark = placemarks.first;
      setState(() {
        currentLocation = placemark.street ?? '';
        addressController.text = currentLocation;
      });
    }
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.grey.shade900,
            centerTitle: true,
            title: Text(
              "Krishishop",
              style: TextStyle(color: Colors.white),
            )),
        body: Stack(children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MyTextField(
                    controller: usernameController,
                    hintText: "Username",
                    obscureText: false,
                    inputType: TextInputType.text,
                    isEditable: true),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 25,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 6,
                        child: MyTextField(
                            controller: addressController,
                            hintText: "Address",
                            obscureText: false,
                            inputType: TextInputType.text,
                            isEditable: true),
                      ),
                      Expanded(
                          flex: 1,
                          child: GestureDetector(
                              onTap: () {
                                fetchLocation();
                              },
                              child: iconTile(
                                  icon: Icon(Icons.location_on_sharp))))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 24, right: 25, top: 20),
                  child: TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600),
                    decoration: InputDecoration(
                      disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400)),
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      hintText: "Phone",
                      prefix: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          '(+91)',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      suffixIcon: showSuffixIcon
                          ? Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 32,
                            )
                          : null,
                    ),
                    onChanged: (value) {
                      setState(() {
                        showSuffixIcon = value.length == 10;
                      });
                    },
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: 340,
                  height: 212,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade500)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Price details",
                          style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                        Divider(
                          thickness: 0.8,
                          color: Colors.grey[400],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 220,
                              height: 30,
                              decoration:
                                  BoxDecoration(color: Colors.transparent),
                              child: Text(
                                "Products ( ${widget.items} )",
                                style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                "₹ ${widget.totalAmount}",
                                style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400),
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 220,
                              height: 40,
                              decoration:
                                  BoxDecoration(color: Colors.transparent),
                              child: Text(
                                "Delivery charges",
                                style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            Text(
                              "Free",
                              style: TextStyle(
                                  color: Colors.green.shade600,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        DottedLine(
                          direction: Axis.horizontal,
                          lineLength: double.infinity,
                          lineThickness: 1.0,
                          dashLength: 4.0,
                          dashColor: Colors.grey,
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 220,
                              height: 30,
                              decoration:
                                  BoxDecoration(color: Colors.transparent),
                              child: Text(
                                "Total",
                                style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                "₹ ${widget.totalAmount}",
                                style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400),
                              ),
                            )
                          ],
                        ),
                        Divider(
                          thickness: 0.8,
                          color: Colors.grey[400],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            top: 670,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 122,
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
                      child: MyButton(
                          onTap: () {
                            if (addressController.text == "") {
                              final snackBar = SnackBar(
                                content: Text(
                                  'Enter Address',
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.red,
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else if (phoneController.text == "") {
                              final snackBar = SnackBar(
                                content: Text(
                                  'Enter Phone Number',
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.red,
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else if (phoneController.text.length != 10) {
                              final snackBar = SnackBar(
                                content: Text(
                                  'Enter Valid Phone Number',
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.red,
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else if (usernameController.text == "") {
                              final snackBar = SnackBar(
                                content: Text(
                                  'Enter Valid username',
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.red,
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else {
                              var options = {
                                'key': 'rzp_test_ZTKnRxhscGAf0S',
                                'amount': (widget.totalAmount * 100).toString(),
                                'name': 'Krishishop',
                                //'order_id': 'order_EMBFqjDHEEn80l',
                                'description': 'Krishishop description',
                                'timeout': 300,
                                'prefill': {
                                  'contact': phoneController.text,
                                  'email': auth?.email.toString(),
                                }
                              };
                              razorpay.open(options);
                            }
                          },
                          title: "Place Order")),
                ],
              ),
            ),
          ),
        ]));
  }
}
