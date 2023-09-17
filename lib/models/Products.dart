// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class Products {
  String pid;
  String description;
  String name;
  String quantity;
  List<dynamic> images;
  String price;

  Products(
      {required this.description,
      required this.name,
      required this.quantity,
      required this.images,
      required this.price,
      required this.pid});

  factory Products.fromSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Products(
      pid: doc.id,
      description: data["description"] ?? "",
      name: data["name"] ?? "",
      quantity: data["quantity"] ?? "",
      images: List<dynamic>.from(data["images"] ?? []),
      price: data["price"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "pid": pid,
        "description": description,
        "name": name,
        "quantity": quantity,
        "images": List<dynamic>.from(images.map((x) => x)),
        "price": price,
      };
}
