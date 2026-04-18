import 'package:reciep/app/features/budgets/repository/category_budget_catalog.dart';

class ReceiptAiPromptBuilder {
  String build() {
    return [
      'Extract receipt data from the provided image.',
      'Return ONLY one valid JSON object.',
      'Use EXACTLY these root keys and no extra keys:',
      _rootKeys.join(', '),
      '',
      'Use EXACTLY these item keys and no extra keys:',
      _itemKeys.join(', '),
      '',
      'Hard rules:',
      '- Every root key and every item key is required.',
      '- No markdown, no code fences, no explanations, no trailing text.',
      '- Receipt image may be rotated sideways; mentally rotate it before reading.',
      '- currency must be a short code like BAM, KM, EUR, USD.',
      '- subtotalAmount, vatAmount, totalAmount, quantity, unitPrice, finalPrice, confidence must be numeric strings with dot decimal separator only.',
      '- purchaseDate must be YYYY-MM-DD.',
      '- confidence must be between 0 and 1.',
      '- items must contain at least one entry.',
      '- category and every items[].category must use ONLY one of these exact lowercase values: ${_supportedCategories.join(', ')}.',
      '- Use "unknown" only if a text field is unreadable or missing.',
      '- If merchantCity or merchantAddress is not visible, set it to "unknown".',
      '- receiptId must be stable and deterministic from receipt content when possible.',
      '- totalAmount must be final payable amount on receipt.',
      '- paymentMethod should be one word like cash, card, transfer, unknown.',
      '- Keep merchant name exactly as printed when readable.',
      '- Extract ALL visible purchased items from the receipt. Do not return only a summary item if line items are visible.',
      '- One receipt line item = one items[] entry whenever possible.',
      '- For weighted or abbreviated product names, keep the printed product name exactly as readable.',
      '- unit should capture printed unit when visible, like kom, kg, g, l, ml, pcs, unknown.',
      '- Each items[] entry must include category based on the item itself, not the whole receipt.',
      '- Root category should match the dominant budget category derived from item categories, based on biggest spend.',
      '',
      'Category mapping rules:',
      '- groceries = food, drinks, supermarket items, bakery, snacks, fruit, vegetables, dairy, pizza, bread, cigarettes, daily consumables from markets.',
      '- household = cleaning supplies, paper goods, kitchen/home supplies, detergents, toiletries, light bulbs, home-use consumables.',
      '- pets = pet food, litter, pet toys, pet care products.',
      '- clothing = shirts, majica, pants, shoes, jackets, socks, fashion items, accessories worn on body.',
      '- fuel = gorivo, diesel, benzin, petrol, gas for vehicle, fuel station purchases.',
      '- pharmacy = medicines, vitamins, supplements, bandages, drugstore items, apoteka purchases, health products not specifically dental.',
      '- dental = toothpaste, toothbrush, floss, mouthwash, dental treatments, dentist receipts, oral care products and services.',
      '- night out = beers, cocktails, coffee, cafe/bar/pub items, restaurant meals, eating out, drinks ordered for immediate consumption.',
      '- miscellaneous = only if item clearly does not fit any category above.',
      '- Example item mapping: MAJICA -> clothing, PIZZA -> groceries, GORIVO -> fuel, PARODONTAX -> dental, BRUFEN -> pharmacy, ESPRESSO -> night out, HEINEKEN -> night out.',
      '- If a receipt mixes categories, still categorize each item separately and keep all items in items[].',
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
    'category',
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
