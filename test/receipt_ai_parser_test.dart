import 'package:flutter_test/flutter_test.dart';
import 'package:reciep/app/features/scan/repository/receipt_ai_parser.dart';

void main() {
  test('parses Bosnian fiscal structured JSON safely', () {
    final Map<String, dynamic> payload = <String, dynamic>{
      'country': 'ba',
      'currency': 'km',
      'merchant': <String, dynamic>{
        'naziv': 'ELD COMPANY d.o.o.',
        'jib': '4201641070017',
      },
      'receipt': <String, dynamic>{
        'broj': '13591',
        'datetime': '26.12.2025. 11:19',
      },
      'items': <dynamic>[
        <String, dynamic>{
          'naziv': 'FERRO/KOM',
          'kolicina': '1',
          'cijena': '170,00',
          'popust_procenat': '20,00',
          'iznos': '136,00',
        },
      ],
      'totals': <String, dynamic>{'ukupno': '136,00', 'pdv': '19,76'},
      'fiscal': <String, dynamic>{'ibfm': 'AL106600', 'qr_present': true},
      'confidence': '0,92',
      'category': 'shopping',
    };

    final ReceiptAiParserResult result = ReceiptAiParser.parseStructured(
      payload,
    );

    expect(result.isValid, isTrue);
    expect(result.receipt, isNotNull);
    expect(result.receipt!.currency, equals('KM'));
    expect(result.receipt!.total, closeTo(136.0, 0.001));
    expect(result.receipt!.items.first.finalPrice, closeTo(136.0, 0.001));
    expect(result.receipt!.confidence, closeTo(0.92, 0.001));
  });

  test('handles missing and invalid values with validation errors', () {
    final Map<String, dynamic> payload = <String, dynamic>{
      'merchant': <String, dynamic>{'name': ''},
      'totals': <String, dynamic>{'total': 'abc'},
      'items': <dynamic>[
        <String, dynamic>{'name': '', 'quantity': 0, 'final_price': '-4'},
      ],
    };

    final ReceiptAiParserResult result = ReceiptAiParser.parseStructured(
      payload,
    );

    expect(result.isValid, isFalse);
    expect(result.receipt, isNull);
    expect(result.errors, isNotEmpty);
  });

  test('normalizes comma and thousands separators', () {
    final Map<String, dynamic> payload = <String, dynamic>{
      'merchant': <String, dynamic>{'name': 'Test'},
      'totals': <String, dynamic>{'total': '1.234,56 KM'},
    };

    final ReceiptAiParserResult result = ReceiptAiParser.parseStructured(
      payload,
    );

    expect(result.isValid, isTrue);
    expect(result.receipt!.total, closeTo(1234.56, 0.001));
  });
}
