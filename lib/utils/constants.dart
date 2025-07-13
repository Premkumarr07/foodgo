class AppConstants {
  // App Info
  static const String appName = 'Tasty Bites';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Delicious food delivered to your doorstep';

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String foodItemsCollection = 'food_items';
  static const String ordersCollection = 'orders';
  static const String cartCollection = 'cart';
  static const String promoCodesCollection = 'promo_codes';

  // Default Values
  static const double defaultDeliveryFee = 30.0;
  static const double defaultTaxRate = 0.05; // 5%
  static const int defaultPreparationTime = 20; // minutes

  // Promo Codes
  static const Map<String, double> promoCodes = {
    'FIRSTORDER': 0.20, // 20% off
    'FOODLOVER': 0.15,  // 15% off
    'TASTY10': 0.10,    // 10% off
    'WELCOME5': 0.05,   // 5% off
  };

  // Order Status
  static const List<String> orderStatuses = [
    'confirmed',
    'preparing',
    'out_for_delivery',
    'delivered',
    'cancelled',
  ];

  // Categories
  static const List<String> foodCategories = [
    'All',
    'Burgers',
    'Pizzas',
    'Thalis',
    'Biryani',
    'Snacks',
    'Desserts',
    'Beverages',
  ];

  // Error Messages
  static const String networkError = 'Network error. Please try again.';
  static const String serverError = 'Server error. Please try again later.';
  static const String unknownError = 'Something went wrong. Please try again.';

  // Success Messages
  static const String orderPlacedSuccess = 'Order placed successfully!';
  static const String profileUpdatedSuccess = 'Profile updated successfully!';
  static const String itemAddedToCart = 'Item added to cart';

  // Validation Messages
  static const String emailRequired = 'Please enter your email';
  static const String emailInvalid = 'Please enter a valid email';
  static const String passwordRequired = 'Please enter your password';
  static const String passwordTooShort = 'Password must be at least 6 characters';
  static const String nameRequired = 'Please enter your name';
  static const String phoneRequired = 'Please enter your phone number';
  static const String phoneInvalid = 'Phone number must be 10 digits';
  static const String addressRequired = 'Please enter delivery address';
}