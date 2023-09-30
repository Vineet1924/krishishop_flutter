// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:krishishop/models/Order.dart';

class orderTracking extends StatefulWidget {
  OrderModel order;
  orderTracking({super.key, required this.order});

  @override
  State<orderTracking> createState() => _orderTrackingState();
}

class _orderTrackingState extends State<orderTracking> {
  int currentStep = 0;
  String orderDate = "";
  String packageDate = "";
  String deliveryDate = "";
  String shippmentDate = "";
  bool packaging = false;
  bool delivery = false;
  bool shippment = false;

  @override
  void initState() {
    super.initState();

    orderDate = widget.order.orderDate;
    packageDate = widget.order.packageDate;
    deliveryDate = widget.order.deliveryDate;
    shippmentDate = widget.order.shippmentDate;

    if (packageDate != "" && deliveryDate == "") {
      currentStep = 1;
      packaging = true;
    }
    if (shippmentDate != "") {
      currentStep = 2;
      packaging = true;
      shippment = true;
    }
    if (deliveryDate != "") {
      currentStep = 3;
      shippment = true;
      packaging = true;
      delivery = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tracking"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Theme(
              data: ThemeData(
                  colorScheme: ColorScheme.fromSwatch().copyWith(
                      primary: Colors.black, background: Colors.grey.shade300)),
              child: Stepper(
                steps: [
                  Step(
                    title: Text(
                      "Placed ${orderDate}",
                      style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    content: Padding(
                      padding: const EdgeInsets.only(right: 148.0),
                      child: Text(
                        "Order Placed at ${orderDate}",
                        style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    isActive: currentStep >= 0,
                  ),
                  Step(
                    title: packaging
                        ? Text(
                            "Order Packed at ${packageDate}",
                            style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          )
                        : Text(
                            "Packaging",
                            style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          ),
                    content: Padding(
                      padding: const EdgeInsets.only(right: 128.0),
                      child: Text(
                        "Order Packaged at ${packageDate}",
                        style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    isActive: currentStep >= 1,
                  ),
                  Step(
                    title: shippment
                        ? Text(
                            "Order Shipped at ${shippmentDate}",
                            style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          )
                        : Text(
                            "Shippment",
                            style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          ),
                    content: Padding(
                      padding: const EdgeInsets.only(right: 138.0),
                      child: Text(
                        "Order Shipping at ${shippmentDate}",
                        style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    isActive: currentStep >= 2,
                  ),
                  Step(
                    title: delivery
                        ? Text(
                            "Order Delivered at ${deliveryDate}",
                            style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          )
                        : Text(
                            "Delivery",
                            style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          ),
                    content: Padding(
                      padding: const EdgeInsets.only(right: 138.0),
                      child: Text(
                        "Order Delivered ${deliveryDate}",
                        style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    isActive: currentStep >= 3,
                  ),
                ],
                onStepTapped: (int index) {
                  setState(() {
                    currentStep = index;
                  });
                },
                currentStep: currentStep,
                type: StepperType.vertical,
                controlsBuilder:
                    (BuildContext context, ControlsDetails controls) {
                  return Container();
                },
                onStepContinue: null,
                onStepCancel: null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
