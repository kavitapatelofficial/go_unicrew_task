import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductDetailUseCase {
  final ProductRepository _repository;

  GetProductDetailUseCase(this._repository);

  Future<Product> call(int id) async {
    return await _repository.getProductDetails(id);
  }
}
