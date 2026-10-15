import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/product_providers.dart';

class CategoryFilterBar extends ConsumerWidget {
  const CategoryFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return categoriesAsync.when(
      data: (categories) {
        if (categories.isEmpty) return const SizedBox.shrink();

        final allOptions = ['All', ...categories];

        return SizedBox(
          height: 38,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: allOptions.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final cat = allOptions[index];
              final isAll = cat == 'All';
              final isSelected = isAll ? selectedCategory == null : selectedCategory == cat;

              return ChoiceChip(
                label: Text(
                  _formatCategoryName(cat),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? Colors.white : AppTheme.textPrimaryLight,
                  ),
                ),
                selected: isSelected,
                showCheckmark: false,
                backgroundColor: Colors.white,
                selectedColor: AppTheme.primary,
                side: BorderSide(
                  color: isSelected ? AppTheme.primary : const Color(0xFFE2E8F0),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                onSelected: (selected) {
                  if (isAll) {
                    ref.read(selectedCategoryProvider.notifier).selectCategory(null);
                  } else {
                    ref.read(selectedCategoryProvider.notifier).selectCategory(selected ? cat : null);
                  }
                  if (ref.read(searchQueryProvider).isNotEmpty) {
                    ref.read(searchQueryProvider.notifier).clear();
                  }
                },
              );
            },
          ),
        );
      },
      loading: () => const SizedBox(height: 38),
      error: (_, _) => const SizedBox.shrink(),
    );
  }

  String _formatCategoryName(String slug) {
    if (slug == 'All') return 'All';
    return slug
        .replaceAll('-', ' ')
        .split(' ')
        .map((word) => word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1)}' : '')
        .join(' ');
  }
}
