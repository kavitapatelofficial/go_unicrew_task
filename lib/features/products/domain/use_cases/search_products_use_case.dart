import '../entities/product.dart';
import '../repositories/product_repository.dart';

class SearchProductsUseCase {
  final ProductRepository _repository;

  SearchProductsUseCase(this._repository);

  Future<List<Product>> call(String query, {int limit = 50, int skip = 0}) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return await _repository.getProducts(limit: limit, skip: skip);
    }
    return await _repository.searchProducts(trimmed, limit: limit, skip: skip);
  }
}
