import 'package:flutter_test/flutter_test.dart';
import 'package:go_unicrew_task/features/products/data/models/product_model.dart';
import 'package:go_unicrew_task/features/products/data/models/products_response.dart';
import 'package:go_unicrew_task/features/products/data/models/review_model.dart';

void main() {
  group('ProductModel & ReviewModel Unit Tests', () {
    test('ReviewModel parses json correctly', () {
      final json = {
        'rating': 4.5,
        'comment': 'Super product!',
        'date': '2025-01-10',
        'reviewerName': 'Alex',
        'reviewerEmail': 'alex@example.com',
      };

      final review = ReviewModel.fromJson(json);
      expect(review.rating, 4.5);
      expect(review.comment, 'Super product!');
      expect(review.reviewerName, 'Alex');
      expect(review.reviewerEmail, 'alex@example.com');
    });

    test('ProductModel parses json and calculates pricing and discount', () {
      final json = {
        'id': 42,
        'title': 'Smartphone X',
        'description': 'Latest flagship phone',
        'category': 'smartphones',
        'price': 800.0,
        'discountPercentage': 20.0,
        'rating': 4.8,
        'stock': 15,
        'tags': ['electronics', 'phone'],
        'brand': 'FlagshipBrand',
        'sku': 'SM-001',
        'images': ['https://dummyjson.com/img1.png'],
        'thumbnail': 'https://dummyjson.com/thumb.png',
        'reviews': [
          {
            'rating': 5,
            'comment': 'Awesome phone',
            'date': '2025-02-01',
            'reviewerName': 'Sam',
            'reviewerEmail': 'sam@example.com',
          }
        ],
      };

      final product = ProductModel.fromJson(json);
      expect(product.id, 42);
      expect(product.title, 'Smartphone X');
      expect(product.formattedPrice, '\$800.00');
      expect(product.formattedDiscount, '20% OFF');
      // Original price with 20% discount = 800 / 0.8 = 1000
      expect(product.originalPrice, 1000.0);
      expect(product.formattedOriginalPrice, '\$1000.00');
      expect(product.reviews.length, 1);
    });

    test('ProductsResponse parses list response', () {
      final json = {
        'products': [
          {
            'id': 1,
            'title': 'Item 1',
            'price': 10.0,
            'thumbnail': 'https://dummyjson.com/1.png',
          }
        ],
        'total': 1,
        'skip': 0,
        'limit': 10,
      };

      final response = ProductsResponse.fromJson(json);
      expect(response.total, 1);
      expect(response.products.length, 1);
      expect(response.products.first.title, 'Item 1');
    });
  });
}
