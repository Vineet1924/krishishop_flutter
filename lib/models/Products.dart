// ignore_for_file: file_names

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

  factory Products.fromJson(Map<String, dynamic> json) => Products(
        pid: json["pid"],
        description: json["description"],
        name: json["name"],
        quantity: json["quantity"],
        images: List<String>.from(json["images"].map((x) => x)),
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "pid": pid,
        "description": description,
        "name": name,
        "quantity": quantity,
        "images": List<dynamic>.from(images.map((x) => x)),
        "price": price,
      };
}
