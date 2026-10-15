import '../models/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts({int limit = 30, int skip = 0});
  Future<List<Product>> searchProducts(String query, {int limit = 30, int skip = 0});
  Future<Product> getProductDetails(int id);
  Future<List<String>> getCategories();
  Future<List<Product>> getProductsByCategory(String category);
}
