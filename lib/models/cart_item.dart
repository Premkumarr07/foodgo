class CartItem {
  final String foodItemId;
  final String name;
  final double price;
  int quantity;
  final String? imageUrl;
  final String? category;

  CartItem({
    required this.foodItemId,
    required this.name,
    required this.price,
    this.quantity = 1,
    this.imageUrl,
    this.category,
  });

  double get totalPrice => price * quantity;

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      foodItemId: json['foodItemId'],
      name: json['name'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],
      imageUrl: json['imageUrl'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'foodItemId': foodItemId,
      'name': name,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
      'category': category,
    };
  }
}