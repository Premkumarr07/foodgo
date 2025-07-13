class FoodItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String imageUrl;
  final double rating;
  final int preparationTime;
  final List<String> ingredients;
  final bool isVegetarian;
  final bool isAvailable;

  FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
    this.rating = 4.5,
    required this.preparationTime,
    required this.ingredients,
    this.isVegetarian = true,
    this.isAvailable = true,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      category: json['category'],
      imageUrl: json['imageUrl'],
      rating: json['rating']?.toDouble() ?? 4.5,
      preparationTime: json['preparationTime'],
      ingredients: List<String>.from(json['ingredients'] ?? []),
      isVegetarian: json['isVegetarian'] ?? true,
      isAvailable: json['isAvailable'] ?? true,
    );
  }
}