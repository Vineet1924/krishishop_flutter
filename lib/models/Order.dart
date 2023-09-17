// ignore_for_file: file_names

import 'package:krishishop/models/Cart.dart';

class OrderModel {
  String order_Id;
  String user_Id;
  String totalAmount;
  String orderDate;
  List<String> items;
  String order_status;
  String email;

  OrderModel({
    required this.order_Id,
    required this.user_Id,
    required this.totalAmount,
    required this.orderDate,
    required this.items,
    required this.order_status,
    required this.email
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        order_Id: json["order_Id"],
        user_Id: json["user_Id"],
        totalAmount: json["totalAmount"],
        orderDate: json["orderDate"],
        items: List<String>.from(json["items"].map((x) => x)),
        order_status: json["order_status"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "order_Id": order_Id,
        "user_Id": user_Id,
        "totalAmount": totalAmount,
        "orderDate": orderDate,
        "items": List<String>.from(items.map((x) => x)),
        "order_status": order_status,
        "email":email
      };
}
