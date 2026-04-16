// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ReceiptsTable extends Receipts with TableInfo<$ReceiptsTable, Receipt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReceiptsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _localIdMeta = const VerificationMeta(
    'localId',
  );
  @override
  late final GeneratedColumn<int> localId = GeneratedColumn<int>(
    'local_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _receiptIdMeta = const VerificationMeta(
    'receiptId',
  );
  @override
  late final GeneratedColumn<String> receiptId = GeneratedColumn<String>(
    'receipt_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _countryMeta = const VerificationMeta(
    'country',
  );
  @override
  late final GeneratedColumn<String> country = GeneratedColumn<String>(
    'country',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('BA'),
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('BAM'),
  );
  static const VerificationMeta _merchantNameMeta = const VerificationMeta(
    'merchantName',
  );
  @override
  late final GeneratedColumn<String> merchantName = GeneratedColumn<String>(
    'merchant_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _merchantStoreNameMeta = const VerificationMeta(
    'merchantStoreName',
  );
  @override
  late final GeneratedColumn<String> merchantStoreName =
      GeneratedColumn<String>(
        'merchant_store_name',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _merchantAddressMeta = const VerificationMeta(
    'merchantAddress',
  );
  @override
  late final GeneratedColumn<String> merchantAddress = GeneratedColumn<String>(
    'merchant_address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _merchantCityMeta = const VerificationMeta(
    'merchantCity',
  );
  @override
  late final GeneratedColumn<String> merchantCity = GeneratedColumn<String>(
    'merchant_city',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _merchantJibMeta = const VerificationMeta(
    'merchantJib',
  );
  @override
  late final GeneratedColumn<String> merchantJib = GeneratedColumn<String>(
    'merchant_jib',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _merchantPibMeta = const VerificationMeta(
    'merchantPib',
  );
  @override
  late final GeneratedColumn<String> merchantPib = GeneratedColumn<String>(
    'merchant_pib',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _receiptTypeMeta = const VerificationMeta(
    'receiptType',
  );
  @override
  late final GeneratedColumn<String> receiptType = GeneratedColumn<String>(
    'receipt_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('fiscal'),
  );
  static const VerificationMeta _receiptNumberMeta = const VerificationMeta(
    'receiptNumber',
  );
  @override
  late final GeneratedColumn<String> receiptNumber = GeneratedColumn<String>(
    'receipt_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _receiptDateTimeMeta = const VerificationMeta(
    'receiptDateTime',
  );
  @override
  late final GeneratedColumn<DateTime> receiptDateTime =
      GeneratedColumn<DateTime>(
        'receipt_date_time',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _receiptDateTextMeta = const VerificationMeta(
    'receiptDateText',
  );
  @override
  late final GeneratedColumn<String> receiptDateText = GeneratedColumn<String>(
    'receipt_date_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _receiptTimeTextMeta = const VerificationMeta(
    'receiptTimeText',
  );
  @override
  late final GeneratedColumn<String> receiptTimeText = GeneratedColumn<String>(
    'receipt_time_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _subtotalMeta = const VerificationMeta(
    'subtotal',
  );
  @override
  late final GeneratedColumn<double> subtotal = GeneratedColumn<double>(
    'subtotal',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _discountTotalMeta = const VerificationMeta(
    'discountTotal',
  );
  @override
  late final GeneratedColumn<double> discountTotal = GeneratedColumn<double>(
    'discount_total',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _taxableAmountMeta = const VerificationMeta(
    'taxableAmount',
  );
  @override
  late final GeneratedColumn<double> taxableAmount = GeneratedColumn<double>(
    'taxable_amount',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _vatRateMeta = const VerificationMeta(
    'vatRate',
  );
  @override
  late final GeneratedColumn<double> vatRate = GeneratedColumn<double>(
    'vat_rate',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _vatAmountMeta = const VerificationMeta(
    'vatAmount',
  );
  @override
  late final GeneratedColumn<double> vatAmount = GeneratedColumn<double>(
    'vat_amount',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalAmountMeta = const VerificationMeta(
    'totalAmount',
  );
  @override
  late final GeneratedColumn<double> totalAmount = GeneratedColumn<double>(
    'total_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _paymentMethodMeta = const VerificationMeta(
    'paymentMethod',
  );
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
    'payment_method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('unknown'),
  );
  static const VerificationMeta _paymentPaidMeta = const VerificationMeta(
    'paymentPaid',
  );
  @override
  late final GeneratedColumn<double> paymentPaid = GeneratedColumn<double>(
    'payment_paid',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _paymentChangeMeta = const VerificationMeta(
    'paymentChange',
  );
  @override
  late final GeneratedColumn<double> paymentChange = GeneratedColumn<double>(
    'payment_change',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fiscalIbfmMeta = const VerificationMeta(
    'fiscalIbfm',
  );
  @override
  late final GeneratedColumn<String> fiscalIbfm = GeneratedColumn<String>(
    'fiscal_ibfm',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fiscalQrPresentMeta = const VerificationMeta(
    'fiscalQrPresent',
  );
  @override
  late final GeneratedColumn<bool> fiscalQrPresent = GeneratedColumn<bool>(
    'fiscal_qr_present',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("fiscal_qr_present" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _fiscalVerificationCodeMeta =
      const VerificationMeta('fiscalVerificationCode');
  @override
  late final GeneratedColumn<String> fiscalVerificationCode =
      GeneratedColumn<String>(
        'fiscal_verification_code',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('miscellaneous'),
  );
  static const VerificationMeta _confidenceMeta = const VerificationMeta(
    'confidence',
  );
  @override
  late final GeneratedColumn<double> confidence = GeneratedColumn<double>(
    'confidence',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _rawTextMeta = const VerificationMeta(
    'rawText',
  );
  @override
  late final GeneratedColumn<String> rawText = GeneratedColumn<String>(
    'raw_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rawJsonMeta = const VerificationMeta(
    'rawJson',
  );
  @override
  late final GeneratedColumn<String> rawJson = GeneratedColumn<String>(
    'raw_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    localId,
    receiptId,
    country,
    currency,
    merchantName,
    merchantStoreName,
    merchantAddress,
    merchantCity,
    merchantJib,
    merchantPib,
    receiptType,
    receiptNumber,
    receiptDateTime,
    receiptDateText,
    receiptTimeText,
    subtotal,
    discountTotal,
    taxableAmount,
    vatRate,
    vatAmount,
    totalAmount,
    paymentMethod,
    paymentPaid,
    paymentChange,
    fiscalIbfm,
    fiscalQrPresent,
    fiscalVerificationCode,
    category,
    confidence,
    rawText,
    rawJson,
    imagePath,
    payloadJson,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'receipts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Receipt> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('local_id')) {
      context.handle(
        _localIdMeta,
        localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta),
      );
    }
    if (data.containsKey('receipt_id')) {
      context.handle(
        _receiptIdMeta,
        receiptId.isAcceptableOrUnknown(data['receipt_id']!, _receiptIdMeta),
      );
    } else if (isInserting) {
      context.missing(_receiptIdMeta);
    }
    if (data.containsKey('country')) {
      context.handle(
        _countryMeta,
        country.isAcceptableOrUnknown(data['country']!, _countryMeta),
      );
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('merchant_name')) {
      context.handle(
        _merchantNameMeta,
        merchantName.isAcceptableOrUnknown(
          data['merchant_name']!,
          _merchantNameMeta,
        ),
      );
    }
    if (data.containsKey('merchant_store_name')) {
      context.handle(
        _merchantStoreNameMeta,
        merchantStoreName.isAcceptableOrUnknown(
          data['merchant_store_name']!,
          _merchantStoreNameMeta,
        ),
      );
    }
    if (data.containsKey('merchant_address')) {
      context.handle(
        _merchantAddressMeta,
        merchantAddress.isAcceptableOrUnknown(
          data['merchant_address']!,
          _merchantAddressMeta,
        ),
      );
    }
    if (data.containsKey('merchant_city')) {
      context.handle(
        _merchantCityMeta,
        merchantCity.isAcceptableOrUnknown(
          data['merchant_city']!,
          _merchantCityMeta,
        ),
      );
    }
    if (data.containsKey('merchant_jib')) {
      context.handle(
        _merchantJibMeta,
        merchantJib.isAcceptableOrUnknown(
          data['merchant_jib']!,
          _merchantJibMeta,
        ),
      );
    }
    if (data.containsKey('merchant_pib')) {
      context.handle(
        _merchantPibMeta,
        merchantPib.isAcceptableOrUnknown(
          data['merchant_pib']!,
          _merchantPibMeta,
        ),
      );
    }
    if (data.containsKey('receipt_type')) {
      context.handle(
        _receiptTypeMeta,
        receiptType.isAcceptableOrUnknown(
          data['receipt_type']!,
          _receiptTypeMeta,
        ),
      );
    }
    if (data.containsKey('receipt_number')) {
      context.handle(
        _receiptNumberMeta,
        receiptNumber.isAcceptableOrUnknown(
          data['receipt_number']!,
          _receiptNumberMeta,
        ),
      );
    }
    if (data.containsKey('receipt_date_time')) {
      context.handle(
        _receiptDateTimeMeta,
        receiptDateTime.isAcceptableOrUnknown(
          data['receipt_date_time']!,
          _receiptDateTimeMeta,
        ),
      );
    }
    if (data.containsKey('receipt_date_text')) {
      context.handle(
        _receiptDateTextMeta,
        receiptDateText.isAcceptableOrUnknown(
          data['receipt_date_text']!,
          _receiptDateTextMeta,
        ),
      );
    }
    if (data.containsKey('receipt_time_text')) {
      context.handle(
        _receiptTimeTextMeta,
        receiptTimeText.isAcceptableOrUnknown(
          data['receipt_time_text']!,
          _receiptTimeTextMeta,
        ),
      );
    }
    if (data.containsKey('subtotal')) {
      context.handle(
        _subtotalMeta,
        subtotal.isAcceptableOrUnknown(data['subtotal']!, _subtotalMeta),
      );
    }
    if (data.containsKey('discount_total')) {
      context.handle(
        _discountTotalMeta,
        discountTotal.isAcceptableOrUnknown(
          data['discount_total']!,
          _discountTotalMeta,
        ),
      );
    }
    if (data.containsKey('taxable_amount')) {
      context.handle(
        _taxableAmountMeta,
        taxableAmount.isAcceptableOrUnknown(
          data['taxable_amount']!,
          _taxableAmountMeta,
        ),
      );
    }
    if (data.containsKey('vat_rate')) {
      context.handle(
        _vatRateMeta,
        vatRate.isAcceptableOrUnknown(data['vat_rate']!, _vatRateMeta),
      );
    }
    if (data.containsKey('vat_amount')) {
      context.handle(
        _vatAmountMeta,
        vatAmount.isAcceptableOrUnknown(data['vat_amount']!, _vatAmountMeta),
      );
    }
    if (data.containsKey('total_amount')) {
      context.handle(
        _totalAmountMeta,
        totalAmount.isAcceptableOrUnknown(
          data['total_amount']!,
          _totalAmountMeta,
        ),
      );
    }
    if (data.containsKey('payment_method')) {
      context.handle(
        _paymentMethodMeta,
        paymentMethod.isAcceptableOrUnknown(
          data['payment_method']!,
          _paymentMethodMeta,
        ),
      );
    }
    if (data.containsKey('payment_paid')) {
      context.handle(
        _paymentPaidMeta,
        paymentPaid.isAcceptableOrUnknown(
          data['payment_paid']!,
          _paymentPaidMeta,
        ),
      );
    }
    if (data.containsKey('payment_change')) {
      context.handle(
        _paymentChangeMeta,
        paymentChange.isAcceptableOrUnknown(
          data['payment_change']!,
          _paymentChangeMeta,
        ),
      );
    }
    if (data.containsKey('fiscal_ibfm')) {
      context.handle(
        _fiscalIbfmMeta,
        fiscalIbfm.isAcceptableOrUnknown(data['fiscal_ibfm']!, _fiscalIbfmMeta),
      );
    }
    if (data.containsKey('fiscal_qr_present')) {
      context.handle(
        _fiscalQrPresentMeta,
        fiscalQrPresent.isAcceptableOrUnknown(
          data['fiscal_qr_present']!,
          _fiscalQrPresentMeta,
        ),
      );
    }
    if (data.containsKey('fiscal_verification_code')) {
      context.handle(
        _fiscalVerificationCodeMeta,
        fiscalVerificationCode.isAcceptableOrUnknown(
          data['fiscal_verification_code']!,
          _fiscalVerificationCodeMeta,
        ),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('confidence')) {
      context.handle(
        _confidenceMeta,
        confidence.isAcceptableOrUnknown(data['confidence']!, _confidenceMeta),
      );
    }
    if (data.containsKey('raw_text')) {
      context.handle(
        _rawTextMeta,
        rawText.isAcceptableOrUnknown(data['raw_text']!, _rawTextMeta),
      );
    }
    if (data.containsKey('raw_json')) {
      context.handle(
        _rawJsonMeta,
        rawJson.isAcceptableOrUnknown(data['raw_json']!, _rawJsonMeta),
      );
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localId};
  @override
  Receipt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Receipt(
      localId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}local_id'],
      )!,
      receiptId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}receipt_id'],
      )!,
      country: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}country'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      merchantName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}merchant_name'],
      )!,
      merchantStoreName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}merchant_store_name'],
      ),
      merchantAddress: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}merchant_address'],
      ),
      merchantCity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}merchant_city'],
      ),
      merchantJib: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}merchant_jib'],
      ),
      merchantPib: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}merchant_pib'],
      ),
      receiptType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}receipt_type'],
      )!,
      receiptNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}receipt_number'],
      ),
      receiptDateTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}receipt_date_time'],
      ),
      receiptDateText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}receipt_date_text'],
      ),
      receiptTimeText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}receipt_time_text'],
      ),
      subtotal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}subtotal'],
      ),
      discountTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}discount_total'],
      ),
      taxableAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}taxable_amount'],
      ),
      vatRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}vat_rate'],
      ),
      vatAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}vat_amount'],
      ),
      totalAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_amount'],
      )!,
      paymentMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_method'],
      )!,
      paymentPaid: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}payment_paid'],
      ),
      paymentChange: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}payment_change'],
      ),
      fiscalIbfm: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fiscal_ibfm'],
      ),
      fiscalQrPresent: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}fiscal_qr_present'],
      )!,
      fiscalVerificationCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fiscal_verification_code'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      confidence: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}confidence'],
      )!,
      rawText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_text'],
      ),
      rawJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_json'],
      ),
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      ),
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ReceiptsTable createAlias(String alias) {
    return $ReceiptsTable(attachedDatabase, alias);
  }
}

