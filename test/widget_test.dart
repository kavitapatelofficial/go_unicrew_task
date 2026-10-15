import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_unicrew_task/core/theme/app_theme.dart';
import 'package:go_unicrew_task/features/products/domain/models/product.dart';
import 'package:go_unicrew_task/features/products/presentation/providers/product_providers.dart';
import 'package:go_unicrew_task/features/products/presentation/screens/product_detail_screen.dart';
import 'package:go_unicrew_task/features/products/presentation/widgets/product_card.dart';
import 'package:go_unicrew_task/main.dart';

void main() {
  final sampleProduct = Product(
    id: 1,
    title: 'Test Essence Mascara',
    description: 'A test mascara description for testing widgets.',
    category: 'beauty',
    price: 9.99,
    discountPercentage: 10.0,
    rating: 4.5,
    stock: 50,
    tags: ['beauty', 'mascara'],
    brand: 'Essence',
    sku: 'TEST-SKU-1',
    warrantyInformation: '1 month warranty',
    shippingInformation: 'Ships in 3 days',
    availabilityStatus: 'In Stock',
    reviews: [],
    images: ['https://dummyjson.com/test.png'],
    thumbnail: 'https://dummyjson.com/test.png',
  );

  testWidgets('MyApp boots with MaterialApp.router smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          productsListProvider.overrideWith((ref) => Future.value([sampleProduct])),
          categoriesProvider.overrideWith((ref) => Future.value(['beauty', 'fragrances'])),
        ],
        child: const MyApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('UniStore'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('ProductCard displays title, price and triggers onTap', (WidgetTester tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: ProductCard(
              product: sampleProduct,
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('Test Essence Mascara'), findsOneWidget);
    expect(find.text('\$9.99'), findsOneWidget);
    expect(find.text('10% OFF'), findsOneWidget);

    await tester.tap(find.byType(ProductCard));
    expect(tapped, isTrue);
  });

  testWidgets('ProductDetailScreen displays full information and action buttons', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: ProductDetailScreen(product: sampleProduct),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('Test Essence Mascara'), findsOneWidget);
    expect(find.text('\$9.99'), findsOneWidget);
    expect(find.text('Add to Cart'), findsOneWidget);
    expect(find.text('Buy Now'), findsOneWidget);
    expect(find.text('Product Information'), findsOneWidget);
  });
}
