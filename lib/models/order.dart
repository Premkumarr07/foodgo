import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  final String id;
  final String orderNumber;
  final String userId;
  final String userName;
  final String userPhone;
  final String deliveryAddress;
  final List<OrderItem> items;
  final double subtotal;
  final double deliveryFee;
  final double totalAmount;
  final String status;
  final DateTime createdAt;
  final String? deliveryPartnerId;
  final String? deliveryPartnerName;
  final String? specialInstructions;
  final String? paymentMethod;
  final String? transactionId;
  final LatLng? deliveryLocation;

  Order({
    required this.id,
    required this.orderNumber,
    required this.userId,
    required this.userName,
    required this.userPhone,
    required this.deliveryAddress,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    this.deliveryPartnerId,
    this.deliveryPartnerName,
    this.specialInstructions,
    this.paymentMethod,
    this.transactionId,
    this.deliveryLocation,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      orderNumber: json['orderNumber'],
      userId: json['userId'],
      userName: json['userName'],
      userPhone: json['userPhone'],
      deliveryAddress: json['deliveryAddress'],
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      subtotal: json['subtotal'].toDouble(),
      deliveryFee: json['deliveryFee'].toDouble(),
      totalAmount: json['totalAmount'].toDouble(),
      status: json['status'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      deliveryPartnerId: json['deliveryPartnerId'],
      deliveryPartnerName: json['deliveryPartnerName'],
      specialInstructions: json['specialInstructions'],
      paymentMethod: json['paymentMethod'],
      transactionId: json['transactionId'],
      deliveryLocation: json['deliveryLocation'] != null
          ? LatLng(
        json['deliveryLocation']['latitude'],
        json['deliveryLocation']['longitude'],
      )
          : null,
    );
  }
}

class OrderItem {
  final String foodItemId;
  final String name;
  final int quantity;
  final double price;
  final String? imageUrl;

  OrderItem({
    required this.foodItemId,
    required this.name,
    required this.quantity,
    required this.price,
    this.imageUrl,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      foodItemId: json['foodItemId'],
      name: json['name'],
      quantity: json['quantity'],
      price: json['price'].toDouble(),
      imageUrl: json['imageUrl'],
    );
  }
}

class LatLng {
  final double latitude;
  final double longitude;

  LatLng(this.latitude, this.longitude);
}