import 'package:flutter/material.dart';
import '../models/food_item.dart';

class FoodService extends ChangeNotifier {
  List<FoodItem> _foodItems = [];
  List<FoodItem> _filteredFoodItems = [];
  bool _isLoading = false;
  String? _error;

  List<FoodItem> get foodItems => _foodItems;
  List<FoodItem> get filteredFoodItems => _filteredFoodItems;
  bool get isLoading => _isLoading;
  String? get error => _error;

  FoodService() {
    _initializeFoodItems();
  }

  void _initializeFoodItems() {
    _foodItems = [
      FoodItem(
        id: '1',
        name: 'Classic Burger',
        description: 'Juicy beef patty with fresh vegetables',
        price: 149,
        category: 'Burgers',
        imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd',
        preparationTime: 15,
        ingredients: ['Beef', 'Lettuce', 'Tomato', 'Cheese', 'Bun'],
      ),
      FoodItem(
        id: '2',
        name: 'Margherita Pizza',
        description: 'Fresh mozzarella with basil and tomato sauce',
        price: 249,
        category: 'Pizzas',
        imageUrl: 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002',
        preparationTime: 20,
        ingredients: ['Mozzarella', 'Tomato', 'Basil', 'Olive Oil'],
        isVegetarian: true,
      ),
      FoodItem(
        id: '3',
        name: 'Veg Thali',
        description: 'Complete meal with 4 vegetables, dal, rice and roti',
        price: 199,
        category: 'Thalis',
        imageUrl: 'https://images.unsplash.com/photo-1589308078059-be1415eab4c3',
        preparationTime: 25,
        ingredients: ['Dal', 'Rice', 'Roti', 'Vegetables'],
        isVegetarian: true,
      ),
      FoodItem(
        id: '4',
        name: 'Chicken Biryani',
        description: 'Aromatic basmati rice with tender chicken',
        price: 299,
        category: 'Biryani',
        imageUrl: 'https://images.unsplash.com/photo-1563379926898-05f4575a45d8',
        preparationTime: 30,
        ingredients: ['Chicken', 'Basmati Rice', 'Spices', 'Yogurt'],
      ),
      FoodItem(
        id: '5',
        name: 'French Fries',
        description: 'Crispy golden fries with seasoning',
        price: 99,
        category: 'Snacks',
        imageUrl: 'https://images.unsplash.com/photo-1576107232684-1279f390859f',
        preparationTime: 10,
        ingredients: ['Potato', 'Salt', 'Pepper'],
        isVegetarian: true,
      ),
      FoodItem(
        id: '6',
        name: 'Chocolate Brownie',
        description: 'Rich chocolate brownie with ice cream',
        price: 129,
        category: 'Desserts',
        imageUrl: 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c',
        preparationTime: 15,
        ingredients: ['Chocolate', 'Flour', 'Butter', 'Eggs'],
      ),
      FoodItem(
        id: '7',
        name: 'Mango Lassi',
        description: 'Refreshing yogurt drink with mango',
        price: 89,
        category: 'Beverages',
        imageUrl: 'https://images.unsplash.com/photo-1594642504020-95cc76e1d7e1',
        preparationTime: 5,
        ingredients: ['Yogurt', 'Mango', 'Sugar'],
        isVegetarian: true,
      ),
      FoodItem(
        id: '8',
        name: 'Cheese Pizza',
        description: 'Loaded with mozzarella and cheddar cheese',
        price: 279,
        category: 'Pizzas',
        imageUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591',
        preparationTime: 20,
        ingredients: ['Mozzarella', 'Cheddar', 'Tomato Sauce', 'Herbs'],
        isVegetarian: true,
      ),
    ];
    _filteredFoodItems = List.from(_foodItems);
    notifyListeners();
  }

  Future<void> loadFoodItems() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      _filteredFoodItems = List.from(_foodItems);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load food items';
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterByCategory(String? category) {
    if (category == null || category == 'All') {
      _filteredFoodItems = List.from(_foodItems);
    } else {
      _filteredFoodItems = _foodItems
          .where((item) => item.category == category)
          .toList();
    }
    notifyListeners();
  }

  void searchFoodItems(String query) {
    if (query.isEmpty) {
      _filteredFoodItems = List.from(_foodItems);
    } else {
      _filteredFoodItems = _foodItems
          .where((item) =>
      item.name.toLowerCase().contains(query.toLowerCase()) ||
          item.description.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}