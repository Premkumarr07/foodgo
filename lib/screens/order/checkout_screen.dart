import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../models/order.dart';
import '../../services/auth_service.dart';
import '../../services/cart_service.dart';
import '../../services/order_service.dart';
import '../../widgets/custom_button.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _instructionsController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthService>().currentUser;
    if (user?.address != null) {
      _addressController.text = user!.address!;
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final cartService = context.read<CartService>();
    final authService = context.read<AuthService>();
    final orderService = context.read<OrderService>();

    final order = Order(
      id: const Uuid().v4(),
      orderNumber: _generateOrderNumber(),
      userId: authService.currentUser!.id,
      userName: authService.currentUser!.name,
      userPhone: authService.currentUser!.phone,
      deliveryAddress: _addressController.text.trim(),
      items: cartService.toOrderItems(),
      subtotal: cartService.subtotal,
      deliveryFee: cartService.deliveryFee,
      totalAmount: cartService.totalAmount,
      status: 'confirmed',
      createdAt: DateTime.now(),
      specialInstructions: _instructionsController.text.trim(),
      paymentMethod: 'Cash on Delivery', // only COD
    );

    try {
      await orderService.placeOrder(order);
      cartService.clearCart();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order placed successfully!')),
      );
      Navigator.pushReplacementNamed(context, '/order-tracking',
          arguments: order.id);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to place order: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String _generateOrderNumber() {
    final now = DateTime.now();
    return 'TB${now.year}${now.month}${now.day}${now.millisecond}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Consumer<CartService>(
        builder: (context, cartService, child) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDeliveryAddressSection(),
                        const SizedBox(height: 20),
                        _buildOrderSummary(cartService),
                        const SizedBox(height: 20),
                        _buildSpecialInstructionsSection(),
                      ],
                    ),
                  ),
                ),
              ),
              _buildPlaceOrderButton(cartService),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDeliveryAddressSection() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('Delivery Address',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      TextFormField(
        controller: _addressController,
        maxLines: 3,
        decoration: InputDecoration(
          hintText: 'Enter your delivery address',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (v) => v!.isEmpty ? 'Required' : null,
      ),
    ],
  );

  Widget _buildOrderSummary(CartService cartService) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('Order Summary',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: cartService.cartItems.length,
        itemBuilder: (_, i) {
          final item = cartService.cartItems[i];
          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(item.imageUrl ?? '', width: 50, height: 50,
                  fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.restaurant)),
            ),
            title: Text(item.name),
            subtitle: Text('₹${item.price} x ${item.quantity}'),
            trailing: Text('₹${item.totalPrice.toStringAsFixed(2)}'),
          );
        },
      ),
      const Divider(height: 24),
      _summaryRow('Subtotal', '₹${cartService.subtotal.toStringAsFixed(2)}'),
      _summaryRow('Delivery Fee', '₹${cartService.deliveryFee.toStringAsFixed(2)}'),
      _summaryRow('Tax', '₹${cartService.taxAmount.toStringAsFixed(2)}'),
      const Divider(height: 24),
      _summaryRow('Total', '₹${cartService.totalAmount.toStringAsFixed(2)}',
          bold: true, fontSize: 18),
    ],
  );

  Widget _buildSpecialInstructionsSection() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('Special Instructions',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      TextFormField(
        controller: _instructionsController,
        maxLines: 3,
        decoration: InputDecoration(
          hintText: 'e.g. No onions, extra spicy...',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    ],
  );

  Widget _summaryRow(String label, String value,
      {bool bold = false, double fontSize = 14}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
          Text(value,
              style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  Widget _buildPlaceOrderButton(CartService cartService) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 10,
          offset: const Offset(0, -5),
        ),
      ],
    ),
    child: CustomButton(
      text: 'Place Order',
      onPressed: _placeOrder,
      isLoading: _isLoading,
    ),
  );
}