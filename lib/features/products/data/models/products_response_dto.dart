import '../../domain/models/product.dart';
import 'product_dto.dart';

class ProductsResponseDto {
  final List<ProductDto> products;
  final int total;
  final int skip;
  final int limit;

  const ProductsResponseDto({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory ProductsResponseDto.fromJson(Map<String, dynamic> json) {
    return ProductsResponseDto(
      products: (json['products'] as List<dynamic>?)
              ?.map((e) => ProductDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      total: json['total'] as int? ?? 0,
      skip: json['skip'] as int? ?? 0,
      limit: json['limit'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'products': products.map((p) => p.toJson()).toList(),
      'total': total,
      'skip': skip,
      'limit': limit,
    };
  }

  List<Product> toDomain() {
    return products.map((p) => p.toDomain()).toList();
  }
}
