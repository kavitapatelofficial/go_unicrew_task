import 'package:flutter_test/flutter_test.dart';
import 'package:go_unicrew_task/features/products/data/models/product_dto.dart';
import 'package:go_unicrew_task/features/products/data/models/products_response_dto.dart';
import 'package:go_unicrew_task/features/products/data/models/review_dto.dart';

void main() {
  group('ProductDto & Domain Model Unit Tests', () {
    test('ReviewDto parses json correctly and converts to Domain entity', () {
      final json = {
        'rating': 4.5,
        'comment': 'Super product!',
        'date': '2025-01-10',
        'reviewerName': 'Alex',
        'reviewerEmail': 'alex@example.com',
      };

      final reviewDto = ReviewDto.fromJson(json);
      expect(reviewDto.rating, 4.5);
      expect(reviewDto.comment, 'Super product!');
      expect(reviewDto.reviewerName, 'Alex');

      final domainReview = reviewDto.toDomain();
      expect(domainReview.rating, 4.5);
      expect(domainReview.comment, 'Super product!');
      expect(domainReview.reviewerName, 'Alex');
    });

    test('ProductDto parses json, maps to domain Product and calculates pricing', () {
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

      final productDto = ProductDto.fromJson(json);
      final product = productDto.toDomain();

      expect(product.id, 42);
      expect(product.title, 'Smartphone X');
      expect(product.formattedPrice, '\$800.00');
      expect(product.formattedDiscount, '20% OFF');
      // Original price with 20% discount = 800 / 0.8 = 1000
      expect(product.originalPrice, 1000.0);
      expect(product.formattedOriginalPrice, '\$1000.00');
      expect(product.reviews.length, 1);
    });

    test('ProductsResponseDto parses list response and converts to domain list', () {
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

      final responseDto = ProductsResponseDto.fromJson(json);
      expect(responseDto.total, 1);
      final domainProducts = responseDto.toDomain();
      expect(domainProducts.length, 1);
      expect(domainProducts.first.title, 'Item 1');
    });
  });
}
