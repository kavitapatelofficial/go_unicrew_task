class ApiConstants {
  static const String baseUrl = 'https://dummyjson.com';
  static const String productsEndpoint = '/products';
  static const String searchEndpoint = '/products/search';
  static const String categoriesEndpoint = '/products/categories';
  static const String categoryProductsEndpoint = '/products/category';
  
  static const int defaultLimit = 30;
  static const Duration requestTimeout = Duration(seconds: 15);
}
