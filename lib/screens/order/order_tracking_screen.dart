import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as maps;
import '../../models/order.dart';
import '../../widgets/delivery_tracker.dart';
import '../../services/order_service.dart';

class OrderTrackingScreen extends StatefulWidget {
  final String orderId;

  const OrderTrackingScreen({
    super.key,
    required this.orderId,
  });

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  maps.GoogleMapController? _mapController;
  Set<maps.Marker> _markers = {};
  Set<maps.Polyline> _polylines = {};
  maps.LatLng? _deliveryPartnerLocation;
  int _currentStep = 0;

  final List<String> _statusSteps = [
    'Order Confirmed',
    'Food Being Prepared',
    'Out for Delivery',
    'Delivered',
  ];

  @override
  void initState() {
    super.initState();
    _initializeMap();
    _trackOrder();
  }

  void _initializeMap() {
    _markers.add(
      maps.Marker(
        markerId: const maps.MarkerId('restaurant'),
        position: maps.LatLng(12.9716, 77.5946),
        infoWindow: const maps.InfoWindow(title: 'Tasty Bites Restaurant'),
        icon: maps.BitmapDescriptor.defaultMarkerWithHue(
            maps.BitmapDescriptor.hueGreen),
      ),
    );
  }

  void _trackOrder() {
    context.read<OrderService>().trackOrder(widget.orderId).listen(
          (order) {
        setState(() {
          _currentStep = _getCurrentStep(order.status);
          _updateDeliveryPartnerLocation(order);
        });
      },
      onError: (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error tracking order: $error')),
        );
      },
    );
  }

  void _updateDeliveryPartnerLocation(Order order) {
    if (order.deliveryLocation != null) {
      setState(() {
        _deliveryPartnerLocation = maps.LatLng(
          order.deliveryLocation!.latitude,
          order.deliveryLocation!.longitude,
        );
        _markers.add(
          maps.Marker(
            markerId: const maps.MarkerId('delivery_partner'),
            position: _deliveryPartnerLocation!,
            infoWindow: const maps.InfoWindow(title: 'Delivery Partner'),
            icon: maps.BitmapDescriptor.defaultMarkerWithHue(
              maps.BitmapDescriptor.hueBlue,
            ),
          ),
        );
      });
    }
  }

  int _getCurrentStep(String status) {
    switch (status) {
      case 'confirmed':
        return 0;
      case 'preparing':
        return 1;
      case 'out_for_delivery':
        return 2;
      case 'delivered':
        return 3;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Order'),
        elevation: 0,
      ),
      body: StreamBuilder<Order>(
        stream: context.read<OrderService>().trackOrder(widget.orderId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final order = snapshot.data!;

          return Column(
            children: [
              _buildMapSection(order),
              _buildStatusSection(order),
              _buildDeliveryPartnerInfo(order),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMapSection(Order order) {
    return Expanded(
      flex: 2,
      child: maps.GoogleMap(
        onMapCreated: (controller) => _mapController = controller,
        initialCameraPosition: maps.CameraPosition(
          target: maps.LatLng(12.9716, 77.5946),
          zoom: 14,
        ),
        markers: _markers,
        polylines: _polylines,
      ),
    );
  }

  Widget _buildStatusSection(Order order) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Status',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            DeliveryTracker(
              currentStep: _currentStep,
              steps: _statusSteps,
            ),
            const SizedBox(height: 16),
            _buildOrderDetails(order),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderDetails(Order order) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order #${order.orderNumber}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Total: ₹${order.totalAmount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryPartnerInfo(Order order) {
    if (order.status != 'out_for_delivery' && order.status != 'delivered') {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(
              order.deliveryPartnerId != null
                  ? 'https://randomuser.me/api/portraits/men/32.jpg'
                  : 'https://via.placeholder.com/50',
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.deliveryPartnerName ?? 'Delivery Partner',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  order.status == 'delivered'
                      ? 'Order Delivered'
                      : 'On the way to you',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          if (order.status == 'out_for_delivery') ...[
            IconButton(
              icon: const Icon(Icons.phone, color: Colors.green),
              onPressed: () {
                // Make phone call
              },
            ),
            IconButton(
              icon: const Icon(Icons.chat_bubble_outline, color: Colors.blue),
              onPressed: () {
                // Open chat
              },
            ),
          ],
        ],
      ),
    );
  }
}