import 'package:flutter/material.dart';
import 'package:reciep/app/features/budgets/repository/category_budget_catalog.dart';

class CategoryAssetImage extends StatelessWidget {
  const CategoryAssetImage({
    super.key,
    required this.category,
    this.size = 20,
    this.fit = BoxFit.cover,
  });

  final String category;
  final double size;
  final BoxFit fit;

  static String assetPathFor(String category) {
    switch (CategoryBudgetCatalog.normalize(category)) {
      case CategoryBudgetCatalog.groceries:
        return 'assets/groceries.png';
      case CategoryBudgetCatalog.household:
        return 'assets/household.png';
      case CategoryBudgetCatalog.clothing:
        return 'assets/clothes.png';
      case CategoryBudgetCatalog.fuel:
        return 'assets/fuel.png';
      case CategoryBudgetCatalog.pets:
        return 'assets/pets.png';
      case CategoryBudgetCatalog.pharmacy:
        return 'assets/pharmacy.png';
      case CategoryBudgetCatalog.dental:
        return 'assets/dental.png';
      case CategoryBudgetCatalog.miscellaneous:
        return 'assets/miscellaneous.png';
    }
    return 'assets/miscellaneous.png';
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPathFor(category),
      width: size,
      height: size,
      fit: fit,
      errorBuilder:
          (BuildContext context, Object error, StackTrace? stackTrace) =>
              ColoredBox(
                color: Theme.of(
                  context,
                ).colorScheme.secondary.withValues(alpha: 0.12),
                child: SizedBox(width: size, height: size),
              ),
    );
  }
}
