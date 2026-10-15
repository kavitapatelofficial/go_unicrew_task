class AppRoutes {
  static const String splash = '/';
  static const String productList = '/products';
  static const String productDetail = '/products/:id';

  static String productDetailPath(int id) => '/products/$id';
}
