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
      '- currency must be a short code like BAM, KM, EUR, USD.',
      '- subtotalAmount, vatAmount, totalAmount, quantity, unitPrice, finalPrice, confidence must be numeric strings with dot decimal separator only.',
      '- purchaseDate must be YYYY-MM-DD.',
      '- confidence must be between 0 and 1.',
      '- items must contain at least one entry.',
      '- category should be a short normalized lowercase word.',
      '- Use "unknown" only if a text field is unreadable or missing.',
      '- receiptId must be stable and deterministic from receipt content when possible.',
      '- totalAmount must be final payable amount on receipt.',
      '- paymentMethod should be one word like cash, card, transfer, unknown.',
      '- Keep merchant name exactly as printed when readable.',
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
    'quantity',
    'unitPrice',
    'finalPrice',
  ];
}
