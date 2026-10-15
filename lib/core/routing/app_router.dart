import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/products/domain/entities/product.dart';
import '../../features/products/presentation/providers/product_providers.dart';
import '../../features/products/presentation/screens/product_detail_screen.dart';
import '../../features/products/presentation/screens/product_list_screen.dart';
import '../widgets/error_state_widget.dart';
import 'app_routes.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.productList,
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: AppRoutes.productList,
        name: 'productList',
        builder: (context, state) => const ProductListScreen(),
      ),
      GoRoute(
        path: AppRoutes.productDetail,
        name: 'productDetail',
        builder: (context, state) {
          final extra = state.extra;
          if (extra is Product) {
            return ProductDetailScreen(product: extra);
          }

          // Fallback when accessed via direct URL/deep-link without extra object
          final idStr = state.pathParameters['id'];
          final id = int.tryParse(idStr ?? '') ?? 0;

          return Consumer(
            builder: (context, ref, child) {
              final detailAsync = ref.watch(productDetailProvider(id));
              return detailAsync.when(
                data: (product) => ProductDetailScreen(product: product),
                loading: () => const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                ),
                error: (error, _) => Scaffold(
                  appBar: AppBar(title: const Text('Error')),
                  body: ErrorStateWidget(
                    message: error.toString(),
                    onRetry: () => ref.refresh(productDetailProvider(id)),
                  ),
                ),
              );
            },
          );
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(
        child: Text('No route defined for ${state.uri.toString()}'),
      ),
    ),
  );
});
