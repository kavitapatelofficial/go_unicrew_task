class AppRoutes {
  static const String productList = '/';
  static const String productDetail = '/products/:id';

  static String productDetailPath(int id) => '/products/$id';
}
