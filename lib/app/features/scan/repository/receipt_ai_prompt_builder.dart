import 'package:reciep/app/features/budgets/repository/category_budget_catalog.dart';

class ReceiptAiPromptBuilder {
  String build() {
    return [
      // Guard
      'Is this image a receipt? A receipt has a merchant name, at least one priced item, and a total.',
      'If NOT a receipt, return ONLY: {"notAReceipt":true,"reason":"<one sentence>"} — nothing else.',
      '',
      'Can the receipt be read clearly?',
      'If the image is blurry, cropped, too dark/light, contains glare, or text is unreadable, return ONLY:',
      '{"imageQualityIssue":true,"reason":"<one sentence>"} — nothing else.',
      '',
      // Task
      'Extract receipt data. Return ONE valid JSON object, no markdown, no extra text.',
      '',
      // Schema
      'Root keys (all required): ${_rootKeys.join(', ')}',
      'Item keys (all required): ${_itemKeys.join(', ')}',
      '',
      // Field rules
      'Rules:',
      '- Image may be rotated — read accordingly.',
      '- currency: short code (BAM, KM, EUR, USD).',
      '- Numeric fields (subtotalAmount, vatAmount, totalAmount, quantity, unitPrice, finalPrice, confidence): numeric strings, dot decimal only.',
      '- purchaseDate: YYYY-MM-DD.',
      '- confidence: 0–1.',
      '- paymentMethod: one word — cash, card, transfer, or unknown.',
      '- Use "unknown" for any unreadable or missing text field.',
      '- receiptId: stable/deterministic from receipt content.',
      '- totalAmount: final payable amount.',
      '- merchantName: exactly as printed.',
      '- Extract ALL visible line items — one item per items[] entry.',
      '- item.name: keep product name as printed.',
      '- Correct only obvious spelling or OCR mistakes in item.name.',
      '- Do NOT rewrite, expand abbreviations, rename product, or guess missing words.',
      '- If not highly confident, keep original spelling from receipt.',
      '- unit: printed unit (kom, kg, g, l, ml, pcs) or unknown.',
      '- Each item gets its own category.',
      '',
      // Categories
      'Categories (use ONLY these exact values): ${_supportedCategories.join(', ')}',
      '- groceries: food, drinks, supermarket, bakery, snacks, fruit, veg, dairy, bread.',
      '- household: cleaning, paper goods, detergents, toiletries, home consumables.',
      '- pets: pet food, litter, pet care.',
      '- clothing: shirts, majica, pants, shoes, jackets, socks, worn accessories.',
      '- fuel: gorivo, diesel, benzin, petrol, vehicle gas.',
      '- pharmacy: medicines, vitamins, supplements, apoteka, health products (non-dental).',
      '- dental: toothpaste, toothbrush, floss, mouthwash, oral care, dentist.',
      '- night out: coffee, beer, cocktails, cafe/bar/restaurant, immediate-consumption drinks.',
      '- cigarettes: cigarettes, tobacco, cigars, rolling tobacco, duhan, smoking products.',
      '- miscellaneous: only if nothing above fits.',
    ].join('\n');
  }

  static const List<String> _rootKeys = <String>[
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

  static const List<String> _itemKeys = <String>[
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
