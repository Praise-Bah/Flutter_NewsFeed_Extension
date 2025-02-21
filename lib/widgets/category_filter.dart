import 'package:flutter/material.dart';

class CategoryFilter extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategoryChanged;

  const CategoryFilter({
    super.key,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    final categories = [
      'all',
      'business',
      'entertainment',
      'health',
      'science',
      'sports',
      'technology'
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: categories.map((category) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: FilterChip(
                selected: selectedCategory == category,
                label: Text(
                  category.substring(0, 1).toUpperCase() +
                      category.substring(1),
                ),
                onSelected: (_) => onCategoryChanged(category),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
