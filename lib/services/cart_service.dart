import 'package:flutter/material.dart';
import '../models/food_item.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart'; // Optional, if not already initialized

class CartService extends ChangeNotifier {
  List<CartItem> _cartItems = [];
  double _deliveryFee = 30.0;
  double _taxRate = 0.05; // 5% tax

  List<CartItem> get cartItems => _cartItems;
  int get itemCount => _cartItems.length;
  double get deliveryFee => _deliveryFee;
  double get taxRate => _taxRate;

  double get subtotal {
    return _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  double get taxAmount {
    return subtotal * _taxRate;
  }

  double get totalAmount {
    return subtotal + _deliveryFee + taxAmount;
  }

  int get totalItems {
    return _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  // Add item to cart
  void addToCart(FoodItem foodItem, {int quantity = 1}) {
    final existingItemIndex = _cartItems.indexWhere(
            (item) => item.foodItemId == foodItem.id
    );

    if (existingItemIndex >= 0) {
      // Item already exists, update quantity
      _cartItems[existingItemIndex].quantity += quantity;
    } else {
      // Add new item
      _cartItems.add(
        CartItem(
          foodItemId: foodItem.id,
          name: foodItem.name,
          price: foodItem.price,
          quantity: quantity,
          imageUrl: foodItem.imageUrl,
          category: foodItem.category,
        ),
      );
    }

    notifyListeners();
  }

  // Remove item from cart
  void removeFromCart(String foodItemId) {
    _cartItems.removeWhere((item) => item.foodItemId == foodItemId);
    notifyListeners();
  }

  // Update item quantity
  void updateQuantity(String foodItemId, int quantity) {
    final index = _cartItems.indexWhere(
            (item) => item.foodItemId == foodItemId
    );

    if (index >= 0) {
      if (quantity <= 0) {
        removeFromCart(foodItemId);
      } else {
        _cartItems[index].quantity = quantity;
        notifyListeners();
      }
    }
  }

  // Increase quantity
  void increaseQuantity(String foodItemId) {
    final index = _cartItems.indexWhere(
            (item) => item.foodItemId == foodItemId
    );

    if (index >= 0) {
      _cartItems[index].quantity++;
      notifyListeners();
    }
  }

  // Decrease quantity
  void decreaseQuantity(String foodItemId) {
    final index = _cartItems.indexWhere(
            (item) => item.foodItemId == foodItemId
    );

    if (index >= 0) {
      if (_cartItems[index].quantity > 1) {
        _cartItems[index].quantity--;
        notifyListeners();
      } else {
        removeFromCart(foodItemId);
      }
    }
  }

  // Clear cart
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  // Check if item is in cart
  bool isInCart(String foodItemId) {
    return _cartItems.any((item) => item.foodItemId == foodItemId);
  }

  // Get item quantity
  int getItemQuantity(String foodItemId) {
    final item = _cartItems.firstWhere(
          (item) => item.foodItemId == foodItemId,
      orElse: () => CartItem(
        foodItemId: '',
        name: '',
        price: 0,
        quantity: 0,
      ),
    );
    return item.quantity;
  }

  // Set delivery fee
  void setDeliveryFee(double fee) {
    _deliveryFee = fee;
    notifyListeners();
  }

  // Set tax rate
  void setTaxRate(double rate) {
    _taxRate = rate;
    notifyListeners();
  }

  // Apply promo code
  bool applyPromoCode(String code) {
    // Sample promo codes
    const promoCodes = {
      'FIRSTORDER': 0.20, // 20% off
      'FOODLOVER': 0.15,  // 15% off
      'TASTY10': 0.10,    // 10% off
    };

    if (promoCodes.containsKey(code.toUpperCase())) {
      final discount = promoCodes[code.toUpperCase()]!;
      _deliveryFee *= (1 - discount);
      notifyListeners();
      return true;
    }
    return false;
  }

  // Convert cart to order items
  List<OrderItem> toOrderItems() {
    return _cartItems.map((item) => OrderItem(
      foodItemId: item.foodItemId,
      name: item.name,
      quantity: item.quantity,
      price: item.price,
      imageUrl: item.imageUrl,
    )).toList();
  }

  // Save cart for later (to local storage or database)
  Future<void> saveCart(String userId) async {
    final cartData = {
      'userId': userId,
      'items': _cartItems.map((item) => {
        'foodItemId': item.foodItemId,
        'name': item.name,
        'price': item.price,
        'quantity': item.quantity,
        'imageUrl': item.imageUrl,
        'category': item.category,
      }).toList(),
      'savedAt': FieldValue.serverTimestamp(),
    };

    try {
      await FirebaseFirestore.instance
          .collection('saved_carts')
          .doc(userId)
          .set(cartData);
    } catch (e) {
      debugPrint('Error saving cart: $e');
    }
  }

  // Load saved cart
  Future<void> loadSavedCart(String userId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('saved_carts')
          .doc(userId)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        final items = (data['items'] as List).map((item) => CartItem(
          foodItemId: item['foodItemId'],
          name: item['name'],
          price: item['price'].toDouble(),
          quantity: item['quantity'],
          imageUrl: item['imageUrl'],
          category: item['category'],
        )).toList();

        _cartItems = items;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading saved cart: $e');
    }
  }
}




