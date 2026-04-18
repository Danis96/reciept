import 'package:flutter_test/flutter_test.dart';
import 'package:reciep/app/features/budgets/repository/category_budget_catalog.dart';

void main() {
  group('CategoryBudgetCatalog', () {
    test('includes pharmacy, dental, and night out in supported categories', () {
      expect(
        CategoryBudgetCatalog.supportedCategories,
        containsAll(<String>[
          CategoryBudgetCatalog.pharmacy,
          CategoryBudgetCatalog.dental,
          CategoryBudgetCatalog.nightOut,
        ]),
      );
    });

    test('normalizes pharmacy aliases', () {
      expect(
        CategoryBudgetCatalog.normalize('apoteka'),
        CategoryBudgetCatalog.pharmacy,
      );
      expect(
        CategoryBudgetCatalog.normalize('vitamins'),
        CategoryBudgetCatalog.pharmacy,
      );
    });

    test('normalizes dental aliases', () {
      expect(
        CategoryBudgetCatalog.normalize('toothpaste'),
        CategoryBudgetCatalog.dental,
      );
      expect(
        CategoryBudgetCatalog.normalize('dentist'),
        CategoryBudgetCatalog.dental,
      );
    });

    test('normalizes night out aliases', () {
      expect(
        CategoryBudgetCatalog.normalize('beer'),
        CategoryBudgetCatalog.nightOut,
      );
      expect(
        CategoryBudgetCatalog.normalize('eating out'),
        CategoryBudgetCatalog.nightOut,
      );
      expect(
        CategoryBudgetCatalog.normalize('coffee'),
        CategoryBudgetCatalog.nightOut,
      );
    });
  });
}
