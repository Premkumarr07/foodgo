import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:flutter/material.dart';
import '../models/order.dart';

class OrderService extends ChangeNotifier {
  List<Order> _orders = [];
  bool _isLoading = false;
  String? _error;

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadUserOrders(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final snapshot = await firestore.FirebaseFirestore.instance
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      _orders = snapshot.docs
          .map((doc) => Order.fromJson({'id': doc.id, ...doc.data()}))
          .toList();
    } catch (e) {
      _error = 'Failed to load orders';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Stream<List<Order>> getUserOrdersStream(String userId) {
    return firestore.FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Order.fromJson({'id': doc.id, ...doc.data()}))
          .toList();
    });
  }

  Stream<Order> trackOrder(String orderId) {
    return firestore.FirebaseFirestore.instance
        .collection('orders')
        .doc(orderId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        return Order.fromJson({'id': snapshot.id, ...snapshot.data()!});
      }
      throw Exception('Order not found');
    });
  }

  Future<void> placeOrder(Order order) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final orderData = {
        'orderNumber': order.orderNumber,
        'userId': order.userId,
        'userName': order.userName,
        'userPhone': order.userPhone,
        'deliveryAddress': order.deliveryAddress,
        'items': order.items.map((item) => {
          'foodItemId': item.foodItemId,
          'name': item.name,
          'quantity': item.quantity,
          'price': item.price,
          'imageUrl': item.imageUrl,
        }).toList(),
        'subtotal': order.subtotal,
        'deliveryFee': order.deliveryFee,
        'totalAmount': order.totalAmount,
        'status': order.status,
        'createdAt': firestore.FieldValue.serverTimestamp(),
        'specialInstructions': order.specialInstructions,
        'paymentMethod': order.paymentMethod,
        'transactionId': order.transactionId,
        'deliveryLocation': order.deliveryLocation != null
            ? {
          'latitude': order.deliveryLocation!.latitude,
          'longitude': order.deliveryLocation!.longitude,
        }
            : null,
      };

      await firestore.FirebaseFirestore.instance
          .collection('orders')
          .add(orderData);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to place order';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      await firestore.FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .update({'status': status});
    } catch (e) {
      _error = 'Failed to update order status';
      notifyListeners();
    }
  }
}