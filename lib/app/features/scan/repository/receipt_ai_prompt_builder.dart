import 'package:refyn/app/features/budgets/repository/category_budget_catalog.dart';

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
Before extraction, decide whether the receipt can be read clearly enough to identify merchant, total, and every line item.
If the image is blurry, cropped, too dark or bright, has glare, or even one line item or required field is not reliably readable, return ONLY: {"imageQualityIssue":true,"reason":"<one sentence>"}.
If the image contains two or more separate bills/documents, or the model cannot tell which bill is the primary target, return ONLY: {"imageQualityIssue":true,"reason":"<one sentence>"}.
Do not guess. Do not return extracted receipt data in that case.''';



  static const String _taskSection = '''
Step 1 — Identify receipt origin BEFORE extracting any data:
- DANISH receipt: look for any of these signals — "DKK", "kr", "Moms", "moms", "CVR", "CVR nr", "SE NR", "I ALT", "Betalingskort", "Betalingskort", "Kortbetaling", "Bon", "Dato", "Tid", "Varetekst", "Netto", or text in Danish language. If ANY of these are present → currency MUST be "DKK".
- BOSNIAN receipt: look for "BAM", "KM", "PDV", "JIB", "PIB", or text in Bosnian/Croatian language. If present → currency MUST be "BAM".
- AMERICAN receipt: look for "\$", "USD", or American English. If present → currency MUST be "USD".
- EUROPEAN (non-Danish) receipt: look for "€", "EUR". If present → currency MUST be "EUR".

Step 2 — Extract receipt data. Return ONE valid JSON object, no markdown, no extra text.''';

  String get _schemaSection => '''
Root keys (all required): ${_rootKeys.join(', ')}
Item keys (all required): ${_itemKeys.join(', ')}''';

  static const String _fieldRulesSection = '''
Rules:
- Image may be rotated — read accordingly.
- currency: short code (BAM, KM, EUR, USD, DKK).
- Detect the receipt's country from language, currency, and merchant clues. Danish receipts use DKK, have CVR/SE numbers, "Moms" for VAT, and Danish words (Total, I ALT, Heraf moms, Kort, Betalingskort, Kontant). Bosnian receipts use BAM/KM, have JIB/PIB numbers, "PDV" for VAT, and Bosnian words.
- Danish receipts use comma as decimal separator (e.g. 1.675,80 means 1675.80, and 594,15 means 594.15). The dot is a thousands separator. Always convert to dot-decimal in the JSON output.
- Numeric fields (subtotalAmount, vatAmount, totalAmount, quantity, unitPrice, finalPrice, confidence): numeric strings, dot decimal only.
- purchaseDate: YYYY-MM-DD.
- confidence: 0–1.
- paymentMethod: one word — cash, card, transfer, or unknown. Map Danish terms: Kort/Betalingskort/Kreditkort/Mastercard/Debit Mastercard → card, Kontant → cash.
- Use "unknown" for any unreadable or missing text field.
- receiptId: stable/deterministic from receipt content.
- totalAmount: final payable amount. On Danish receipts look for "Total", "I ALT", or "At betale".
- merchantName: exactly as printed.
- Extract ALL visible line items — one item per items[] entry.
- item.name: keep product name as printed.
- Correct only obvious spelling or OCR mistakes in item.name.
- Do NOT rewrite, expand abbreviations, rename product, or guess missing words.
- If not highly confident, keep original spelling from receipt.
- unit: printed unit (kom, kg, g, l, ml, pcs, stk) or unknown.
- Each item gets its own category.
- Lines showing "Rabat" (Danish discount) are negative adjustments — apply them to the preceding item's finalPrice, do not create a separate item.
- Lines like "PANT" or "Pant B" are bottle deposits — include them as separate items categorized as miscellaneous.''';

  String get _categorySection => '''
Categories (use ONLY these exact values): ${_supportedCategories.join(', ')}
- groceries: food, drinks, supermarket, bakery, snacks, fruit, veg, dairy, bread.
- household: cleaning, paper goods, detergents, toiletries, home consumables.
- pets: pet food, litter, pet care.
- clothing: shirts, majica, skjorte, pants, bukser, shoes, sko, jackets, jakke, socks, strømper, tights, worn accessories.
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