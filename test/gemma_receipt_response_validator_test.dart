import 'package:flutter_test/flutter_test.dart';
import 'package:reciep/app/features/scan/repository/gemma_receipt_response_validator.dart';

void main() {
  test('accepts strict payload with required keys', () {
    final Map<String, dynamic> payload = <String, dynamic>{
      'receiptId': 'RCP-001',
      'merchantName': 'Market d.o.o.',
      'merchantCity': 'Sarajevo',
      'merchantAddress': 'Main 1',
      'currency': 'BAM',
      'subtotalAmount': '10.00',
      'vatAmount': '1.70',
      'totalAmount': '11.70',
      'paymentMethod': 'cash',
      'category': 'food',
      'purchaseDate': '2026-04-15',
      'rawSummary': 'Market d.o.o. receipt total 11.70 BAM.',
      'confidence': '0.93',
      'items': <dynamic>[
        <String, dynamic>{
          'name': 'Milk',
          'quantity': '1',
          'unitPrice': '1.95',
          'finalPrice': '1.95',
        },
      ],
    };

    final List<String> errors = GemmaReceiptResponseValidator.validate(payload);

    expect(errors, isEmpty);
  });

  test('rejects extra keys and invalid number formats', () {
    final Map<String, dynamic> payload = <String, dynamic>{
      'receiptId': 'RCP-001',
      'merchantName': 'Market d.o.o.',
      'merchantCity': 'Sarajevo',
      'merchantAddress': 'Main 1',
      'currency': 'BAM',
      'subtotalAmount': '10,00',
      'vatAmount': 'x',
      'totalAmount': '-1',
      'paymentMethod': 'cash',
      'category': 'food',
      'purchaseDate': '15-04-2026',
      'rawSummary': 'summary',
      'confidence': '1.4',
      'items': <dynamic>[
        <String, dynamic>{
          'name': 'Milk',
          'quantity': '1',
          'unitPrice': '1.95',
          'finalPrice': '1.95',
          'unexpected': 'bad',
        },
      ],
      'extraRoot': 'bad',
    };

    final List<String> errors = GemmaReceiptResponseValidator.validate(payload);

    expect(errors, isNotEmpty);
    expect(
      errors.any((String error) => error.contains('Unexpected root keys')),
      isTrue,
    );
    expect(
      errors.any((String error) => error.contains('items[0] unexpected keys')),
      isTrue,
    );
    expect(
      errors.any(
        (String error) => error.contains('totalAmount must be positive'),
      ),
      isTrue,
    );
  });
}
