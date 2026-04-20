import 'package:reciep/app/features/budgets/repository/category_budget_catalog.dart';

class ReceiptAiPromptBuilder {
  String build() => [
    _guardSection,
    _imageQualitySection,
    _taskSection,
    _schemaSection,
    _fieldRulesSection,
    _categorySection,
  ].join('\n\n');

  // ─── Sections ────────────────────────────────────────────────────────────────

  static const String _guardSection = '''
Is this image a receipt? A receipt has a merchant name, at least one priced item, and a total.
If NOT a receipt, return ONLY: {"notAReceipt":true,"reason":"<one sentence>"} — nothing else.''';

  static const String _imageQualitySection = '''
Before extraction: can the receipt be read clearly enough to identify merchant, total, and every line item?',
      'If the image is blurry, cropped, too dark/light, has glare, or even one line item or required field is not reliably readable, return ONLY: {"imageQualityIssue":true,"reason":"<one sentence>"}',
      'Do not guess. Do not return extracted receipt data in that case.''';

  static const String _taskSection =
      'Extract receipt data. Return ONE valid JSON object, no markdown, no extra text.';

  String get _schemaSection => '''
Root keys (all required): ${_rootKeys.join(', ')}
Item keys (all required): ${_itemKeys.join(', ')}''';

  static const String _fieldRulesSection = '''
Rules:
- Image may be rotated — read accordingly.
- currency: short code (BAM, KM, EUR, USD).
- Numeric fields (subtotalAmount, vatAmount, totalAmount, quantity, unitPrice, finalPrice, confidence): numeric strings, dot decimal only.
- purchaseDate: YYYY-MM-DD.
- confidence: 0–1.
- paymentMethod: one word — cash, card, transfer, or unknown.
- Use "unknown" for any unreadable or missing text field.
- receiptId: stable/deterministic from receipt content.
- totalAmount: final payable amount.
- merchantName: exactly as printed.
- Extract ALL visible line items — one item per items[] entry.
- item.name: keep product name as printed.
- Correct only obvious spelling or OCR mistakes in item.name.
- Do NOT rewrite, expand abbreviations, rename product, or guess missing words.
- If not highly confident, keep original spelling from receipt.
- unit: printed unit (kom, kg, g, l, ml, pcs) or unknown.
- Each item gets its own category.''';

  String get _categorySection => '''
Categories (use ONLY these exact values): ${_supportedCategories.join(', ')}
- groceries: food, drinks, supermarket, bakery, snacks, fruit, veg, dairy, bread.
- household: cleaning, paper goods, detergents, toiletries, home consumables.
- pets: pet food, litter, pet care.
- clothing: shirts, majica, pants, shoes, jackets, socks, worn accessories.
- fuel: gorivo, diesel, benzin, petrol, vehicle gas.
- pharmacy: medicines, vitamins, supplements, apoteka, health products (non-dental).
- dental: toothpaste, toothbrush, floss, mouthwash, oral care, dentist.
- night out: coffee, beer, cocktails, cafe/bar/restaurant, immediate-consumption drinks.
- cigarettes: cigarettes, tobacco, cigars, rolling tobacco, duhan, smoking products.
- miscellaneous: only if nothing above fits.''';

  // ─── Schema ───────────────────────────────────────────────────────────────────

  static const List<String> _rootKeys = [
    'receiptId',
    'merchantName',
    'merchantCity',
    'merchantAddress',
    'currency',
    'subtotalAmount',
    'vatAmount',
    'totalAmount',
    'paymentMethod',
    'purchaseDate',
    'rawSummary',
    'confidence',
    'items',
  ];

  static const List<String> _itemKeys = [
    'name',
    'category',
    'unit',
    'quantity',
    'unitPrice',
    'finalPrice',
  ];

  static const List<String> _supportedCategories =
      CategoryBudgetCatalog.supportedCategories;
}