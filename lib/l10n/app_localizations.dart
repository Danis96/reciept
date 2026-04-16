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
      'scanViewDetails': 'View Details',
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
  String get scanViewDetails => _text('scanViewDetails');
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
