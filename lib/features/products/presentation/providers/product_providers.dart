import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../data/services/product_api_service.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/use_cases/get_categories_use_case.dart';
import '../../domain/use_cases/get_product_detail_use_case.dart';
import '../../domain/use_cases/get_products_use_case.dart';
import '../../domain/use_cases/search_products_use_case.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

final productApiServiceProvider = Provider<ProductApiService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ProductApiService(apiClient: apiClient);
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final apiService = ref.watch(productApiServiceProvider);
  return ProductRepositoryImpl(apiService: apiService);
});

final getProductsUseCaseProvider = Provider<GetProductsUseCase>((ref) {
  final repository = ref.watch(productRepositoryProvider);
  return GetProductsUseCase(repository);
});

final searchProductsUseCaseProvider = Provider<SearchProductsUseCase>((ref) {
  final repository = ref.watch(productRepositoryProvider);
  return SearchProductsUseCase(repository);
});

final getProductDetailUseCaseProvider = Provider<GetProductDetailUseCase>((ref) {
  final repository = ref.watch(productRepositoryProvider);
  return GetProductDetailUseCase(repository);
});

final getCategoriesUseCaseProvider = Provider<GetCategoriesUseCase>((ref) {
  final repository = ref.watch(productRepositoryProvider);
  return GetCategoriesUseCase(repository);
});

class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) => state = query;
  void clear() => state = '';
}

final searchQueryProvider = NotifierProvider<SearchQueryNotifier, String>(() {
  return SearchQueryNotifier();
});

class SelectedCategoryNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void selectCategory(String? category) => state = category;
}

final selectedCategoryProvider = NotifierProvider<SelectedCategoryNotifier, String?>(() {
  return SelectedCategoryNotifier();
});

final categoriesProvider = FutureProvider<List<String>>((ref) async {
  final getCategories = ref.watch(getCategoriesUseCaseProvider);
  return getCategories();
});

final productsListProvider = FutureProvider<List<Product>>((ref) async {
  final searchQuery = ref.watch(searchQueryProvider).trim();
  final selectedCategory = ref.watch(selectedCategoryProvider);

  if (searchQuery.isNotEmpty) {
    final searchProducts = ref.watch(searchProductsUseCaseProvider);
    return searchProducts(searchQuery, limit: 50);
  }

  final getProducts = ref.watch(getProductsUseCaseProvider);
  return getProducts(limit: 50, category: selectedCategory);
});

final productDetailProvider = FutureProvider.family<Product, int>((ref, productId) async {
  final getProductDetail = ref.watch(getProductDetailUseCaseProvider);
  return getProductDetail(productId);
});

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
