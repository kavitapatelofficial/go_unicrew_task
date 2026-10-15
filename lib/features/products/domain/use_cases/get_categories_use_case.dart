import '../repositories/product_repository.dart';

class GetCategoriesUseCase {
  final ProductRepository _repository;

  GetCategoriesUseCase(this._repository);

  Future<List<String>> call() async {
    return await _repository.getCategories();
  }
}
