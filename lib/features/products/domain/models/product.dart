import 'review.dart';

class Product {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final List<String> tags;
  final String? brand;
  final String? sku;
  final String? warrantyInformation;
  final String? shippingInformation;
  final String? availabilityStatus;
  final List<Review> reviews;
  final String? returnPolicy;
  final int? minimumOrderQuantity;
  final List<String> images;
  final String thumbnail;

  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.tags,
    this.brand,
    this.sku,
    this.warrantyInformation,
    this.shippingInformation,
    this.availabilityStatus,
    required this.reviews,
    this.returnPolicy,
    this.minimumOrderQuantity,
    required this.images,
    required this.thumbnail,
  });

  /// Business Logic: Computes the original price prior to discount
  double get originalPrice {
    if (discountPercentage <= 0) return price;
    return price / (1 - (discountPercentage / 100));
  }

  /// Formatted current price, e.g., "$9.99"
  String get formattedPrice => '\$${price.toStringAsFixed(2)}';

  /// Formatted original price, e.g., "$12.99"
  String get formattedOriginalPrice => '\$${originalPrice.toStringAsFixed(2)}';

  /// Formatted discount percentage, e.g., "10% OFF"
  String get formattedDiscount => '${discountPercentage.round()}% OFF';
}