class Receipt extends DataClass implements Insertable<Receipt> {
  final int localId;
  final String receiptId;
  final String country;
  final String currency;
  final String merchantName;
  final String? merchantStoreName;
  final String? merchantAddress;
  final String? merchantCity;
  final String? merchantJib;
  final String? merchantPib;
  final String receiptType;
  final String? receiptNumber;
  final DateTime? receiptDateTime;
  final String? receiptDateText;
  final String? receiptTimeText;
  final double? subtotal;
  final double? discountTotal;
  final double? taxableAmount;
  final double? vatRate;
  final double? vatAmount;
  final double totalAmount;
  final String paymentMethod;
  final double? paymentPaid;
  final double? paymentChange;
  final String? fiscalIbfm;
  final bool fiscalQrPresent;
  final String? fiscalVerificationCode;
  final String category;
  final double confidence;
  final String? rawText;
  final String? rawJson;
  final String? imagePath;
  final String payloadJson;
  final DateTime createdAt;
  const Receipt({
    required this.localId,
    required this.receiptId,
    required this.country,
    required this.currency,
    required this.merchantName,
    this.merchantStoreName,
    this.merchantAddress,
    this.merchantCity,
    this.merchantJib,
    this.merchantPib,
    required this.receiptType,
    this.receiptNumber,
    this.receiptDateTime,
    this.receiptDateText,
    this.receiptTimeText,
    this.subtotal,
    this.discountTotal,
    this.taxableAmount,
    this.vatRate,
    this.vatAmount,
    required this.totalAmount,
    required this.paymentMethod,
    this.paymentPaid,
    this.paymentChange,
    this.fiscalIbfm,
    required this.fiscalQrPresent,
    this.fiscalVerificationCode,
    required this.category,
    required this.confidence,
    this.rawText,
    this.rawJson,
    this.imagePath,
    required this.payloadJson,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_id'] = Variable<int>(localId);
    map['receipt_id'] = Variable<String>(receiptId);
    map['country'] = Variable<String>(country);
    map['currency'] = Variable<String>(currency);
    map['merchant_name'] = Variable<String>(merchantName);
    if (!nullToAbsent || merchantStoreName != null) {
      map['merchant_store_name'] = Variable<String>(merchantStoreName);
    }
    if (!nullToAbsent || merchantAddress != null) {
      map['merchant_address'] = Variable<String>(merchantAddress);
    }
    if (!nullToAbsent || merchantCity != null) {
      map['merchant_city'] = Variable<String>(merchantCity);
    }
    if (!nullToAbsent || merchantJib != null) {
      map['merchant_jib'] = Variable<String>(merchantJib);
    }
    if (!nullToAbsent || merchantPib != null) {
      map['merchant_pib'] = Variable<String>(merchantPib);
    }
    map['receipt_type'] = Variable<String>(receiptType);
    if (!nullToAbsent || receiptNumber != null) {
      map['receipt_number'] = Variable<String>(receiptNumber);
    }
    if (!nullToAbsent || receiptDateTime != null) {
      map['receipt_date_time'] = Variable<DateTime>(receiptDateTime);
    }
    if (!nullToAbsent || receiptDateText != null) {
      map['receipt_date_text'] = Variable<String>(receiptDateText);
    }
    if (!nullToAbsent || receiptTimeText != null) {
      map['receipt_time_text'] = Variable<String>(receiptTimeText);
    }
    if (!nullToAbsent || subtotal != null) {
      map['subtotal'] = Variable<double>(subtotal);
    }
    if (!nullToAbsent || discountTotal != null) {
      map['discount_total'] = Variable<double>(discountTotal);
    }
    if (!nullToAbsent || taxableAmount != null) {
      map['taxable_amount'] = Variable<double>(taxableAmount);
    }
    if (!nullToAbsent || vatRate != null) {
      map['vat_rate'] = Variable<double>(vatRate);
    }
    if (!nullToAbsent || vatAmount != null) {
      map['vat_amount'] = Variable<double>(vatAmount);
    }
    map['total_amount'] = Variable<double>(totalAmount);
    map['payment_method'] = Variable<String>(paymentMethod);
    if (!nullToAbsent || paymentPaid != null) {
      map['payment_paid'] = Variable<double>(paymentPaid);
    }
    if (!nullToAbsent || paymentChange != null) {
      map['payment_change'] = Variable<double>(paymentChange);
    }
    if (!nullToAbsent || fiscalIbfm != null) {
      map['fiscal_ibfm'] = Variable<String>(fiscalIbfm);
    }
    map['fiscal_qr_present'] = Variable<bool>(fiscalQrPresent);
    if (!nullToAbsent || fiscalVerificationCode != null) {
      map['fiscal_verification_code'] = Variable<String>(
        fiscalVerificationCode,
      );
    }
    map['category'] = Variable<String>(category);
    map['confidence'] = Variable<double>(confidence);
    if (!nullToAbsent || rawText != null) {
      map['raw_text'] = Variable<String>(rawText);
    }
    if (!nullToAbsent || rawJson != null) {
      map['raw_json'] = Variable<String>(rawJson);
    }
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    map['payload_json'] = Variable<String>(payloadJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ReceiptsCompanion toCompanion(bool nullToAbsent) {
    return ReceiptsCompanion(
      localId: Value(localId),
      receiptId: Value(receiptId),
      country: Value(country),
      currency: Value(currency),
      merchantName: Value(merchantName),
      merchantStoreName: merchantStoreName == null && nullToAbsent
          ? const Value.absent()
          : Value(merchantStoreName),
      merchantAddress: merchantAddress == null && nullToAbsent
          ? const Value.absent()
          : Value(merchantAddress),
      merchantCity: merchantCity == null && nullToAbsent
          ? const Value.absent()
          : Value(merchantCity),
      merchantJib: merchantJib == null && nullToAbsent
          ? const Value.absent()
          : Value(merchantJib),
      merchantPib: merchantPib == null && nullToAbsent
          ? const Value.absent()
          : Value(merchantPib),
      receiptType: Value(receiptType),
      receiptNumber: receiptNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(receiptNumber),
      receiptDateTime: receiptDateTime == null && nullToAbsent
          ? const Value.absent()
          : Value(receiptDateTime),
      receiptDateText: receiptDateText == null && nullToAbsent
          ? const Value.absent()
          : Value(receiptDateText),
      receiptTimeText: receiptTimeText == null && nullToAbsent
          ? const Value.absent()
          : Value(receiptTimeText),
      subtotal: subtotal == null && nullToAbsent
          ? const Value.absent()
          : Value(subtotal),
      discountTotal: discountTotal == null && nullToAbsent
          ? const Value.absent()
          : Value(discountTotal),
      taxableAmount: taxableAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(taxableAmount),
      vatRate: vatRate == null && nullToAbsent
          ? const Value.absent()
          : Value(vatRate),
      vatAmount: vatAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(vatAmount),
      totalAmount: Value(totalAmount),
      paymentMethod: Value(paymentMethod),
      paymentPaid: paymentPaid == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentPaid),
      paymentChange: paymentChange == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentChange),
      fiscalIbfm: fiscalIbfm == null && nullToAbsent
          ? const Value.absent()
          : Value(fiscalIbfm),
      fiscalQrPresent: Value(fiscalQrPresent),
      fiscalVerificationCode: fiscalVerificationCode == null && nullToAbsent
          ? const Value.absent()
          : Value(fiscalVerificationCode),
      category: Value(category),
      confidence: Value(confidence),
      rawText: rawText == null && nullToAbsent
          ? const Value.absent()
          : Value(rawText),
      rawJson: rawJson == null && nullToAbsent
          ? const Value.absent()
          : Value(rawJson),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      payloadJson: Value(payloadJson),
      createdAt: Value(createdAt),
    );
  }

  factory Receipt.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Receipt(
      localId: serializer.fromJson<int>(json['localId']),
      receiptId: serializer.fromJson<String>(json['receiptId']),
      country: serializer.fromJson<String>(json['country']),
      currency: serializer.fromJson<String>(json['currency']),
      merchantName: serializer.fromJson<String>(json['merchantName']),
      merchantStoreName: serializer.fromJson<String?>(
        json['merchantStoreName'],
      ),
      merchantAddress: serializer.fromJson<String?>(json['merchantAddress']),
      merchantCity: serializer.fromJson<String?>(json['merchantCity']),
      merchantJib: serializer.fromJson<String?>(json['merchantJib']),
      merchantPib: serializer.fromJson<String?>(json['merchantPib']),
      receiptType: serializer.fromJson<String>(json['receiptType']),
      receiptNumber: serializer.fromJson<String?>(json['receiptNumber']),
      receiptDateTime: serializer.fromJson<DateTime?>(json['receiptDateTime']),
      receiptDateText: serializer.fromJson<String?>(json['receiptDateText']),
      receiptTimeText: serializer.fromJson<String?>(json['receiptTimeText']),
      subtotal: serializer.fromJson<double?>(json['subtotal']),
      discountTotal: serializer.fromJson<double?>(json['discountTotal']),
      taxableAmount: serializer.fromJson<double?>(json['taxableAmount']),
      vatRate: serializer.fromJson<double?>(json['vatRate']),
      vatAmount: serializer.fromJson<double?>(json['vatAmount']),
      totalAmount: serializer.fromJson<double>(json['totalAmount']),
      paymentMethod: serializer.fromJson<String>(json['paymentMethod']),
      paymentPaid: serializer.fromJson<double?>(json['paymentPaid']),
      paymentChange: serializer.fromJson<double?>(json['paymentChange']),
      fiscalIbfm: serializer.fromJson<String?>(json['fiscalIbfm']),
      fiscalQrPresent: serializer.fromJson<bool>(json['fiscalQrPresent']),
      fiscalVerificationCode: serializer.fromJson<String?>(
        json['fiscalVerificationCode'],
      ),
      category: serializer.fromJson<String>(json['category']),
      confidence: serializer.fromJson<double>(json['confidence']),
      rawText: serializer.fromJson<String?>(json['rawText']),
      rawJson: serializer.fromJson<String?>(json['rawJson']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localId': serializer.toJson<int>(localId),
      'receiptId': serializer.toJson<String>(receiptId),
      'country': serializer.toJson<String>(country),
      'currency': serializer.toJson<String>(currency),
      'merchantName': serializer.toJson<String>(merchantName),
      'merchantStoreName': serializer.toJson<String?>(merchantStoreName),
      'merchantAddress': serializer.toJson<String?>(merchantAddress),
      'merchantCity': serializer.toJson<String?>(merchantCity),
      'merchantJib': serializer.toJson<String?>(merchantJib),
      'merchantPib': serializer.toJson<String?>(merchantPib),
      'receiptType': serializer.toJson<String>(receiptType),
      'receiptNumber': serializer.toJson<String?>(receiptNumber),
      'receiptDateTime': serializer.toJson<DateTime?>(receiptDateTime),
      'receiptDateText': serializer.toJson<String?>(receiptDateText),
      'receiptTimeText': serializer.toJson<String?>(receiptTimeText),
      'subtotal': serializer.toJson<double?>(subtotal),
      'discountTotal': serializer.toJson<double?>(discountTotal),
      'taxableAmount': serializer.toJson<double?>(taxableAmount),
      'vatRate': serializer.toJson<double?>(vatRate),
      'vatAmount': serializer.toJson<double?>(vatAmount),
      'totalAmount': serializer.toJson<double>(totalAmount),
      'paymentMethod': serializer.toJson<String>(paymentMethod),
      'paymentPaid': serializer.toJson<double?>(paymentPaid),
      'paymentChange': serializer.toJson<double?>(paymentChange),
      'fiscalIbfm': serializer.toJson<String?>(fiscalIbfm),
      'fiscalQrPresent': serializer.toJson<bool>(fiscalQrPresent),
      'fiscalVerificationCode': serializer.toJson<String?>(
        fiscalVerificationCode,
      ),
      'category': serializer.toJson<String>(category),
      'confidence': serializer.toJson<double>(confidence),
      'rawText': serializer.toJson<String?>(rawText),
      'rawJson': serializer.toJson<String?>(rawJson),
      'imagePath': serializer.toJson<String?>(imagePath),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Receipt copyWith({
    int? localId,
    String? receiptId,
    String? country,
    String? currency,
    String? merchantName,
    Value<String?> merchantStoreName = const Value.absent(),
    Value<String?> merchantAddress = const Value.absent(),
    Value<String?> merchantCity = const Value.absent(),
    Value<String?> merchantJib = const Value.absent(),
    Value<String?> merchantPib = const Value.absent(),
    String? receiptType,
    Value<String?> receiptNumber = const Value.absent(),
    Value<DateTime?> receiptDateTime = const Value.absent(),
    Value<String?> receiptDateText = const Value.absent(),
    Value<String?> receiptTimeText = const Value.absent(),
    Value<double?> subtotal = const Value.absent(),
    Value<double?> discountTotal = const Value.absent(),
    Value<double?> taxableAmount = const Value.absent(),
    Value<double?> vatRate = const Value.absent(),
    Value<double?> vatAmount = const Value.absent(),
    double? totalAmount,
    String? paymentMethod,
    Value<double?> paymentPaid = const Value.absent(),
    Value<double?> paymentChange = const Value.absent(),
    Value<String?> fiscalIbfm = const Value.absent(),
    bool? fiscalQrPresent,
    Value<String?> fiscalVerificationCode = const Value.absent(),
    String? category,
    double? confidence,
    Value<String?> rawText = const Value.absent(),
    Value<String?> rawJson = const Value.absent(),
    Value<String?> imagePath = const Value.absent(),
    String? payloadJson,
    DateTime? createdAt,
  }) => Receipt(
    localId: localId ?? this.localId,
    receiptId: receiptId ?? this.receiptId,
    country: country ?? this.country,
    currency: currency ?? this.currency,
    merchantName: merchantName ?? this.merchantName,
    merchantStoreName: merchantStoreName.present
        ? merchantStoreName.value
        : this.merchantStoreName,
    merchantAddress: merchantAddress.present
        ? merchantAddress.value
        : this.merchantAddress,
    merchantCity: merchantCity.present ? merchantCity.value : this.merchantCity,
    merchantJib: merchantJib.present ? merchantJib.value : this.merchantJib,
    merchantPib: merchantPib.present ? merchantPib.value : this.merchantPib,
    receiptType: receiptType ?? this.receiptType,
    receiptNumber: receiptNumber.present
        ? receiptNumber.value
        : this.receiptNumber,
    receiptDateTime: receiptDateTime.present
        ? receiptDateTime.value
        : this.receiptDateTime,
    receiptDateText: receiptDateText.present
        ? receiptDateText.value
        : this.receiptDateText,
    receiptTimeText: receiptTimeText.present
        ? receiptTimeText.value
        : this.receiptTimeText,
    subtotal: subtotal.present ? subtotal.value : this.subtotal,
    discountTotal: discountTotal.present
        ? discountTotal.value
        : this.discountTotal,
    taxableAmount: taxableAmount.present
        ? taxableAmount.value
        : this.taxableAmount,
    vatRate: vatRate.present ? vatRate.value : this.vatRate,
    vatAmount: vatAmount.present ? vatAmount.value : this.vatAmount,
    totalAmount: totalAmount ?? this.totalAmount,
    paymentMethod: paymentMethod ?? this.paymentMethod,
    paymentPaid: paymentPaid.present ? paymentPaid.value : this.paymentPaid,
    paymentChange: paymentChange.present
        ? paymentChange.value
        : this.paymentChange,
    fiscalIbfm: fiscalIbfm.present ? fiscalIbfm.value : this.fiscalIbfm,
    fiscalQrPresent: fiscalQrPresent ?? this.fiscalQrPresent,
    fiscalVerificationCode: fiscalVerificationCode.present
        ? fiscalVerificationCode.value
        : this.fiscalVerificationCode,
    category: category ?? this.category,
    confidence: confidence ?? this.confidence,
    rawText: rawText.present ? rawText.value : this.rawText,
    rawJson: rawJson.present ? rawJson.value : this.rawJson,
    imagePath: imagePath.present ? imagePath.value : this.imagePath,
    payloadJson: payloadJson ?? this.payloadJson,
    createdAt: createdAt ?? this.createdAt,
  );
  Receipt copyWithCompanion(ReceiptsCompanion data) {
    return Receipt(
      localId: data.localId.present ? data.localId.value : this.localId,
      receiptId: data.receiptId.present ? data.receiptId.value : this.receiptId,
      country: data.country.present ? data.country.value : this.country,
      currency: data.currency.present ? data.currency.value : this.currency,
      merchantName: data.merchantName.present
          ? data.merchantName.value
          : this.merchantName,
      merchantStoreName: data.merchantStoreName.present
          ? data.merchantStoreName.value
          : this.merchantStoreName,
      merchantAddress: data.merchantAddress.present
          ? data.merchantAddress.value
          : this.merchantAddress,
      merchantCity: data.merchantCity.present
          ? data.merchantCity.value
          : this.merchantCity,
      merchantJib: data.merchantJib.present
          ? data.merchantJib.value
          : this.merchantJib,
      merchantPib: data.merchantPib.present
          ? data.merchantPib.value
          : this.merchantPib,
      receiptType: data.receiptType.present
          ? data.receiptType.value
          : this.receiptType,
      receiptNumber: data.receiptNumber.present
          ? data.receiptNumber.value
          : this.receiptNumber,
      receiptDateTime: data.receiptDateTime.present
          ? data.receiptDateTime.value
          : this.receiptDateTime,
      receiptDateText: data.receiptDateText.present
          ? data.receiptDateText.value
          : this.receiptDateText,
      receiptTimeText: data.receiptTimeText.present
          ? data.receiptTimeText.value
          : this.receiptTimeText,
      subtotal: data.subtotal.present ? data.subtotal.value : this.subtotal,
      discountTotal: data.discountTotal.present
          ? data.discountTotal.value
          : this.discountTotal,
      taxableAmount: data.taxableAmount.present
          ? data.taxableAmount.value
          : this.taxableAmount,
      vatRate: data.vatRate.present ? data.vatRate.value : this.vatRate,
      vatAmount: data.vatAmount.present ? data.vatAmount.value : this.vatAmount,
      totalAmount: data.totalAmount.present
          ? data.totalAmount.value
          : this.totalAmount,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      paymentPaid: data.paymentPaid.present
          ? data.paymentPaid.value
          : this.paymentPaid,
      paymentChange: data.paymentChange.present
          ? data.paymentChange.value
          : this.paymentChange,
      fiscalIbfm: data.fiscalIbfm.present
          ? data.fiscalIbfm.value
          : this.fiscalIbfm,
      fiscalQrPresent: data.fiscalQrPresent.present
          ? data.fiscalQrPresent.value
          : this.fiscalQrPresent,
      fiscalVerificationCode: data.fiscalVerificationCode.present
          ? data.fiscalVerificationCode.value
          : this.fiscalVerificationCode,
      category: data.category.present ? data.category.value : this.category,
      confidence: data.confidence.present
          ? data.confidence.value
          : this.confidence,
      rawText: data.rawText.present ? data.rawText.value : this.rawText,
      rawJson: data.rawJson.present ? data.rawJson.value : this.rawJson,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Receipt(')
          ..write('localId: $localId, ')
          ..write('receiptId: $receiptId, ')
          ..write('country: $country, ')
          ..write('currency: $currency, ')
          ..write('merchantName: $merchantName, ')
          ..write('merchantStoreName: $merchantStoreName, ')
          ..write('merchantAddress: $merchantAddress, ')
          ..write('merchantCity: $merchantCity, ')
          ..write('merchantJib: $merchantJib, ')
          ..write('merchantPib: $merchantPib, ')
          ..write('receiptType: $receiptType, ')
          ..write('receiptNumber: $receiptNumber, ')
          ..write('receiptDateTime: $receiptDateTime, ')
          ..write('receiptDateText: $receiptDateText, ')
          ..write('receiptTimeText: $receiptTimeText, ')
          ..write('subtotal: $subtotal, ')
          ..write('discountTotal: $discountTotal, ')
          ..write('taxableAmount: $taxableAmount, ')
          ..write('vatRate: $vatRate, ')
          ..write('vatAmount: $vatAmount, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('paymentPaid: $paymentPaid, ')
          ..write('paymentChange: $paymentChange, ')
          ..write('fiscalIbfm: $fiscalIbfm, ')
          ..write('fiscalQrPresent: $fiscalQrPresent, ')
          ..write('fiscalVerificationCode: $fiscalVerificationCode, ')
          ..write('category: $category, ')
          ..write('confidence: $confidence, ')
          ..write('rawText: $rawText, ')
          ..write('rawJson: $rawJson, ')
          ..write('imagePath: $imagePath, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    localId,
    receiptId,
    country,
    currency,
    merchantName,
    merchantStoreName,
    merchantAddress,
    merchantCity,
    merchantJib,
    merchantPib,
    receiptType,
    receiptNumber,
    receiptDateTime,
    receiptDateText,
    receiptTimeText,
    subtotal,
    discountTotal,
    taxableAmount,
    vatRate,
    vatAmount,
    totalAmount,
    paymentMethod,
    paymentPaid,
    paymentChange,
    fiscalIbfm,
    fiscalQrPresent,
    fiscalVerificationCode,
    category,
    confidence,
    rawText,
    rawJson,
    imagePath,
    payloadJson,
    createdAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Receipt &&
          other.localId == this.localId &&
          other.receiptId == this.receiptId &&
          other.country == this.country &&
          other.currency == this.currency &&
          other.merchantName == this.merchantName &&
          other.merchantStoreName == this.merchantStoreName &&
          other.merchantAddress == this.merchantAddress &&
          other.merchantCity == this.merchantCity &&
          other.merchantJib == this.merchantJib &&
          other.merchantPib == this.merchantPib &&
          other.receiptType == this.receiptType &&
          other.receiptNumber == this.receiptNumber &&
          other.receiptDateTime == this.receiptDateTime &&
          other.receiptDateText == this.receiptDateText &&
          other.receiptTimeText == this.receiptTimeText &&
          other.subtotal == this.subtotal &&
          other.discountTotal == this.discountTotal &&
          other.taxableAmount == this.taxableAmount &&
          other.vatRate == this.vatRate &&
          other.vatAmount == this.vatAmount &&
          other.totalAmount == this.totalAmount &&
          other.paymentMethod == this.paymentMethod &&
          other.paymentPaid == this.paymentPaid &&
          other.paymentChange == this.paymentChange &&
          other.fiscalIbfm == this.fiscalIbfm &&
          other.fiscalQrPresent == this.fiscalQrPresent &&
          other.fiscalVerificationCode == this.fiscalVerificationCode &&
          other.category == this.category &&
          other.confidence == this.confidence &&
          other.rawText == this.rawText &&
          other.rawJson == this.rawJson &&
          other.imagePath == this.imagePath &&
          other.payloadJson == this.payloadJson &&
          other.createdAt == this.createdAt);
}

class ReceiptsCompanion extends UpdateCompanion<Receipt> {
  final Value<int> localId;
  final Value<String> receiptId;
  final Value<String> country;
  final Value<String> currency;
  final Value<String> merchantName;
  final Value<String?> merchantStoreName;
  final Value<String?> merchantAddress;
  final Value<String?> merchantCity;
  final Value<String?> merchantJib;
  final Value<String?> merchantPib;
  final Value<String> receiptType;
  final Value<String?> receiptNumber;
  final Value<DateTime?> receiptDateTime;
  final Value<String?> receiptDateText;
  final Value<String?> receiptTimeText;
  final Value<double?> subtotal;
  final Value<double?> discountTotal;
  final Value<double?> taxableAmount;
  final Value<double?> vatRate;
  final Value<double?> vatAmount;
  final Value<double> totalAmount;
  final Value<String> paymentMethod;
  final Value<double?> paymentPaid;
  final Value<double?> paymentChange;
  final Value<String?> fiscalIbfm;
  final Value<bool> fiscalQrPresent;
  final Value<String?> fiscalVerificationCode;
  final Value<String> category;
  final Value<double> confidence;
  final Value<String?> rawText;
  final Value<String?> rawJson;
  final Value<String?> imagePath;
  final Value<String> payloadJson;
  final Value<DateTime> createdAt;
  const ReceiptsCompanion({
    this.localId = const Value.absent(),
    this.receiptId = const Value.absent(),
    this.country = const Value.absent(),
    this.currency = const Value.absent(),
    this.merchantName = const Value.absent(),
    this.merchantStoreName = const Value.absent(),
    this.merchantAddress = const Value.absent(),
    this.merchantCity = const Value.absent(),
    this.merchantJib = const Value.absent(),
    this.merchantPib = const Value.absent(),
    this.receiptType = const Value.absent(),
    this.receiptNumber = const Value.absent(),
    this.receiptDateTime = const Value.absent(),
    this.receiptDateText = const Value.absent(),
    this.receiptTimeText = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.discountTotal = const Value.absent(),
    this.taxableAmount = const Value.absent(),
    this.vatRate = const Value.absent(),
    this.vatAmount = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.paymentPaid = const Value.absent(),
    this.paymentChange = const Value.absent(),
    this.fiscalIbfm = const Value.absent(),
    this.fiscalQrPresent = const Value.absent(),
    this.fiscalVerificationCode = const Value.absent(),
    this.category = const Value.absent(),
    this.confidence = const Value.absent(),
    this.rawText = const Value.absent(),
    this.rawJson = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ReceiptsCompanion.insert({
    this.localId = const Value.absent(),
    required String receiptId,
    this.country = const Value.absent(),
    this.currency = const Value.absent(),
    this.merchantName = const Value.absent(),
    this.merchantStoreName = const Value.absent(),
    this.merchantAddress = const Value.absent(),
    this.merchantCity = const Value.absent(),
    this.merchantJib = const Value.absent(),
    this.merchantPib = const Value.absent(),
    this.receiptType = const Value.absent(),
    this.receiptNumber = const Value.absent(),
    this.receiptDateTime = const Value.absent(),
    this.receiptDateText = const Value.absent(),
    this.receiptTimeText = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.discountTotal = const Value.absent(),
    this.taxableAmount = const Value.absent(),
    this.vatRate = const Value.absent(),
    this.vatAmount = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.paymentPaid = const Value.absent(),
    this.paymentChange = const Value.absent(),
    this.fiscalIbfm = const Value.absent(),
    this.fiscalQrPresent = const Value.absent(),
    this.fiscalVerificationCode = const Value.absent(),
    this.category = const Value.absent(),
    this.confidence = const Value.absent(),
    this.rawText = const Value.absent(),
    this.rawJson = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : receiptId = Value(receiptId);
  static Insertable<Receipt> custom({
    Expression<int>? localId,
    Expression<String>? receiptId,
    Expression<String>? country,
    Expression<String>? currency,
    Expression<String>? merchantName,
    Expression<String>? merchantStoreName,
    Expression<String>? merchantAddress,
    Expression<String>? merchantCity,
    Expression<String>? merchantJib,
    Expression<String>? merchantPib,
    Expression<String>? receiptType,
    Expression<String>? receiptNumber,
    Expression<DateTime>? receiptDateTime,
    Expression<String>? receiptDateText,
    Expression<String>? receiptTimeText,
    Expression<double>? subtotal,
    Expression<double>? discountTotal,
    Expression<double>? taxableAmount,
    Expression<double>? vatRate,
    Expression<double>? vatAmount,
    Expression<double>? totalAmount,
    Expression<String>? paymentMethod,
    Expression<double>? paymentPaid,
    Expression<double>? paymentChange,
    Expression<String>? fiscalIbfm,
    Expression<bool>? fiscalQrPresent,
    Expression<String>? fiscalVerificationCode,
    Expression<String>? category,
    Expression<double>? confidence,
    Expression<String>? rawText,
    Expression<String>? rawJson,
    Expression<String>? imagePath,
    Expression<String>? payloadJson,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (receiptId != null) 'receipt_id': receiptId,
      if (country != null) 'country': country,
      if (currency != null) 'currency': currency,
      if (merchantName != null) 'merchant_name': merchantName,
      if (merchantStoreName != null) 'merchant_store_name': merchantStoreName,
      if (merchantAddress != null) 'merchant_address': merchantAddress,
      if (merchantCity != null) 'merchant_city': merchantCity,
      if (merchantJib != null) 'merchant_jib': merchantJib,
      if (merchantPib != null) 'merchant_pib': merchantPib,
      if (receiptType != null) 'receipt_type': receiptType,
      if (receiptNumber != null) 'receipt_number': receiptNumber,
      if (receiptDateTime != null) 'receipt_date_time': receiptDateTime,
      if (receiptDateText != null) 'receipt_date_text': receiptDateText,
      if (receiptTimeText != null) 'receipt_time_text': receiptTimeText,
      if (subtotal != null) 'subtotal': subtotal,
      if (discountTotal != null) 'discount_total': discountTotal,
      if (taxableAmount != null) 'taxable_amount': taxableAmount,
      if (vatRate != null) 'vat_rate': vatRate,
      if (vatAmount != null) 'vat_amount': vatAmount,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (paymentPaid != null) 'payment_paid': paymentPaid,
      if (paymentChange != null) 'payment_change': paymentChange,
      if (fiscalIbfm != null) 'fiscal_ibfm': fiscalIbfm,
      if (fiscalQrPresent != null) 'fiscal_qr_present': fiscalQrPresent,
      if (fiscalVerificationCode != null)
        'fiscal_verification_code': fiscalVerificationCode,
      if (category != null) 'category': category,
      if (confidence != null) 'confidence': confidence,
      if (rawText != null) 'raw_text': rawText,
      if (rawJson != null) 'raw_json': rawJson,
      if (imagePath != null) 'image_path': imagePath,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ReceiptsCompanion copyWith({
    Value<int>? localId,
    Value<String>? receiptId,
    Value<String>? country,
    Value<String>? currency,
    Value<String>? merchantName,
    Value<String?>? merchantStoreName,
    Value<String?>? merchantAddress,
    Value<String?>? merchantCity,
    Value<String?>? merchantJib,
    Value<String?>? merchantPib,
    Value<String>? receiptType,
    Value<String?>? receiptNumber,
    Value<DateTime?>? receiptDateTime,
    Value<String?>? receiptDateText,
    Value<String?>? receiptTimeText,
    Value<double?>? subtotal,
    Value<double?>? discountTotal,
    Value<double?>? taxableAmount,
    Value<double?>? vatRate,
    Value<double?>? vatAmount,
    Value<double>? totalAmount,
    Value<String>? paymentMethod,
    Value<double?>? paymentPaid,
    Value<double?>? paymentChange,
    Value<String?>? fiscalIbfm,
    Value<bool>? fiscalQrPresent,
    Value<String?>? fiscalVerificationCode,
    Value<String>? category,
    Value<double>? confidence,
    Value<String?>? rawText,
    Value<String?>? rawJson,
    Value<String?>? imagePath,
    Value<String>? payloadJson,
    Value<DateTime>? createdAt,
  }) {
    return ReceiptsCompanion(
      localId: localId ?? this.localId,
      receiptId: receiptId ?? this.receiptId,
      country: country ?? this.country,
      currency: currency ?? this.currency,
      merchantName: merchantName ?? this.merchantName,
      merchantStoreName: merchantStoreName ?? this.merchantStoreName,
      merchantAddress: merchantAddress ?? this.merchantAddress,
      merchantCity: merchantCity ?? this.merchantCity,
      merchantJib: merchantJib ?? this.merchantJib,
      merchantPib: merchantPib ?? this.merchantPib,
      receiptType: receiptType ?? this.receiptType,
      receiptNumber: receiptNumber ?? this.receiptNumber,
      receiptDateTime: receiptDateTime ?? this.receiptDateTime,
      receiptDateText: receiptDateText ?? this.receiptDateText,
      receiptTimeText: receiptTimeText ?? this.receiptTimeText,
      subtotal: subtotal ?? this.subtotal,
      discountTotal: discountTotal ?? this.discountTotal,
      taxableAmount: taxableAmount ?? this.taxableAmount,
      vatRate: vatRate ?? this.vatRate,
      vatAmount: vatAmount ?? this.vatAmount,
      totalAmount: totalAmount ?? this.totalAmount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentPaid: paymentPaid ?? this.paymentPaid,
      paymentChange: paymentChange ?? this.paymentChange,
      fiscalIbfm: fiscalIbfm ?? this.fiscalIbfm,
      fiscalQrPresent: fiscalQrPresent ?? this.fiscalQrPresent,
      fiscalVerificationCode:
          fiscalVerificationCode ?? this.fiscalVerificationCode,
      category: category ?? this.category,
      confidence: confidence ?? this.confidence,
      rawText: rawText ?? this.rawText,
      rawJson: rawJson ?? this.rawJson,
      imagePath: imagePath ?? this.imagePath,
      payloadJson: payloadJson ?? this.payloadJson,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localId.present) {
      map['local_id'] = Variable<int>(localId.value);
    }
    if (receiptId.present) {
      map['receipt_id'] = Variable<String>(receiptId.value);
    }
    if (country.present) {
      map['country'] = Variable<String>(country.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (merchantName.present) {
      map['merchant_name'] = Variable<String>(merchantName.value);
    }
    if (merchantStoreName.present) {
      map['merchant_store_name'] = Variable<String>(merchantStoreName.value);
    }
    if (merchantAddress.present) {
      map['merchant_address'] = Variable<String>(merchantAddress.value);
    }
    if (merchantCity.present) {
      map['merchant_city'] = Variable<String>(merchantCity.value);
    }
    if (merchantJib.present) {
      map['merchant_jib'] = Variable<String>(merchantJib.value);
    }
    if (merchantPib.present) {
      map['merchant_pib'] = Variable<String>(merchantPib.value);
    }
    if (receiptType.present) {
      map['receipt_type'] = Variable<String>(receiptType.value);
    }
    if (receiptNumber.present) {
      map['receipt_number'] = Variable<String>(receiptNumber.value);
    }
    if (receiptDateTime.present) {
      map['receipt_date_time'] = Variable<DateTime>(receiptDateTime.value);
    }
    if (receiptDateText.present) {
      map['receipt_date_text'] = Variable<String>(receiptDateText.value);
    }
    if (receiptTimeText.present) {
      map['receipt_time_text'] = Variable<String>(receiptTimeText.value);
    }
    if (subtotal.present) {
      map['subtotal'] = Variable<double>(subtotal.value);
    }
    if (discountTotal.present) {
      map['discount_total'] = Variable<double>(discountTotal.value);
    }
    if (taxableAmount.present) {
      map['taxable_amount'] = Variable<double>(taxableAmount.value);
    }
    if (vatRate.present) {
      map['vat_rate'] = Variable<double>(vatRate.value);
    }
    if (vatAmount.present) {
      map['vat_amount'] = Variable<double>(vatAmount.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<double>(totalAmount.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (paymentPaid.present) {
      map['payment_paid'] = Variable<double>(paymentPaid.value);
    }
    if (paymentChange.present) {
      map['payment_change'] = Variable<double>(paymentChange.value);
    }
    if (fiscalIbfm.present) {
      map['fiscal_ibfm'] = Variable<String>(fiscalIbfm.value);
    }
    if (fiscalQrPresent.present) {
      map['fiscal_qr_present'] = Variable<bool>(fiscalQrPresent.value);
    }
    if (fiscalVerificationCode.present) {
      map['fiscal_verification_code'] = Variable<String>(
        fiscalVerificationCode.value,
      );
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<double>(confidence.value);
    }
    if (rawText.present) {
      map['raw_text'] = Variable<String>(rawText.value);
    }
    if (rawJson.present) {
      map['raw_json'] = Variable<String>(rawJson.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReceiptsCompanion(')
          ..write('localId: $localId, ')
          ..write('receiptId: $receiptId, ')
          ..write('country: $country, ')
          ..write('currency: $currency, ')
          ..write('merchantName: $merchantName, ')
          ..write('merchantStoreName: $merchantStoreName, ')
          ..write('merchantAddress: $merchantAddress, ')
          ..write('merchantCity: $merchantCity, ')
          ..write('merchantJib: $merchantJib, ')
          ..write('merchantPib: $merchantPib, ')
          ..write('receiptType: $receiptType, ')
          ..write('receiptNumber: $receiptNumber, ')
          ..write('receiptDateTime: $receiptDateTime, ')
          ..write('receiptDateText: $receiptDateText, ')
          ..write('receiptTimeText: $receiptTimeText, ')
          ..write('subtotal: $subtotal, ')
          ..write('discountTotal: $discountTotal, ')
          ..write('taxableAmount: $taxableAmount, ')
          ..write('vatRate: $vatRate, ')
          ..write('vatAmount: $vatAmount, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('paymentPaid: $paymentPaid, ')
          ..write('paymentChange: $paymentChange, ')
          ..write('fiscalIbfm: $fiscalIbfm, ')
          ..write('fiscalQrPresent: $fiscalQrPresent, ')
          ..write('fiscalVerificationCode: $fiscalVerificationCode, ')
          ..write('category: $category, ')
          ..write('confidence: $confidence, ')
          ..write('rawText: $rawText, ')
          ..write('rawJson: $rawJson, ')
          ..write('imagePath: $imagePath, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ReceiptItemsTable extends ReceiptItems
    with TableInfo<$ReceiptItemsTable, ReceiptItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReceiptItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _receiptLocalIdMeta = const VerificationMeta(
    'receiptLocalId',
  );
  @override
  late final GeneratedColumn<int> receiptLocalId = GeneratedColumn<int>(
    'receipt_local_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES receipts (local_id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _unitPriceMeta = const VerificationMeta(
    'unitPrice',
  );
  @override
  late final GeneratedColumn<double> unitPrice = GeneratedColumn<double>(
    'unit_price',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _discountPercentMeta = const VerificationMeta(
    'discountPercent',
  );
  @override
  late final GeneratedColumn<double> discountPercent = GeneratedColumn<double>(
    'discount_percent',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _discountAmountMeta = const VerificationMeta(
    'discountAmount',
  );
  @override
  late final GeneratedColumn<double> discountAmount = GeneratedColumn<double>(
    'discount_amount',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _finalPriceMeta = const VerificationMeta(
    'finalPrice',
  );
  @override
  late final GeneratedColumn<double> finalPrice = GeneratedColumn<double>(
    'final_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    receiptLocalId,
    position,
    name,
    unit,
    quantity,
    unitPrice,
    discountPercent,
    discountAmount,
    finalPrice,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'receipt_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReceiptItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('receipt_local_id')) {
      context.handle(
        _receiptLocalIdMeta,
        receiptLocalId.isAcceptableOrUnknown(
          data['receipt_local_id']!,
          _receiptLocalIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_receiptLocalIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('unit_price')) {
      context.handle(
        _unitPriceMeta,
        unitPrice.isAcceptableOrUnknown(data['unit_price']!, _unitPriceMeta),
      );
    }
    if (data.containsKey('discount_percent')) {
      context.handle(
        _discountPercentMeta,
        discountPercent.isAcceptableOrUnknown(
          data['discount_percent']!,
          _discountPercentMeta,
        ),
      );
    }
    if (data.containsKey('discount_amount')) {
      context.handle(
        _discountAmountMeta,
        discountAmount.isAcceptableOrUnknown(
          data['discount_amount']!,
          _discountAmountMeta,
        ),
      );
    }
    if (data.containsKey('final_price')) {
      context.handle(
        _finalPriceMeta,
        finalPrice.isAcceptableOrUnknown(data['final_price']!, _finalPriceMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReceiptItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReceiptItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      receiptLocalId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}receipt_local_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      ),
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      unitPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}unit_price'],
      ),
      discountPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}discount_percent'],
      ),
      discountAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}discount_amount'],
      ),
      finalPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}final_price'],
      )!,
    );
  }

  @override
  $ReceiptItemsTable createAlias(String alias) {
    return $ReceiptItemsTable(attachedDatabase, alias);
  }
}

class ReceiptItem extends DataClass implements Insertable<ReceiptItem> {
  final int id;
  final int receiptLocalId;
  final int position;
  final String name;
  final String? unit;
  final double quantity;
  final double? unitPrice;
  final double? discountPercent;
  final double? discountAmount;
  final double finalPrice;
  const ReceiptItem({
    required this.id,
    required this.receiptLocalId,
    required this.position,
    required this.name,
    this.unit,
    required this.quantity,
    this.unitPrice,
    this.discountPercent,
    this.discountAmount,
    required this.finalPrice,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['receipt_local_id'] = Variable<int>(receiptLocalId);
    map['position'] = Variable<int>(position);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    map['quantity'] = Variable<double>(quantity);
    if (!nullToAbsent || unitPrice != null) {
      map['unit_price'] = Variable<double>(unitPrice);
    }
    if (!nullToAbsent || discountPercent != null) {
      map['discount_percent'] = Variable<double>(discountPercent);
    }
    if (!nullToAbsent || discountAmount != null) {
      map['discount_amount'] = Variable<double>(discountAmount);
    }
    map['final_price'] = Variable<double>(finalPrice);
    return map;
  }

  ReceiptItemsCompanion toCompanion(bool nullToAbsent) {
    return ReceiptItemsCompanion(
      id: Value(id),
      receiptLocalId: Value(receiptLocalId),
      position: Value(position),
      name: Value(name),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      quantity: Value(quantity),
      unitPrice: unitPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(unitPrice),
      discountPercent: discountPercent == null && nullToAbsent
          ? const Value.absent()
          : Value(discountPercent),
      discountAmount: discountAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(discountAmount),
      finalPrice: Value(finalPrice),
    );
  }

  factory ReceiptItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReceiptItem(
      id: serializer.fromJson<int>(json['id']),
      receiptLocalId: serializer.fromJson<int>(json['receiptLocalId']),
      position: serializer.fromJson<int>(json['position']),
      name: serializer.fromJson<String>(json['name']),
      unit: serializer.fromJson<String?>(json['unit']),
      quantity: serializer.fromJson<double>(json['quantity']),
      unitPrice: serializer.fromJson<double?>(json['unitPrice']),
      discountPercent: serializer.fromJson<double?>(json['discountPercent']),
      discountAmount: serializer.fromJson<double?>(json['discountAmount']),
      finalPrice: serializer.fromJson<double>(json['finalPrice']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'receiptLocalId': serializer.toJson<int>(receiptLocalId),
      'position': serializer.toJson<int>(position),
      'name': serializer.toJson<String>(name),
      'unit': serializer.toJson<String?>(unit),
      'quantity': serializer.toJson<double>(quantity),
      'unitPrice': serializer.toJson<double?>(unitPrice),
      'discountPercent': serializer.toJson<double?>(discountPercent),
      'discountAmount': serializer.toJson<double?>(discountAmount),
      'finalPrice': serializer.toJson<double>(finalPrice),
    };
  }

  ReceiptItem copyWith({
    int? id,
    int? receiptLocalId,
    int? position,
    String? name,
    Value<String?> unit = const Value.absent(),
    double? quantity,
    Value<double?> unitPrice = const Value.absent(),
    Value<double?> discountPercent = const Value.absent(),
    Value<double?> discountAmount = const Value.absent(),
    double? finalPrice,
  }) => ReceiptItem(
    id: id ?? this.id,
    receiptLocalId: receiptLocalId ?? this.receiptLocalId,
    position: position ?? this.position,
    name: name ?? this.name,
    unit: unit.present ? unit.value : this.unit,
    quantity: quantity ?? this.quantity,
    unitPrice: unitPrice.present ? unitPrice.value : this.unitPrice,
    discountPercent: discountPercent.present
        ? discountPercent.value
        : this.discountPercent,
    discountAmount: discountAmount.present
        ? discountAmount.value
        : this.discountAmount,
    finalPrice: finalPrice ?? this.finalPrice,
  );
  ReceiptItem copyWithCompanion(ReceiptItemsCompanion data) {
    return ReceiptItem(
      id: data.id.present ? data.id.value : this.id,
      receiptLocalId: data.receiptLocalId.present
          ? data.receiptLocalId.value
          : this.receiptLocalId,
      position: data.position.present ? data.position.value : this.position,
      name: data.name.present ? data.name.value : this.name,
      unit: data.unit.present ? data.unit.value : this.unit,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unitPrice: data.unitPrice.present ? data.unitPrice.value : this.unitPrice,
      discountPercent: data.discountPercent.present
          ? data.discountPercent.value
          : this.discountPercent,
      discountAmount: data.discountAmount.present
          ? data.discountAmount.value
          : this.discountAmount,
      finalPrice: data.finalPrice.present
          ? data.finalPrice.value
          : this.finalPrice,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReceiptItem(')
          ..write('id: $id, ')
          ..write('receiptLocalId: $receiptLocalId, ')
          ..write('position: $position, ')
          ..write('name: $name, ')
          ..write('unit: $unit, ')
          ..write('quantity: $quantity, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('discountPercent: $discountPercent, ')
          ..write('discountAmount: $discountAmount, ')
          ..write('finalPrice: $finalPrice')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    receiptLocalId,
    position,
    name,
    unit,
    quantity,
    unitPrice,
    discountPercent,
    discountAmount,
    finalPrice,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReceiptItem &&
          other.id == this.id &&
          other.receiptLocalId == this.receiptLocalId &&
          other.position == this.position &&
          other.name == this.name &&
          other.unit == this.unit &&
          other.quantity == this.quantity &&
          other.unitPrice == this.unitPrice &&
          other.discountPercent == this.discountPercent &&
          other.discountAmount == this.discountAmount &&
          other.finalPrice == this.finalPrice);
}

class ReceiptItemsCompanion extends UpdateCompanion<ReceiptItem> {
  final Value<int> id;
  final Value<int> receiptLocalId;
  final Value<int> position;
  final Value<String> name;
  final Value<String?> unit;
  final Value<double> quantity;
  final Value<double?> unitPrice;
  final Value<double?> discountPercent;
  final Value<double?> discountAmount;
  final Value<double> finalPrice;
  const ReceiptItemsCompanion({
    this.id = const Value.absent(),
    this.receiptLocalId = const Value.absent(),
    this.position = const Value.absent(),
    this.name = const Value.absent(),
    this.unit = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.discountPercent = const Value.absent(),
    this.discountAmount = const Value.absent(),
    this.finalPrice = const Value.absent(),
  });
  ReceiptItemsCompanion.insert({
    this.id = const Value.absent(),
    required int receiptLocalId,
    this.position = const Value.absent(),
    this.name = const Value.absent(),
    this.unit = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.discountPercent = const Value.absent(),
    this.discountAmount = const Value.absent(),
    this.finalPrice = const Value.absent(),
  }) : receiptLocalId = Value(receiptLocalId);
  static Insertable<ReceiptItem> custom({
    Expression<int>? id,
    Expression<int>? receiptLocalId,
    Expression<int>? position,
    Expression<String>? name,
    Expression<String>? unit,
    Expression<double>? quantity,
    Expression<double>? unitPrice,
    Expression<double>? discountPercent,
    Expression<double>? discountAmount,
    Expression<double>? finalPrice,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (receiptLocalId != null) 'receipt_local_id': receiptLocalId,
      if (position != null) 'position': position,
      if (name != null) 'name': name,
      if (unit != null) 'unit': unit,
      if (quantity != null) 'quantity': quantity,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (discountPercent != null) 'discount_percent': discountPercent,
      if (discountAmount != null) 'discount_amount': discountAmount,
      if (finalPrice != null) 'final_price': finalPrice,
    });
  }

  ReceiptItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? receiptLocalId,
    Value<int>? position,
    Value<String>? name,
    Value<String?>? unit,
    Value<double>? quantity,
    Value<double?>? unitPrice,
    Value<double?>? discountPercent,
    Value<double?>? discountAmount,
    Value<double>? finalPrice,
  }) {
    return ReceiptItemsCompanion(
      id: id ?? this.id,
      receiptLocalId: receiptLocalId ?? this.receiptLocalId,
      position: position ?? this.position,
      name: name ?? this.name,
      unit: unit ?? this.unit,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      discountPercent: discountPercent ?? this.discountPercent,
      discountAmount: discountAmount ?? this.discountAmount,
      finalPrice: finalPrice ?? this.finalPrice,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (receiptLocalId.present) {
      map['receipt_local_id'] = Variable<int>(receiptLocalId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unitPrice.present) {
      map['unit_price'] = Variable<double>(unitPrice.value);
    }
    if (discountPercent.present) {
      map['discount_percent'] = Variable<double>(discountPercent.value);
    }
    if (discountAmount.present) {
      map['discount_amount'] = Variable<double>(discountAmount.value);
    }
    if (finalPrice.present) {
      map['final_price'] = Variable<double>(finalPrice.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReceiptItemsCompanion(')
          ..write('id: $id, ')
          ..write('receiptLocalId: $receiptLocalId, ')
          ..write('position: $position, ')
          ..write('name: $name, ')
          ..write('unit: $unit, ')
          ..write('quantity: $quantity, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('discountPercent: $discountPercent, ')
          ..write('discountAmount: $discountAmount, ')
          ..write('finalPrice: $finalPrice')
          ..write(')'))
        .toString();
  }
}

class $CategoryBudgetsTable extends CategoryBudgets
    with TableInfo<$CategoryBudgetsTable, CategoryBudget> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoryBudgetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _budgetAmountMeta = const VerificationMeta(
    'budgetAmount',
  );
  @override
  late final GeneratedColumn<double> budgetAmount = GeneratedColumn<double>(
    'budget_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _spentAmountMeta = const VerificationMeta(
    'spentAmount',
  );
  @override
  late final GeneratedColumn<double> spentAmount = GeneratedColumn<double>(
    'spent_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('BAM'),
  );
  static const VerificationMeta _periodMeta = const VerificationMeta('period');
  @override
  late final GeneratedColumn<String> period = GeneratedColumn<String>(
    'period',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('monthly'),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    category,
    budgetAmount,
    spentAmount,
    currency,
    period,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'category_budgets';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoryBudget> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('budget_amount')) {
      context.handle(
        _budgetAmountMeta,
        budgetAmount.isAcceptableOrUnknown(
          data['budget_amount']!,
          _budgetAmountMeta,
        ),
      );
    }
    if (data.containsKey('spent_amount')) {
      context.handle(
        _spentAmountMeta,
        spentAmount.isAcceptableOrUnknown(
          data['spent_amount']!,
          _spentAmountMeta,
        ),
      );
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('period')) {
      context.handle(
        _periodMeta,
        period.isAcceptableOrUnknown(data['period']!, _periodMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryBudget map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryBudget(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      budgetAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}budget_amount'],
      )!,
      spentAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}spent_amount'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      period: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}period'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CategoryBudgetsTable createAlias(String alias) {
    return $CategoryBudgetsTable(attachedDatabase, alias);
  }
}

class CategoryBudget extends DataClass implements Insertable<CategoryBudget> {
  final int id;
  final String category;
  final double budgetAmount;
  final double spentAmount;
  final String currency;
  final String period;
  final DateTime updatedAt;
  const CategoryBudget({
    required this.id,
    required this.category,
    required this.budgetAmount,
    required this.spentAmount,
    required this.currency,
    required this.period,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['category'] = Variable<String>(category);
    map['budget_amount'] = Variable<double>(budgetAmount);
    map['spent_amount'] = Variable<double>(spentAmount);
    map['currency'] = Variable<String>(currency);
    map['period'] = Variable<String>(period);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CategoryBudgetsCompanion toCompanion(bool nullToAbsent) {
    return CategoryBudgetsCompanion(
      id: Value(id),
      category: Value(category),
      budgetAmount: Value(budgetAmount),
      spentAmount: Value(spentAmount),
      currency: Value(currency),
      period: Value(period),
      updatedAt: Value(updatedAt),
    );
  }

  factory CategoryBudget.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryBudget(
      id: serializer.fromJson<int>(json['id']),
      category: serializer.fromJson<String>(json['category']),
      budgetAmount: serializer.fromJson<double>(json['budgetAmount']),
      spentAmount: serializer.fromJson<double>(json['spentAmount']),
      currency: serializer.fromJson<String>(json['currency']),
      period: serializer.fromJson<String>(json['period']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'category': serializer.toJson<String>(category),
      'budgetAmount': serializer.toJson<double>(budgetAmount),
      'spentAmount': serializer.toJson<double>(spentAmount),
      'currency': serializer.toJson<String>(currency),
      'period': serializer.toJson<String>(period),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CategoryBudget copyWith({
    int? id,
    String? category,
    double? budgetAmount,
    double? spentAmount,
    String? currency,
    String? period,
    DateTime? updatedAt,
  }) => CategoryBudget(
    id: id ?? this.id,
    category: category ?? this.category,
    budgetAmount: budgetAmount ?? this.budgetAmount,
    spentAmount: spentAmount ?? this.spentAmount,
    currency: currency ?? this.currency,
    period: period ?? this.period,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CategoryBudget copyWithCompanion(CategoryBudgetsCompanion data) {
    return CategoryBudget(
      id: data.id.present ? data.id.value : this.id,
      category: data.category.present ? data.category.value : this.category,
      budgetAmount: data.budgetAmount.present
          ? data.budgetAmount.value
          : this.budgetAmount,
      spentAmount: data.spentAmount.present
          ? data.spentAmount.value
          : this.spentAmount,
      currency: data.currency.present ? data.currency.value : this.currency,
      period: data.period.present ? data.period.value : this.period,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryBudget(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('budgetAmount: $budgetAmount, ')
          ..write('spentAmount: $spentAmount, ')
          ..write('currency: $currency, ')
          ..write('period: $period, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    category,
    budgetAmount,
    spentAmount,
    currency,
    period,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryBudget &&
          other.id == this.id &&
          other.category == this.category &&
          other.budgetAmount == this.budgetAmount &&
          other.spentAmount == this.spentAmount &&
          other.currency == this.currency &&
          other.period == this.period &&
          other.updatedAt == this.updatedAt);
}

class CategoryBudgetsCompanion extends UpdateCompanion<CategoryBudget> {
  final Value<int> id;
  final Value<String> category;
  final Value<double> budgetAmount;
  final Value<double> spentAmount;
  final Value<String> currency;
  final Value<String> period;
  final Value<DateTime> updatedAt;
  const CategoryBudgetsCompanion({
    this.id = const Value.absent(),
    this.category = const Value.absent(),
    this.budgetAmount = const Value.absent(),
    this.spentAmount = const Value.absent(),
    this.currency = const Value.absent(),
    this.period = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  CategoryBudgetsCompanion.insert({
    this.id = const Value.absent(),
    required String category,
    this.budgetAmount = const Value.absent(),
    this.spentAmount = const Value.absent(),
    this.currency = const Value.absent(),
    this.period = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : category = Value(category);
  static Insertable<CategoryBudget> custom({
    Expression<int>? id,
    Expression<String>? category,
    Expression<double>? budgetAmount,
    Expression<double>? spentAmount,
    Expression<String>? currency,
    Expression<String>? period,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (category != null) 'category': category,
      if (budgetAmount != null) 'budget_amount': budgetAmount,
      if (spentAmount != null) 'spent_amount': spentAmount,
      if (currency != null) 'currency': currency,
      if (period != null) 'period': period,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  CategoryBudgetsCompanion copyWith({
    Value<int>? id,
    Value<String>? category,
    Value<double>? budgetAmount,
    Value<double>? spentAmount,
    Value<String>? currency,
    Value<String>? period,
    Value<DateTime>? updatedAt,
  }) {
    return CategoryBudgetsCompanion(
      id: id ?? this.id,
      category: category ?? this.category,
      budgetAmount: budgetAmount ?? this.budgetAmount,
      spentAmount: spentAmount ?? this.spentAmount,
      currency: currency ?? this.currency,
      period: period ?? this.period,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (budgetAmount.present) {
      map['budget_amount'] = Variable<double>(budgetAmount.value);
    }
    if (spentAmount.present) {
      map['spent_amount'] = Variable<double>(spentAmount.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (period.present) {
      map['period'] = Variable<String>(period.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoryBudgetsCompanion(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('budgetAmount: $budgetAmount, ')
          ..write('spentAmount: $spentAmount, ')
          ..write('currency: $currency, ')
          ..write('period: $period, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String key;
  final String value;
  final DateTime updatedAt;
  const AppSetting({
    required this.key,
    required this.value,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      key: Value(key),
      value: Value(value),
      updatedAt: Value(updatedAt),
    );
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AppSetting copyWith({String? key, String? value, DateTime? updatedAt}) =>
      AppSetting(
        key: key ?? this.key,
        value: value ?? this.value,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.key == this.key &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> key;
  final Value<String> value;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String value,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ReceiptsTable receipts = $ReceiptsTable(this);
  late final $ReceiptItemsTable receiptItems = $ReceiptItemsTable(this);
  late final $CategoryBudgetsTable categoryBudgets = $CategoryBudgetsTable(
    this,
  );
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final ReceiptDao receiptDao = ReceiptDao(this as AppDatabase);
  late final CategoryBudgetDao categoryBudgetDao = CategoryBudgetDao(
    this as AppDatabase,
  );
  late final AppSettingsDao appSettingsDao = AppSettingsDao(
    this as AppDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    receipts,
    receiptItems,
    categoryBudgets,
    appSettings,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'receipts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('receipt_items', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$ReceiptsTableCreateCompanionBuilder =
    ReceiptsCompanion Function({
      Value<int> localId,
      required String receiptId,
      Value<String> country,
      Value<String> currency,
      Value<String> merchantName,
      Value<String?> merchantStoreName,
      Value<String?> merchantAddress,
      Value<String?> merchantCity,
      Value<String?> merchantJib,
      Value<String?> merchantPib,
      Value<String> receiptType,
      Value<String?> receiptNumber,
      Value<DateTime?> receiptDateTime,
      Value<String?> receiptDateText,
      Value<String?> receiptTimeText,
      Value<double?> subtotal,
      Value<double?> discountTotal,
      Value<double?> taxableAmount,
      Value<double?> vatRate,
      Value<double?> vatAmount,
      Value<double> totalAmount,
      Value<String> paymentMethod,
      Value<double?> paymentPaid,
      Value<double?> paymentChange,
      Value<String?> fiscalIbfm,
      Value<bool> fiscalQrPresent,
      Value<String?> fiscalVerificationCode,
      Value<String> category,
      Value<double> confidence,
      Value<String?> rawText,
      Value<String?> rawJson,
      Value<String?> imagePath,
      Value<String> payloadJson,
      Value<DateTime> createdAt,
    });
typedef $$ReceiptsTableUpdateCompanionBuilder =
    ReceiptsCompanion Function({
      Value<int> localId,
      Value<String> receiptId,
      Value<String> country,
      Value<String> currency,
      Value<String> merchantName,
      Value<String?> merchantStoreName,
      Value<String?> merchantAddress,
      Value<String?> merchantCity,
      Value<String?> merchantJib,
      Value<String?> merchantPib,
      Value<String> receiptType,
      Value<String?> receiptNumber,
      Value<DateTime?> receiptDateTime,
      Value<String?> receiptDateText,
      Value<String?> receiptTimeText,
      Value<double?> subtotal,
      Value<double?> discountTotal,
      Value<double?> taxableAmount,
      Value<double?> vatRate,
      Value<double?> vatAmount,
      Value<double> totalAmount,
      Value<String> paymentMethod,
      Value<double?> paymentPaid,
      Value<double?> paymentChange,
      Value<String?> fiscalIbfm,
      Value<bool> fiscalQrPresent,
      Value<String?> fiscalVerificationCode,
      Value<String> category,
      Value<double> confidence,
      Value<String?> rawText,
      Value<String?> rawJson,
      Value<String?> imagePath,
      Value<String> payloadJson,
      Value<DateTime> createdAt,
    });

final class $$ReceiptsTableReferences
    extends BaseReferences<_$AppDatabase, $ReceiptsTable, Receipt> {
  $$ReceiptsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ReceiptItemsTable, List<ReceiptItem>>
  _receiptItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.receiptItems,
    aliasName: $_aliasNameGenerator(
      db.receipts.localId,
      db.receiptItems.receiptLocalId,
    ),
  );

  $$ReceiptItemsTableProcessedTableManager get receiptItemsRefs {
    final manager = $$ReceiptItemsTableTableManager($_db, $_db.receiptItems)
        .filter(
          (f) => f.receiptLocalId.localId.sqlEquals(
            $_itemColumn<int>('local_id')!,
          ),
        );

    final cache = $_typedResult.readTableOrNull(_receiptItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ReceiptsTableFilterComposer
    extends Composer<_$AppDatabase, $ReceiptsTable> {
  $$ReceiptsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get receiptId => $composableBuilder(
    column: $table.receiptId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get country => $composableBuilder(
    column: $table.country,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get merchantName => $composableBuilder(
    column: $table.merchantName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get merchantStoreName => $composableBuilder(
    column: $table.merchantStoreName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get merchantAddress => $composableBuilder(
    column: $table.merchantAddress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get merchantCity => $composableBuilder(
    column: $table.merchantCity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get merchantJib => $composableBuilder(
    column: $table.merchantJib,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get merchantPib => $composableBuilder(
    column: $table.merchantPib,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get receiptType => $composableBuilder(
    column: $table.receiptType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get receiptNumber => $composableBuilder(
    column: $table.receiptNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get receiptDateTime => $composableBuilder(
    column: $table.receiptDateTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get receiptDateText => $composableBuilder(
    column: $table.receiptDateText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get receiptTimeText => $composableBuilder(
    column: $table.receiptTimeText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get discountTotal => $composableBuilder(
    column: $table.discountTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get taxableAmount => $composableBuilder(
    column: $table.taxableAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get vatRate => $composableBuilder(
    column: $table.vatRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get vatAmount => $composableBuilder(
    column: $table.vatAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get paymentPaid => $composableBuilder(
    column: $table.paymentPaid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get paymentChange => $composableBuilder(
    column: $table.paymentChange,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fiscalIbfm => $composableBuilder(
    column: $table.fiscalIbfm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get fiscalQrPresent => $composableBuilder(
    column: $table.fiscalQrPresent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fiscalVerificationCode => $composableBuilder(
    column: $table.fiscalVerificationCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawText => $composableBuilder(
    column: $table.rawText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawJson => $composableBuilder(
    column: $table.rawJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> receiptItemsRefs(
    Expression<bool> Function($$ReceiptItemsTableFilterComposer f) f,
  ) {
    final $$ReceiptItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.localId,
      referencedTable: $db.receiptItems,
      getReferencedColumn: (t) => t.receiptLocalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReceiptItemsTableFilterComposer(
            $db: $db,
            $table: $db.receiptItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ReceiptsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReceiptsTable> {
  $$ReceiptsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get receiptId => $composableBuilder(
    column: $table.receiptId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get country => $composableBuilder(
    column: $table.country,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get merchantName => $composableBuilder(
    column: $table.merchantName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get merchantStoreName => $composableBuilder(
    column: $table.merchantStoreName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get merchantAddress => $composableBuilder(
    column: $table.merchantAddress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get merchantCity => $composableBuilder(
    column: $table.merchantCity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get merchantJib => $composableBuilder(
    column: $table.merchantJib,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get merchantPib => $composableBuilder(
    column: $table.merchantPib,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get receiptType => $composableBuilder(
    column: $table.receiptType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get receiptNumber => $composableBuilder(
    column: $table.receiptNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get receiptDateTime => $composableBuilder(
    column: $table.receiptDateTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get receiptDateText => $composableBuilder(
    column: $table.receiptDateText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get receiptTimeText => $composableBuilder(
    column: $table.receiptTimeText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get discountTotal => $composableBuilder(
    column: $table.discountTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get taxableAmount => $composableBuilder(
    column: $table.taxableAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get vatRate => $composableBuilder(
    column: $table.vatRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get vatAmount => $composableBuilder(
    column: $table.vatAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get paymentPaid => $composableBuilder(
    column: $table.paymentPaid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get paymentChange => $composableBuilder(
    column: $table.paymentChange,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fiscalIbfm => $composableBuilder(
    column: $table.fiscalIbfm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get fiscalQrPresent => $composableBuilder(
    column: $table.fiscalQrPresent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fiscalVerificationCode => $composableBuilder(
    column: $table.fiscalVerificationCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawText => $composableBuilder(
    column: $table.rawText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawJson => $composableBuilder(
    column: $table.rawJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReceiptsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReceiptsTable> {
  $$ReceiptsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  GeneratedColumn<String> get receiptId =>
      $composableBuilder(column: $table.receiptId, builder: (column) => column);

  GeneratedColumn<String> get country =>
      $composableBuilder(column: $table.country, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get merchantName => $composableBuilder(
    column: $table.merchantName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get merchantStoreName => $composableBuilder(
    column: $table.merchantStoreName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get merchantAddress => $composableBuilder(
    column: $table.merchantAddress,
    builder: (column) => column,
  );

  GeneratedColumn<String> get merchantCity => $composableBuilder(
    column: $table.merchantCity,
    builder: (column) => column,
  );

  GeneratedColumn<String> get merchantJib => $composableBuilder(
    column: $table.merchantJib,
    builder: (column) => column,
  );

  GeneratedColumn<String> get merchantPib => $composableBuilder(
    column: $table.merchantPib,
    builder: (column) => column,
  );

  GeneratedColumn<String> get receiptType => $composableBuilder(
    column: $table.receiptType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get receiptNumber => $composableBuilder(
    column: $table.receiptNumber,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get receiptDateTime => $composableBuilder(
    column: $table.receiptDateTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get receiptDateText => $composableBuilder(
    column: $table.receiptDateText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get receiptTimeText => $composableBuilder(
    column: $table.receiptTimeText,
    builder: (column) => column,
  );

  GeneratedColumn<double> get subtotal =>
      $composableBuilder(column: $table.subtotal, builder: (column) => column);

  GeneratedColumn<double> get discountTotal => $composableBuilder(
    column: $table.discountTotal,
    builder: (column) => column,
  );

  GeneratedColumn<double> get taxableAmount => $composableBuilder(
    column: $table.taxableAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get vatRate =>
      $composableBuilder(column: $table.vatRate, builder: (column) => column);

  GeneratedColumn<double> get vatAmount =>
      $composableBuilder(column: $table.vatAmount, builder: (column) => column);

  GeneratedColumn<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => column,
  );

  GeneratedColumn<double> get paymentPaid => $composableBuilder(
    column: $table.paymentPaid,
    builder: (column) => column,
  );

  GeneratedColumn<double> get paymentChange => $composableBuilder(
    column: $table.paymentChange,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fiscalIbfm => $composableBuilder(
    column: $table.fiscalIbfm,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get fiscalQrPresent => $composableBuilder(
    column: $table.fiscalQrPresent,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fiscalVerificationCode => $composableBuilder(
    column: $table.fiscalVerificationCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rawText =>
      $composableBuilder(column: $table.rawText, builder: (column) => column);

  GeneratedColumn<String> get rawJson =>
      $composableBuilder(column: $table.rawJson, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> receiptItemsRefs<T extends Object>(
    Expression<T> Function($$ReceiptItemsTableAnnotationComposer a) f,
  ) {
    final $$ReceiptItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.localId,
      referencedTable: $db.receiptItems,
      getReferencedColumn: (t) => t.receiptLocalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReceiptItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.receiptItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ReceiptsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReceiptsTable,
          Receipt,
          $$ReceiptsTableFilterComposer,
          $$ReceiptsTableOrderingComposer,
          $$ReceiptsTableAnnotationComposer,
          $$ReceiptsTableCreateCompanionBuilder,
          $$ReceiptsTableUpdateCompanionBuilder,
          (Receipt, $$ReceiptsTableReferences),
          Receipt,
          PrefetchHooks Function({bool receiptItemsRefs})
        > {
  $$ReceiptsTableTableManager(_$AppDatabase db, $ReceiptsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReceiptsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReceiptsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReceiptsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> localId = const Value.absent(),
                Value<String> receiptId = const Value.absent(),
                Value<String> country = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> merchantName = const Value.absent(),
                Value<String?> merchantStoreName = const Value.absent(),
                Value<String?> merchantAddress = const Value.absent(),
                Value<String?> merchantCity = const Value.absent(),
                Value<String?> merchantJib = const Value.absent(),
                Value<String?> merchantPib = const Value.absent(),
                Value<String> receiptType = const Value.absent(),
                Value<String?> receiptNumber = const Value.absent(),
                Value<DateTime?> receiptDateTime = const Value.absent(),
                Value<String?> receiptDateText = const Value.absent(),
                Value<String?> receiptTimeText = const Value.absent(),
                Value<double?> subtotal = const Value.absent(),
                Value<double?> discountTotal = const Value.absent(),
                Value<double?> taxableAmount = const Value.absent(),
                Value<double?> vatRate = const Value.absent(),
                Value<double?> vatAmount = const Value.absent(),
                Value<double> totalAmount = const Value.absent(),
                Value<String> paymentMethod = const Value.absent(),
                Value<double?> paymentPaid = const Value.absent(),
                Value<double?> paymentChange = const Value.absent(),
                Value<String?> fiscalIbfm = const Value.absent(),
                Value<bool> fiscalQrPresent = const Value.absent(),
                Value<String?> fiscalVerificationCode = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<double> confidence = const Value.absent(),
                Value<String?> rawText = const Value.absent(),
                Value<String?> rawJson = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ReceiptsCompanion(
                localId: localId,
                receiptId: receiptId,
                country: country,
                currency: currency,
                merchantName: merchantName,
                merchantStoreName: merchantStoreName,
                merchantAddress: merchantAddress,
                merchantCity: merchantCity,
                merchantJib: merchantJib,
                merchantPib: merchantPib,
                receiptType: receiptType,
                receiptNumber: receiptNumber,
                receiptDateTime: receiptDateTime,
                receiptDateText: receiptDateText,
                receiptTimeText: receiptTimeText,
                subtotal: subtotal,
                discountTotal: discountTotal,
                taxableAmount: taxableAmount,
                vatRate: vatRate,
                vatAmount: vatAmount,
                totalAmount: totalAmount,
                paymentMethod: paymentMethod,
                paymentPaid: paymentPaid,
                paymentChange: paymentChange,
                fiscalIbfm: fiscalIbfm,
                fiscalQrPresent: fiscalQrPresent,
                fiscalVerificationCode: fiscalVerificationCode,
                category: category,
                confidence: confidence,
                rawText: rawText,
                rawJson: rawJson,
                imagePath: imagePath,
                payloadJson: payloadJson,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> localId = const Value.absent(),
                required String receiptId,
                Value<String> country = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> merchantName = const Value.absent(),
                Value<String?> merchantStoreName = const Value.absent(),
                Value<String?> merchantAddress = const Value.absent(),
                Value<String?> merchantCity = const Value.absent(),
                Value<String?> merchantJib = const Value.absent(),
                Value<String?> merchantPib = const Value.absent(),
                Value<String> receiptType = const Value.absent(),
                Value<String?> receiptNumber = const Value.absent(),
                Value<DateTime?> receiptDateTime = const Value.absent(),
                Value<String?> receiptDateText = const Value.absent(),
                Value<String?> receiptTimeText = const Value.absent(),
                Value<double?> subtotal = const Value.absent(),
                Value<double?> discountTotal = const Value.absent(),
                Value<double?> taxableAmount = const Value.absent(),
                Value<double?> vatRate = const Value.absent(),
                Value<double?> vatAmount = const Value.absent(),
                Value<double> totalAmount = const Value.absent(),
                Value<String> paymentMethod = const Value.absent(),
                Value<double?> paymentPaid = const Value.absent(),
                Value<double?> paymentChange = const Value.absent(),
                Value<String?> fiscalIbfm = const Value.absent(),
                Value<bool> fiscalQrPresent = const Value.absent(),
                Value<String?> fiscalVerificationCode = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<double> confidence = const Value.absent(),
                Value<String?> rawText = const Value.absent(),
                Value<String?> rawJson = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ReceiptsCompanion.insert(
                localId: localId,
                receiptId: receiptId,
                country: country,
                currency: currency,
                merchantName: merchantName,
                merchantStoreName: merchantStoreName,
                merchantAddress: merchantAddress,
                merchantCity: merchantCity,
                merchantJib: merchantJib,
                merchantPib: merchantPib,
                receiptType: receiptType,
                receiptNumber: receiptNumber,
                receiptDateTime: receiptDateTime,
                receiptDateText: receiptDateText,
                receiptTimeText: receiptTimeText,
                subtotal: subtotal,
                discountTotal: discountTotal,
                taxableAmount: taxableAmount,
                vatRate: vatRate,
                vatAmount: vatAmount,
                totalAmount: totalAmount,
                paymentMethod: paymentMethod,
                paymentPaid: paymentPaid,
                paymentChange: paymentChange,
                fiscalIbfm: fiscalIbfm,
                fiscalQrPresent: fiscalQrPresent,
                fiscalVerificationCode: fiscalVerificationCode,
                category: category,
                confidence: confidence,
                rawText: rawText,
                rawJson: rawJson,
                imagePath: imagePath,
                payloadJson: payloadJson,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ReceiptsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({receiptItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (receiptItemsRefs) db.receiptItems],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (receiptItemsRefs)
                    await $_getPrefetchedData<
                      Receipt,
                      $ReceiptsTable,
                      ReceiptItem
                    >(
                      currentTable: table,
                      referencedTable: $$ReceiptsTableReferences
                          ._receiptItemsRefsTable(db),
                      managerFromTypedResult: (p0) => $$ReceiptsTableReferences(
                        db,
                        table,
                        p0,
                      ).receiptItemsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.receiptLocalId == item.localId,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ReceiptsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReceiptsTable,
      Receipt,
      $$ReceiptsTableFilterComposer,
      $$ReceiptsTableOrderingComposer,
      $$ReceiptsTableAnnotationComposer,
      $$ReceiptsTableCreateCompanionBuilder,
      $$ReceiptsTableUpdateCompanionBuilder,
      (Receipt, $$ReceiptsTableReferences),
      Receipt,
      PrefetchHooks Function({bool receiptItemsRefs})
    >;
typedef $$ReceiptItemsTableCreateCompanionBuilder =
    ReceiptItemsCompanion Function({
      Value<int> id,
      required int receiptLocalId,
      Value<int> position,
      Value<String> name,
      Value<String?> unit,
      Value<double> quantity,
      Value<double?> unitPrice,
      Value<double?> discountPercent,
      Value<double?> discountAmount,
      Value<double> finalPrice,
    });
typedef $$ReceiptItemsTableUpdateCompanionBuilder =
    ReceiptItemsCompanion Function({
      Value<int> id,
      Value<int> receiptLocalId,
      Value<int> position,
      Value<String> name,
      Value<String?> unit,
      Value<double> quantity,
      Value<double?> unitPrice,
      Value<double?> discountPercent,
      Value<double?> discountAmount,
      Value<double> finalPrice,
    });

final class $$ReceiptItemsTableReferences
    extends BaseReferences<_$AppDatabase, $ReceiptItemsTable, ReceiptItem> {
  $$ReceiptItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ReceiptsTable _receiptLocalIdTable(_$AppDatabase db) =>
      db.receipts.createAlias(
        $_aliasNameGenerator(
          db.receiptItems.receiptLocalId,
          db.receipts.localId,
        ),
      );

  $$ReceiptsTableProcessedTableManager get receiptLocalId {
    final $_column = $_itemColumn<int>('receipt_local_id')!;

    final manager = $$ReceiptsTableTableManager(
      $_db,
      $_db.receipts,
    ).filter((f) => f.localId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_receiptLocalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReceiptItemsTableFilterComposer
    extends Composer<_$AppDatabase, $ReceiptItemsTable> {
  $$ReceiptItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get discountPercent => $composableBuilder(
    column: $table.discountPercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get discountAmount => $composableBuilder(
    column: $table.discountAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get finalPrice => $composableBuilder(
    column: $table.finalPrice,
    builder: (column) => ColumnFilters(column),
  );

  $$ReceiptsTableFilterComposer get receiptLocalId {
    final $$ReceiptsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.receiptLocalId,
      referencedTable: $db.receipts,
      getReferencedColumn: (t) => t.localId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReceiptsTableFilterComposer(
            $db: $db,
            $table: $db.receipts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReceiptItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReceiptItemsTable> {
  $$ReceiptItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get discountPercent => $composableBuilder(
    column: $table.discountPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get discountAmount => $composableBuilder(
    column: $table.discountAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get finalPrice => $composableBuilder(
    column: $table.finalPrice,
    builder: (column) => ColumnOrderings(column),
  );

  $$ReceiptsTableOrderingComposer get receiptLocalId {
    final $$ReceiptsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.receiptLocalId,
      referencedTable: $db.receipts,
      getReferencedColumn: (t) => t.localId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReceiptsTableOrderingComposer(
            $db: $db,
            $table: $db.receipts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReceiptItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReceiptItemsTable> {
  $$ReceiptItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get unitPrice =>
      $composableBuilder(column: $table.unitPrice, builder: (column) => column);

  GeneratedColumn<double> get discountPercent => $composableBuilder(
    column: $table.discountPercent,
    builder: (column) => column,
  );

  GeneratedColumn<double> get discountAmount => $composableBuilder(
    column: $table.discountAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get finalPrice => $composableBuilder(
    column: $table.finalPrice,
    builder: (column) => column,
  );

  $$ReceiptsTableAnnotationComposer get receiptLocalId {
    final $$ReceiptsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.receiptLocalId,
      referencedTable: $db.receipts,
      getReferencedColumn: (t) => t.localId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReceiptsTableAnnotationComposer(
            $db: $db,
            $table: $db.receipts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReceiptItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReceiptItemsTable,
          ReceiptItem,
          $$ReceiptItemsTableFilterComposer,
          $$ReceiptItemsTableOrderingComposer,
          $$ReceiptItemsTableAnnotationComposer,
          $$ReceiptItemsTableCreateCompanionBuilder,
          $$ReceiptItemsTableUpdateCompanionBuilder,
          (ReceiptItem, $$ReceiptItemsTableReferences),
          ReceiptItem,
          PrefetchHooks Function({bool receiptLocalId})
        > {
  $$ReceiptItemsTableTableManager(_$AppDatabase db, $ReceiptItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReceiptItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReceiptItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReceiptItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> receiptLocalId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> unit = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<double?> unitPrice = const Value.absent(),
                Value<double?> discountPercent = const Value.absent(),
                Value<double?> discountAmount = const Value.absent(),
                Value<double> finalPrice = const Value.absent(),
              }) => ReceiptItemsCompanion(
                id: id,
                receiptLocalId: receiptLocalId,
                position: position,
                name: name,
                unit: unit,
                quantity: quantity,
                unitPrice: unitPrice,
                discountPercent: discountPercent,
                discountAmount: discountAmount,
                finalPrice: finalPrice,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int receiptLocalId,
                Value<int> position = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> unit = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<double?> unitPrice = const Value.absent(),
                Value<double?> discountPercent = const Value.absent(),
                Value<double?> discountAmount = const Value.absent(),
                Value<double> finalPrice = const Value.absent(),
              }) => ReceiptItemsCompanion.insert(
                id: id,
                receiptLocalId: receiptLocalId,
                position: position,
                name: name,
                unit: unit,
                quantity: quantity,
                unitPrice: unitPrice,
                discountPercent: discountPercent,
                discountAmount: discountAmount,
                finalPrice: finalPrice,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ReceiptItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({receiptLocalId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (receiptLocalId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.receiptLocalId,
                                referencedTable: $$ReceiptItemsTableReferences
                                    ._receiptLocalIdTable(db),
                                referencedColumn: $$ReceiptItemsTableReferences
                                    ._receiptLocalIdTable(db)
                                    .localId,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ReceiptItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReceiptItemsTable,
      ReceiptItem,
      $$ReceiptItemsTableFilterComposer,
      $$ReceiptItemsTableOrderingComposer,
      $$ReceiptItemsTableAnnotationComposer,
      $$ReceiptItemsTableCreateCompanionBuilder,
      $$ReceiptItemsTableUpdateCompanionBuilder,
      (ReceiptItem, $$ReceiptItemsTableReferences),
      ReceiptItem,
      PrefetchHooks Function({bool receiptLocalId})
    >;
typedef $$CategoryBudgetsTableCreateCompanionBuilder =
    CategoryBudgetsCompanion Function({
      Value<int> id,
      required String category,
      Value<double> budgetAmount,
      Value<double> spentAmount,
      Value<String> currency,
      Value<String> period,
      Value<DateTime> updatedAt,
    });
typedef $$CategoryBudgetsTableUpdateCompanionBuilder =
    CategoryBudgetsCompanion Function({
      Value<int> id,
      Value<String> category,
      Value<double> budgetAmount,
      Value<double> spentAmount,
      Value<String> currency,
      Value<String> period,
      Value<DateTime> updatedAt,
    });

class $$CategoryBudgetsTableFilterComposer
    extends Composer<_$AppDatabase, $CategoryBudgetsTable> {
  $$CategoryBudgetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get budgetAmount => $composableBuilder(
    column: $table.budgetAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get spentAmount => $composableBuilder(
    column: $table.spentAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get period => $composableBuilder(
    column: $table.period,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CategoryBudgetsTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoryBudgetsTable> {
  $$CategoryBudgetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get budgetAmount => $composableBuilder(
    column: $table.budgetAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get spentAmount => $composableBuilder(
    column: $table.spentAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get period => $composableBuilder(
    column: $table.period,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoryBudgetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoryBudgetsTable> {
  $$CategoryBudgetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<double> get budgetAmount => $composableBuilder(
    column: $table.budgetAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get spentAmount => $composableBuilder(
    column: $table.spentAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get period =>
      $composableBuilder(column: $table.period, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CategoryBudgetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoryBudgetsTable,
          CategoryBudget,
          $$CategoryBudgetsTableFilterComposer,
          $$CategoryBudgetsTableOrderingComposer,
          $$CategoryBudgetsTableAnnotationComposer,
          $$CategoryBudgetsTableCreateCompanionBuilder,
          $$CategoryBudgetsTableUpdateCompanionBuilder,
          (
            CategoryBudget,
            BaseReferences<
              _$AppDatabase,
              $CategoryBudgetsTable,
              CategoryBudget
            >,
          ),
          CategoryBudget,
          PrefetchHooks Function()
        > {
  $$CategoryBudgetsTableTableManager(
    _$AppDatabase db,
    $CategoryBudgetsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoryBudgetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoryBudgetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoryBudgetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<double> budgetAmount = const Value.absent(),
                Value<double> spentAmount = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> period = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => CategoryBudgetsCompanion(
                id: id,
                category: category,
                budgetAmount: budgetAmount,
                spentAmount: spentAmount,
                currency: currency,
                period: period,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String category,
                Value<double> budgetAmount = const Value.absent(),
                Value<double> spentAmount = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> period = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => CategoryBudgetsCompanion.insert(
                id: id,
                category: category,
                budgetAmount: budgetAmount,
                spentAmount: spentAmount,
                currency: currency,
                period: period,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CategoryBudgetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoryBudgetsTable,
      CategoryBudget,
      $$CategoryBudgetsTableFilterComposer,
      $$CategoryBudgetsTableOrderingComposer,
      $$CategoryBudgetsTableAnnotationComposer,
      $$CategoryBudgetsTableCreateCompanionBuilder,
      $$CategoryBudgetsTableUpdateCompanionBuilder,
      (
        CategoryBudget,
        BaseReferences<_$AppDatabase, $CategoryBudgetsTable, CategoryBudget>,
      ),
      CategoryBudget,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String key,
      required String value,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ReceiptsTableTableManager get receipts =>
      $$ReceiptsTableTableManager(_db, _db.receipts);
  $$ReceiptItemsTableTableManager get receiptItems =>
      $$ReceiptItemsTableTableManager(_db, _db.receiptItems);
  $$CategoryBudgetsTableTableManager get categoryBudgets =>
      $$CategoryBudgetsTableTableManager(_db, _db.categoryBudgets);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}

mixin _$ReceiptDaoMixin on DatabaseAccessor<AppDatabase> {
  $ReceiptsTable get receipts => attachedDatabase.receipts;
  $ReceiptItemsTable get receiptItems => attachedDatabase.receiptItems;
  ReceiptDaoManager get managers => ReceiptDaoManager(this);
}

class ReceiptDaoManager {
  final _$ReceiptDaoMixin _db;
  ReceiptDaoManager(this._db);
  $$ReceiptsTableTableManager get receipts =>
      $$ReceiptsTableTableManager(_db.attachedDatabase, _db.receipts);
  $$ReceiptItemsTableTableManager get receiptItems =>
      $$ReceiptItemsTableTableManager(_db.attachedDatabase, _db.receiptItems);
}

mixin _$CategoryBudgetDaoMixin on DatabaseAccessor<AppDatabase> {
  $CategoryBudgetsTable get categoryBudgets => attachedDatabase.categoryBudgets;
  CategoryBudgetDaoManager get managers => CategoryBudgetDaoManager(this);
}

class CategoryBudgetDaoManager {
  final _$CategoryBudgetDaoMixin _db;
  CategoryBudgetDaoManager(this._db);
  $$CategoryBudgetsTableTableManager get categoryBudgets =>
      $$CategoryBudgetsTableTableManager(
        _db.attachedDatabase,
        _db.categoryBudgets,
      );
}

mixin _$AppSettingsDaoMixin on DatabaseAccessor<AppDatabase> {
  $AppSettingsTable get appSettings => attachedDatabase.appSettings;
  AppSettingsDaoManager get managers => AppSettingsDaoManager(this);
}

class AppSettingsDaoManager {
  final _$AppSettingsDaoMixin _db;
  AppSettingsDaoManager(this._db);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db.attachedDatabase, _db.appSettings);
}
