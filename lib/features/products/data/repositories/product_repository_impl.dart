import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../services/product_api_service.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductApiService _apiService;

  ProductRepositoryImpl({ProductApiService? apiService})
      : _apiService = apiService ?? ProductApiService();

  @override
  Future<List<Product>> getProducts({int limit = 30, int skip = 0}) async {
    final dto = await _apiService.getProducts(limit: limit, skip: skip);
    return dto.toDomain();
  }

  @override
  Future<List<Product>> searchProducts(String query, {int limit = 30, int skip = 0}) async {
    final dto = await _apiService.searchProducts(query, limit: limit, skip: skip);
    return dto.toDomain();
  }

  @override
  Future<Product> getProductDetails(int id) async {
    final dto = await _apiService.getProductById(id);
    return dto.toDomain();
  }

  @override
  Future<List<String>> getCategories() async {
    return await _apiService.getCategories();
  }

  @override
  Future<List<Product>> getProductsByCategory(String category) async {
    final dto = await _apiService.getProductsByCategory(category);
    return dto.toDomain();
  }
}
