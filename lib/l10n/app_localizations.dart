import 'package:flutter/widgets.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [Locale('en'), Locale('bs')];

  static final AppLocalizations fallback = AppLocalizations(const Locale('en'));

  static AppLocalizations of(BuildContext context) {
    final AppLocalizations? result = Localizations.of<AppLocalizations>(
      context,
      AppLocalizations,
    );
    return result ?? fallback;
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'Receipt Scanner',
      'home': 'Home',
      'scan': 'Scan',
      'history': 'History',
      'settings': 'Settings',
      'homePlaceholder': 'Home screen (Phase 1)',
      'scanPlaceholder': 'Scan screen (Phase 1)',
      'historyPlaceholder': 'History screen (Phase 1)',
      'settingsPlaceholder': 'App settings',
      'themeMode': 'Theme Mode',
      'lightTheme': 'Light',
      'darkTheme': 'Dark',
      'systemTheme': 'System',
      'saveDemoReceipt': 'Save Demo Receipt',
      'demoReceiptSaved': 'Demo receipt saved to history',
      'refreshHistory': 'Refresh History',
      'noReceiptsYet': 'No receipts yet. Save one from Scan tab.',
      'scanReceiptTitle': 'Scan Receipt',
      'scanReceiptSubtitle': 'Upload or capture a receipt image',
      'scanUpload': 'Upload',
      'scanCamera': 'Camera',
      'scanUploadTitle': 'Upload Receipt',
      'scanUploadSubtitle': 'Tap to select from gallery',
      'scanCameraTitle': 'Take Photo',
      'scanCameraSubtitle': 'Use camera to capture',
      'scanSupportFormats': 'Supports JPG, PNG • Max 10MB',
      'scanReceiptButton': 'Scan Receipt',
      'scanReset': 'Reset',
      'scanAnother': 'Scan Another',
      'scanRecentTitle': 'Recent Scans',
      'scanSuccessTitle': 'Receipt Scanned Successfully!',
      'scanErrorTitle': 'Scan Failed',
      'scanErrorFallback': 'Could not process receipt image.',
      'scanStepUploading': 'Uploading image',
      'scanStepReading': 'Reading text',
      'scanStepDetecting': 'Detecting items',
      'scanStepCategorizing': 'Categorizing receipt',
      'scanStepFinalizing': 'Finalizing data',
      'scanMerchant': 'Merchant',
      'scanTotal': 'Total',
      'scanDate': 'Date',
      'scanCategory': 'Category',
      'scanItems': 'Items',
      'scanConfidence': 'Confidence',
      'scanRetry': 'Retry Scan',
      'scanPickAnotherImage': 'Pick Another Image',
      'scanSaveReceipt': 'Save Receipt',
      'scanEditBeforeSave': 'Edit Before Save',
      'scanSaving': 'Saving...',
      'scanLowConfidenceWarning': 'Low confidence parse. Review before save.',
      'scanReceiptSaved': 'Receipt saved.',
      'scanDraftUpdated': 'Draft updated.',
      'scanTotalValidationError': 'Total must be valid number > 0.',
      'scanEditParsedReceipt': 'Edit parsed receipt',
      'scanEditMerchant': 'Merchant',
      'scanEditCategory': 'Category',
      'scanEditPaymentMethod': 'Payment method',
      'scanEditTotal': 'Total',
      'scanDialogCancel': 'Cancel',
      'scanDialogApply': 'Apply',
      'scanErrorDismiss': 'Dismiss',
      'scanErrorRetry': 'Retry',
      'scanRecentEmptyHint': 'Scan first receipt to build history cards here.',
    },
    'bs': {
      'appTitle': 'Skeniranje Racuna',
      'home': 'Pocetna',
      'scan': 'Skeniraj',
      'history': 'Historija',
      'settings': 'Postavke',
      'settingsPlaceholder': 'Upravljanje postavkama aplikacije',
      'themeMode': 'Tema',
      'lightTheme': 'Svijetla',
      'darkTheme': 'Tamna',
      'systemTheme': 'Sistemska',
      'noReceiptsYet': 'Jos nema racuna. Sacuvaj jedan iz Skeniraj taba.',
      'scanReceiptTitle': 'Skeniraj racun',
      'scanReceiptSubtitle': 'Ucitaj ili uslikaj racun',
      'scanUpload': 'Ucitaj',
      'scanCamera': 'Kamera',
      'scanUploadTitle': 'Ucitaj racun',
      'scanUploadSubtitle': 'Dodirni za izbor iz galerije',
      'scanCameraTitle': 'Fotografisi',
      'scanCameraSubtitle': 'Koristi kameru za unos',
      'scanSupportFormats': 'Podrzano JPG, PNG • Max 10MB',
      'scanReceiptButton': 'Skeniraj racun',
      'scanReset': 'Ponisti',
      'scanAnother': 'Skeniraj novi',
      'scanRecentTitle': 'Skorija skeniranja',
      'scanSuccessTitle': 'Racun uspjesno skeniran!',
      'scanErrorTitle': 'Skeniranje nije uspjelo',
      'scanErrorFallback': 'Nije moguce obraditi sliku racuna.',
      'scanStepUploading': 'Otpremanje slike',
      'scanStepReading': 'Citanje teksta',
      'scanStepDetecting': 'Prepoznavanje stavki',
      'scanStepCategorizing': 'Kategorizacija racuna',
      'scanStepFinalizing': 'Zavrsna obrada',
      'scanMerchant': 'Prodavac',
      'scanTotal': 'Ukupno',
      'scanDate': 'Datum',
      'scanCategory': 'Kategorija',
      'scanItems': 'Stavke',
      'scanConfidence': 'Pouzdanost',
      'scanRetry': 'Pokusaj ponovo',
      'scanPickAnotherImage': 'Izaberi drugu sliku',
      'scanSaveReceipt': 'Sacuvaj racun',
      'scanEditBeforeSave': 'Uredi prije cuvanja',
      'scanSaving': 'Cuvanje...',
      'scanLowConfidenceWarning':
          'Niska pouzdanost parsiranja. Pregledaj prije cuvanja.',
      'scanReceiptSaved': 'Racun sacuvan.',
      'scanDraftUpdated': 'Nacrt azuriran.',
      'scanTotalValidationError': 'Ukupno mora biti broj > 0.',
      'scanEditParsedReceipt': 'Uredi parsirani racun',
      'scanEditMerchant': 'Prodavac',
      'scanEditCategory': 'Kategorija',
      'scanEditPaymentMethod': 'Nacin placanja',
      'scanEditTotal': 'Ukupno',
      'scanDialogCancel': 'Odustani',
      'scanDialogApply': 'Primijeni',
      'scanErrorDismiss': 'Zatvori',
      'scanErrorRetry': 'Ponovo',
      'scanRecentEmptyHint':
          'Skeniraj prvi racun da ovdje prikazemo historiju.',
    },
  };

  String get appTitle => _text('appTitle');
  String get home => _text('home');
  String get scan => _text('scan');
  String get history => _text('history');
  String get settings => _text('settings');
  String get homePlaceholder => _text('homePlaceholder');
  String get scanPlaceholder => _text('scanPlaceholder');
  String get historyPlaceholder => _text('historyPlaceholder');
  String get settingsPlaceholder => _text('settingsPlaceholder');
  String get themeMode => _text('themeMode');
  String get lightTheme => _text('lightTheme');
  String get darkTheme => _text('darkTheme');
  String get systemTheme => _text('systemTheme');
  String get saveDemoReceipt => _text('saveDemoReceipt');
  String get demoReceiptSaved => _text('demoReceiptSaved');
  String get refreshHistory => _text('refreshHistory');
  String get noReceiptsYet => _text('noReceiptsYet');
  String get scanReceiptTitle => _text('scanReceiptTitle');
  String get scanReceiptSubtitle => _text('scanReceiptSubtitle');
  String get scanUpload => _text('scanUpload');
  String get scanCamera => _text('scanCamera');
  String get scanUploadTitle => _text('scanUploadTitle');
  String get scanUploadSubtitle => _text('scanUploadSubtitle');
  String get scanCameraTitle => _text('scanCameraTitle');
  String get scanCameraSubtitle => _text('scanCameraSubtitle');
  String get scanSupportFormats => _text('scanSupportFormats');
  String get scanReceiptButton => _text('scanReceiptButton');
  String get scanReset => _text('scanReset');
  String get scanAnother => _text('scanAnother');
  String get scanRecentTitle => _text('scanRecentTitle');
  String get scanSuccessTitle => _text('scanSuccessTitle');
  String get scanErrorTitle => _text('scanErrorTitle');
  String get scanErrorFallback => _text('scanErrorFallback');
  String get scanStepUploading => _text('scanStepUploading');
  String get scanStepReading => _text('scanStepReading');
  String get scanStepDetecting => _text('scanStepDetecting');
  String get scanStepCategorizing => _text('scanStepCategorizing');
  String get scanStepFinalizing => _text('scanStepFinalizing');
  String get scanMerchant => _text('scanMerchant');
  String get scanTotal => _text('scanTotal');
  String get scanDate => _text('scanDate');
  String get scanCategory => _text('scanCategory');
  String get scanItems => _text('scanItems');
  String get scanConfidence => _text('scanConfidence');
  String get scanRetry => _text('scanRetry');
  String get scanPickAnotherImage => _text('scanPickAnotherImage');
  String get scanSaveReceipt => _text('scanSaveReceipt');
  String get scanEditBeforeSave => _text('scanEditBeforeSave');
  String get scanSaving => _text('scanSaving');
  String get scanLowConfidenceWarning => _text('scanLowConfidenceWarning');
  String get scanReceiptSaved => _text('scanReceiptSaved');
  String get scanDraftUpdated => _text('scanDraftUpdated');
  String get scanTotalValidationError => _text('scanTotalValidationError');
  String get scanEditParsedReceipt => _text('scanEditParsedReceipt');
  String get scanEditMerchant => _text('scanEditMerchant');
  String get scanEditCategory => _text('scanEditCategory');
  String get scanEditPaymentMethod => _text('scanEditPaymentMethod');
  String get scanEditTotal => _text('scanEditTotal');
  String get scanDialogCancel => _text('scanDialogCancel');
  String get scanDialogApply => _text('scanDialogApply');
  String get scanErrorDismiss => _text('scanErrorDismiss');
  String get scanErrorRetry => _text('scanErrorRetry');
  String get scanRecentEmptyHint => _text('scanRecentEmptyHint');

  String _text(String key) {
    final String languageCode =
        _localizedValues.containsKey(locale.languageCode)
        ? locale.languageCode
        : 'en';
    return _localizedValues[languageCode]?[key] ??
        _localizedValues['en']![key] ??
        key;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales
        .map((item) => item.languageCode)
        .contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return Future<AppLocalizations>.value(AppLocalizations(locale));
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}
