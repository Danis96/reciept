class CategoryBudgetCatalog {
  const CategoryBudgetCatalog._();

  static const String groceries = 'groceries';
  static const String fuel = 'fuel';
  static const String household = 'household';
  static const String pets = 'pets';
  static const String clothing = 'clothing';
  static const String miscellaneous = 'miscellaneous';

  static const List<String> supportedCategories = <String>[
    groceries,
    household,
    pets,
    clothing,
    fuel,
    miscellaneous,
  ];

  static String normalize(String rawCategory) {
    final String value = rawCategory.trim().toLowerCase();
    if (value.isEmpty) {
      return miscellaneous;
    }
    if (value.contains('groc') ||
        value.contains('food') ||
        value.contains('market')) {
      return groceries;
    }
    if (value.contains('fuel') ||
        value.contains('gas') ||
        value.contains('petrol') ||
        value.contains('car') ||
        value.contains('transport')) {
      return fuel;
    }
    if (value.contains('house') ||
        value.contains('home') ||
        value.contains('clean')) {
      return household;
    }
    if (value.contains('pet') ||
        value.contains('dog') ||
        value.contains('cat')) {
      return pets;
    }
    if (value.contains('cloth') ||
        value.contains('fashion') ||
        value.contains('wear')) {
      return clothing;
    }
    if (value == miscellaneous || value == 'misc' || value == 'other') {
      return miscellaneous;
    }
    return miscellaneous;
  }

  static String labelFor(String category) {
    switch (normalize(category)) {
      case groceries:
        return 'Groceries';
      case fuel:
        return 'Fuel';
      case household:
        return 'Household';
      case pets:
        return 'Pets';
      case clothing:
        return 'Clothing';
      case miscellaneous:
        return 'Miscellaneous';
    }
    return 'Miscellaneous';
  }
}
