class DeliveryPartner {
  final String id;
  final String name;
  final String phone;
  final String vehicleNumber;
  final String profileImage;
  final double rating;
  final LatLng currentLocation;
  final LatLng restaurantLocation;
  final LatLng deliveryLocation;

  DeliveryPartner({
    required this.id,
    required this.name,
    required this.phone,
    required this.vehicleNumber,
    required this.profileImage,
    this.rating = 4.8,
    required this.currentLocation,
    required this.restaurantLocation,
    required this.deliveryLocation,
  });
}

class LatLng {
  final double latitude;
  final double longitude;

  LatLng(this.latitude, this.longitude);
}