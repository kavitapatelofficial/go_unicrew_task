import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../../../../core/widgets/loading_shimmer.dart';
import '../../data/models/product_model.dart';
import '../providers/product_providers.dart';
import '../widgets/category_filter_bar.dart';
import '../widgets/product_card.dart';
import '../widgets/search_bar_widget.dart';

class ProductListScreen extends ConsumerWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsListProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final favorites = ref.watch(favoritesProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.shopping_bag_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'UniStore',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                  ),
                ),
                Text(
                  'Explore DummyJSON Products',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.textSecondaryLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.favorite_rounded, color: AppTheme.primary),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('You have ${favorites.length} favorite items'),
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
              if (favorites.isNotEmpty)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppTheme.error,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      '${favorites.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No new notifications'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          // Search Bar Section
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 10),
            child: SearchBarWidget(),
          ),

          // Categories Filter Chips
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: CategoryFilterBar(),
          ),

          // Search or Category info banner
          if (searchQuery.isNotEmpty || selectedCategory != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      searchQuery.isNotEmpty
                          ? 'Search results for "${searchQuery.trim()}"'
                          : 'Category: $selectedCategory',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondaryLight,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      ref.read(searchQueryProvider.notifier).clear();
                      ref.read(selectedCategoryProvider.notifier).selectCategory(null);
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(50, 30),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Clear',
                      style: TextStyle(fontSize: 12, color: AppTheme.primary),
                    ),
                  ),
                ],
              ),
            ),

          // Product Grid Content
          Expanded(
            child: productsAsync.when(
              loading: () => const SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: LoadingShimmerGrid(itemCount: 6),
              ),
              error: (error, _) => RefreshIndicator(
                color: AppTheme.primary,
                onRefresh: () async {
                  return ref.refresh(productsListProvider.future);
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.65,
                    child: ErrorStateWidget(
                      message: error.toString(),
                      onRetry: () => ref.refresh(productsListProvider),
                    ),
                  ),
                ),
              ),
              data: (products) {
                if (products.isEmpty) {
                  return RefreshIndicator(
                    color: AppTheme.primary,
                    onRefresh: () async {
                      return ref.refresh(productsListProvider.future);
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.65,
                        child: EmptyStateWidget(
                          title: searchQuery.isNotEmpty
                              ? 'No results for "$searchQuery"'
                              : 'No products in this category',
                          message: 'Try checking your spelling or selecting a different category filter.',
                          onAction: () {
                            ref.read(searchQueryProvider.notifier).clear();
                            ref.read(selectedCategoryProvider.notifier).selectCategory(null);
                          },
                        ),
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  color: AppTheme.primary,
                  onRefresh: () async {
                    return ref.refresh(productsListProvider.future);
                  },
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = 2;
                      if (constraints.maxWidth > 900) {
                        crossAxisCount = 4;
                      } else if (constraints.maxWidth > 600) {
                        crossAxisCount = 3;
                      }

                      return GridView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: products.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: 0.67,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                        ),
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return ProductCard(
                            product: product,
                            onTap: () {
                              _navigateToDetail(context, product);
                            },
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToDetail(BuildContext context, ProductModel product) {
    context.push(AppRoutes.productDetailPath(product.id), extra: product);
  }
}
