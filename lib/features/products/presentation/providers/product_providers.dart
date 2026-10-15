import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository.dart';
import '../../data/services/product_api_service.dart';

// Dependency Injection Providers
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

final productApiServiceProvider = Provider<ProductApiService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ProductApiService(apiClient: apiClient);
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final apiService = ref.watch(productApiServiceProvider);
  return ProductRepository(apiService: apiService);
});

// Search Query Notifier & Provider
class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) => state = query;
  void clear() => state = '';
}

final searchQueryProvider = NotifierProvider<SearchQueryNotifier, String>(() {
  return SearchQueryNotifier();
});

// Category Filter Notifier & Provider (null means "All")
class SelectedCategoryNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void selectCategory(String? category) => state = category;
}

final selectedCategoryProvider = NotifierProvider<SelectedCategoryNotifier, String?>(() {
  return SelectedCategoryNotifier();
});

// Categories List Provider
final categoriesProvider = FutureProvider<List<String>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getCategories();
});

// Main Products Provider
final productsListProvider = FutureProvider<List<ProductModel>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);
  final searchQuery = ref.watch(searchQueryProvider).trim();
  final selectedCategory = ref.watch(selectedCategoryProvider);

  if (searchQuery.isNotEmpty) {
    final response = await repository.searchProducts(searchQuery, limit: 50);
    return response.products;
  }

  if (selectedCategory != null && selectedCategory.isNotEmpty) {
    final response = await repository.getProductsByCategory(selectedCategory);
    return response.products;
  }

  final response = await repository.getProducts(limit: 50);
  return response.products;
});

// Single Product Detail Provider family
final productDetailProvider = FutureProvider.family<ProductModel, int>((ref, productId) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getProductDetails(productId);
});

// Favorites Notifier
class FavoritesNotifier extends Notifier<Set<int>> {
  @override
  Set<int> build() => {};

  void toggleFavorite(int productId) {
    if (state.contains(productId)) {
      state = {...state}..remove(productId);
    } else {
      state = {...state, productId};
    }
  }

  bool isFavorite(int productId) => state.contains(productId);
}

final favoritesProvider = NotifierProvider<FavoritesNotifier, Set<int>>(() {
  return FavoritesNotifier();
});
