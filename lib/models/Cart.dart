class Cart {
  String image;
  String name;
  String pid;
  String price;
  String quantity;
  String totalPrice;

  Cart({
    required this.image,
    required this.name,
    required this.pid,
    required this.price,
    required this.quantity,
    required this.totalPrice,
  });

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        image: json["image"],
        name: json["name"],
        pid: json["pid"],
        price: json["price"],
        quantity: json["quantity"],
        totalPrice: json["total_price"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "name": name,
        "pid": pid,
        "price": price,
        "quantity": quantity,
        "total_price": totalPrice,
      };
}
