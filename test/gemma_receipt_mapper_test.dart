import 'package:flutter_test/flutter_test.dart';
import 'package:reciep/app/features/scan/repository/gemma_receipt_mapper.dart';

void main() {
  test('maps strict Gemma payload to receipt model', () {
    final Map<String, dynamic> payload = <String, dynamic>{
      'receiptId': 'RCP-777',
      'merchantName': 'Mega Store',
      'merchantCity': 'Sarajevo',
      'merchantAddress': 'Test 12',
      'currency': 'KM',
      'subtotalAmount': '20.00',
      'vatAmount': '3.40',
      'totalAmount': '23.40',
      'paymentMethod': 'card',
      'category': 'shopping',
      'purchaseDate': '2026-04-15',
      'rawSummary': 'Mega Store shopping total 23.40 KM',
      'confidence': '0.88',
      'items': <dynamic>[
        <String, dynamic>{
          'name': 'Bread',
          'quantity': '2',
          'unitPrice': '1.50',
          'finalPrice': '3.00',
        },
      ],
    };

    final receipt = GemmaReceiptMapper.toReceiptModel(
      payload: payload,
      imagePath: '/tmp/receipt.jpg',
    );

    expect(receipt.id, 'RCP-777');
    expect(receipt.currency, 'BAM');
    expect(receipt.merchant.name, 'Mega Store');
    expect(receipt.totals.total, closeTo(23.40, 0.001));
    expect(receipt.items, hasLength(1));
    expect(receipt.items.first.name, 'Bread');
    expect(receipt.items.first.finalPrice, closeTo(3.0, 0.001));
  });
}
