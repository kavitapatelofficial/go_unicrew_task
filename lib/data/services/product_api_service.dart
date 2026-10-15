import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/product_model.dart';
import '../models/products_response.dart';

class ProductApiService {
  final ApiClient _apiClient;

  ProductApiService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// Fetches a paginated list of products
  Future<ProductsResponse> getProducts({int limit = ApiConstants.defaultLimit, int skip = 0}) async {
    final response = await _apiClient.get(
      ApiConstants.productsEndpoint,
      queryParameters: {'limit': limit, 'skip': skip},
    );
    return ProductsResponse.fromJson(response as Map<String, dynamic>);
  }

  /// Searches products with the given query
  Future<ProductsResponse> searchProducts(String query, {int limit = ApiConstants.defaultLimit, int skip = 0}) async {
    final response = await _apiClient.get(
      ApiConstants.searchEndpoint,
      queryParameters: {'q': query, 'limit': limit, 'skip': skip},
    );
    return ProductsResponse.fromJson(response as Map<String, dynamic>);
  }

  /// Fetches a single product by ID
  Future<ProductModel> getProductById(int id) async {
    final response = await _apiClient.get('${ApiConstants.productsEndpoint}/$id');
    return ProductModel.fromJson(response as Map<String, dynamic>);
  }

  /// Fetches product categories
  Future<List<String>> getCategories() async {
    final response = await _apiClient.get(ApiConstants.categoriesEndpoint);
    if (response is List) {
      return response.map((item) {
        if (item is Map && item.containsKey('name')) {
          return item['name'].toString();
        } else if (item is Map && item.containsKey('slug')) {
          return item['slug'].toString();
        }
        return item.toString();
      }).toList();
    }
    return [];
  }

  /// Fetches products filtered by category
  Future<ProductsResponse> getProductsByCategory(String category) async {
    final response = await _apiClient.get('${ApiConstants.categoryProductsEndpoint}/$category');
    return ProductsResponse.fromJson(response as Map<String, dynamic>);
  }
}
