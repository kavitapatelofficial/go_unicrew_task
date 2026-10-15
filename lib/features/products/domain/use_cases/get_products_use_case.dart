import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository _repository;

  GetProductsUseCase(this._repository);

  Future<List<Product>> call({int limit = 50, int skip = 0, String? category}) async {
    if (category != null && category.isNotEmpty) {
      return await _repository.getProductsByCategory(category);
    }
    return await _repository.getProducts(limit: limit, skip: skip);
  }
}
