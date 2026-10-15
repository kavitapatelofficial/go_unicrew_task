import '../models/product_model.dart';
import '../models/products_response.dart';
import '../services/product_api_service.dart';

class ProductRepository {
  final ProductApiService _apiService;

  ProductRepository({ProductApiService? apiService})
      : _apiService = apiService ?? ProductApiService();

  Future<ProductsResponse> getProducts({int limit = 30, int skip = 0}) async {
    return await _apiService.getProducts(limit: limit, skip: skip);
  }

  Future<ProductsResponse> searchProducts(String query, {int limit = 30, int skip = 0}) async {
    return await _apiService.searchProducts(query, limit: limit, skip: skip);
  }

  Future<ProductModel> getProductDetails(int id) async {
    return await _apiService.getProductById(id);
  }

  Future<List<String>> getCategories() async {
    return await _apiService.getCategories();
  }

  Future<ProductsResponse> getProductsByCategory(String category) async {
    return await _apiService.getProductsByCategory(category);
  }
}
