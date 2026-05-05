import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('bs'),
    Locale('da'),
  ];

  static final AppLocalizations fallback = AppLocalizations(const Locale('en'));

  static AppLocalizations get current {
    final String localeName = Intl.getCurrentLocale();
    final String languageCode = localeName
        .split(RegExp('[-_]'))
        .first
        .trim()
        .toLowerCase();
    return AppLocalizations(Locale(languageCode.isEmpty ? 'en' : languageCode));
  }

  static AppLocalizations of(BuildContext context) {
    final AppLocalizations? result = Localizations.of<AppLocalizations>(
      context,
      AppLocalizations,
    );
    return result ?? fallback;
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'Refyn',
      'home': 'Home',
      'scan': 'Scan',
      'history': 'History',
      'settings': 'Settings',
      'language': 'Language',
      'languageEnglish': 'English',
      'languageBosnian': 'Bosnian',
      'languageDanish': 'Danish',
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
      'scanPickAnotherImage': 'Pick Image',
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
      'appTitle': 'Refyn',
      'home': 'Pocetna',
      'scan': 'Skeniraj',
      'history': 'Historija',
      'settings': 'Postavke',
      'language': 'Jezik',
      'languageEnglish': 'Engleski',
      'languageBosnian': 'Bosanski',
      'languageDanish': 'Danski',
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
    'da': {
      'appTitle': 'Refyn',
      'home': 'Hjem',
      'scan': 'Scan',
      'history': 'Historik',
      'settings': 'Indstillinger',
      'language': 'Sprog',
      'languageEnglish': 'Engelsk',
      'languageBosnian': 'Bosnisk',
      'languageDanish': 'Dansk',
      'homePlaceholder': 'Startskarm (Fase 1)',
      'scanPlaceholder': 'Scanskarm (Fase 1)',
      'historyPlaceholder': 'Historikskarm (Fase 1)',
      'settingsPlaceholder': 'Appindstillinger',
      'themeMode': 'Tema',
      'lightTheme': 'Lys',
      'darkTheme': 'Mork',
      'systemTheme': 'System',
      'saveDemoReceipt': 'Gem demokvittering',
      'demoReceiptSaved': 'Demokvittering gemt i historik',
      'refreshHistory': 'Opdater historik',
      'noReceiptsYet': 'Ingen kvitteringer endnu. Gem en fra fanen Scan.',
      'scanReceiptTitle': 'Scan kvittering',
      'scanReceiptSubtitle': 'Upload eller tag billede af en kvittering',
      'scanUpload': 'Upload',
      'scanCamera': 'Kamera',
      'scanUploadTitle': 'Upload kvittering',
      'scanUploadSubtitle': 'Tryk for at valge fra galleri',
      'scanCameraTitle': 'Tag foto',
      'scanCameraSubtitle': 'Brug kamera til optagelse',
      'scanSupportFormats': 'Understotter JPG, PNG • Maks 10 MB',
      'scanReceiptButton': 'Scan kvittering',
      'scanReset': 'Nulstil',
      'scanAnother': 'Scan en til',
      'scanRecentTitle': 'Seneste scanninger',
      'scanSuccessTitle': 'Kvittering scannet!',
      'scanErrorTitle': 'Scanning mislykkedes',
      'scanErrorFallback': 'Kunne ikke behandle kvitteringsbilledet.',
      'scanStepUploading': 'Uploader billede',
      'scanStepReading': 'Laser tekst',
      'scanStepDetecting': 'Finder varer',
      'scanStepCategorizing': 'Kategoriserer kvittering',
      'scanStepFinalizing': 'Faerdiggor data',
      'scanMerchant': 'Butik',
      'scanTotal': 'I alt',
      'scanDate': 'Dato',
      'scanCategory': 'Kategori',
      'scanItems': 'Varer',
      'scanConfidence': 'Sikkerhed',
      'scanRetry': 'Prov igen',
      'scanPickAnotherImage': 'Vaelg billede',
      'scanSaveReceipt': 'Gem kvittering',
      'scanEditBeforeSave': 'Rediger for gem',
      'scanSaving': 'Gemmer...',
      'scanLowConfidenceWarning':
          'Lav parse-sikkerhed. Gennemga før du gemmer.',
      'scanReceiptSaved': 'Kvittering gemt.',
      'scanDraftUpdated': 'Kladde opdateret.',
      'scanTotalValidationError': 'Belob skal vaere et gyldigt tal > 0.',
      'scanEditParsedReceipt': 'Rediger fortolket kvittering',
      'scanEditMerchant': 'Butik',
      'scanEditCategory': 'Kategori',
      'scanEditPaymentMethod': 'Betalingsmetode',
      'scanEditTotal': 'I alt',
      'scanDialogCancel': 'Annuller',
      'scanDialogApply': 'Anvend',
      'scanErrorDismiss': 'Luk',
      'scanErrorRetry': 'Prov igen',
      'scanRecentEmptyHint':
          'Scan din forste kvittering for at vise historik her.',
    },
  };

  String get appTitle => _text('appTitle');
  String get home => _text('home');
  String get scan => _text('scan');
  String get history => _text('history');
  String get settings => _text('settings');
  String get language => _text('language');
  String get languageEnglish => _text('languageEnglish');
  String get languageBosnian => _text('languageBosnian');
  String get languageDanish => _text('languageDanish');
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

  String get close => _byLanguage(
    en: 'Close',
    bs: 'Zatvori',
    da: 'Luk',
  );
  String get cancel => _byLanguage(
    en: 'Cancel',
    bs: 'Odustani',
    da: 'Annuller',
  );
  String get save => _byLanguage(
    en: 'Save',
    bs: 'Sacuvaj',
    da: 'Gem',
  );
  String get clear => _byLanguage(
    en: 'Clear',
    bs: 'Ocisti',
    da: 'Ryd',
  );
  String get delete => _byLanguage(
    en: 'Delete',
    bs: 'Obrisi',
    da: 'Slet',
  );
  String get edit => _byLanguage(
    en: 'Edit',
    bs: 'Uredi',
    da: 'Rediger',
  );
  String get retry => _byLanguage(
    en: 'Retry',
    bs: 'Ponovo',
    da: 'Prov igen',
  );
  String get confirm => _byLanguage(
    en: 'Confirm',
    bs: 'Potvrdi',
    da: 'Bekraeft',
  );
  String get reset => _byLanguage(
    en: 'Reset',
    bs: 'Resetuj',
    da: 'Nulstil',
  );
  String get about => _byLanguage(
    en: 'About',
    bs: 'O aplikaciji',
    da: 'Om',
  );
  String get appVersion => _byLanguage(
    en: 'App Version',
    bs: 'Verzija aplikacije',
    da: 'App-version',
  );
  String get export => _byLanguage(
    en: 'Export',
    bs: 'Izvoz',
    da: 'Eksport',
  );
  String get privacyPolicy => _byLanguage(
    en: 'Privacy Policy',
    bs: 'Pravila privatnosti',
    da: 'Privatlivspolitik',
  );
  String get termsOfService => _byLanguage(
    en: 'Terms of Service',
    bs: 'Uslovi koristenja',
    da: 'Servicevilkar',
  );
  String get receiptDetails => _byLanguage(
    en: 'Receipt Details',
    bs: 'Detalji racuna',
    da: 'Kvitteringsdetaljer',
  );
  String get receiptNumber => _byLanguage(
    en: 'Receipt Number',
    bs: 'Broj racuna',
    da: 'Kvitteringsnummer',
  );
  String get paymentSummary => _byLanguage(
    en: 'Payment Summary',
    bs: 'Sazetak placanja',
    da: 'Betalingsoversigt',
  );
  String get date => _byLanguage(
    en: 'Date',
    bs: 'Datum',
    da: 'Dato',
  );
  String get merchant => _byLanguage(
    en: 'Merchant',
    bs: 'Prodavac',
    da: 'Butik',
  );
  String get paymentMethod => _byLanguage(
    en: 'Payment Method',
    bs: 'Nacin placanja',
    da: 'Betalingsmetode',
  );
  String get subtotal => _byLanguage(
    en: 'Subtotal',
    bs: 'Meduzbir',
    da: 'Subtotal',
  );
  String get tax => _byLanguage(
    en: 'Tax',
    bs: 'Porez',
    da: 'Moms',
  );
  String get total => _byLanguage(
    en: 'Total',
    bs: 'Ukupno',
    da: 'I alt',
  );
  String get unknownMerchant => _byLanguage(
    en: 'Unknown merchant',
    bs: 'Nepoznat prodavac',
    da: 'Ukendt butik',
  );
  String get unknown => _byLanguage(
    en: 'Unknown',
    bs: 'Nepoznato',
    da: 'Ukendt',
  );
  String get unnamedItem => _byLanguage(
    en: 'Unnamed item',
    bs: 'Neimenovana stavka',
    da: 'Unavngivet vare',
  );
  String get shareUnavailable => _byLanguage(
    en: 'Share is not available yet.',
    bs: 'Dijeljenje jos nije dostupno.',
    da: 'Deling er ikke tilgaengelig endnu.',
  );
  String get keepReceiptForRecords => _byLanguage(
    en: 'Keep this receipt for your records',
    bs: 'Sacuvaj ovaj racun za svoju evidenciju',
    da: 'Gem denne kvittering til dine poster',
  );
  String get searchHistoryHint => _byLanguage(
    en: 'Search by merchant, item, or category...',
    bs: 'Pretrazi po prodavacu, stavci ili kategoriji...',
    da: 'Sog efter butik, vare eller kategori...',
  );
  String get noItemsFound => _byLanguage(
    en: 'No items found',
    bs: 'Nema pronadjenih stavki',
    da: 'Ingen varer fundet',
  );
  String get noItemsFoundAll => _byLanguage(
    en: 'Try a different merchant, item, category, or date range. Saved receipt items will appear here.',
    bs: 'Probaj drugog prodavaca, stavku, kategoriju ili datum. Sacuvane stavke racuna ce se prikazati ovdje.',
    da: 'Prov en anden butik, vare, kategori eller datoperiode. Gemte kvitteringsvarer vises her.',
  );
  String noItemsFoundCategory(String categoryLabel) => _byLanguage(
    en: 'No ${categoryLabel.toLowerCase()} items match the current search or date range.',
    bs: 'Nijedna stavka kategorije ${categoryLabel.toLowerCase()} ne odgovara trenutnoj pretrazi ili datumu.',
    da: 'Ingen ${categoryLabel.toLowerCase()}-varer matcher den aktuelle sogning eller datoperiode.',
  );
  String qtyLabel(String quantity) => _byLanguage(
    en: 'Qty: $quantity',
    bs: 'Kol: $quantity',
    da: 'Antal: $quantity',
  );
  String get recentReceipts => _byLanguage(
    en: 'Recent Receipts',
    bs: 'Skoriji racuni',
    da: 'Seneste kvitteringer',
  );
  String get viewAll => _byLanguage(
    en: 'View All',
    bs: 'Vidi sve',
    da: 'Se alle',
  );
  String get all => _byLanguage(en: 'All', bs: 'Sve', da: 'Alle');
  String get oldestFirst => _byLanguage(
    en: 'Oldest First',
    bs: 'Najstarije prvo',
    da: 'Aeldste forst',
  );
  String get highestAmount => _byLanguage(
    en: 'Highest Amount',
    bs: 'Najveci iznos',
    da: 'Hojeste belob',
  );
  String get lowestAmount => _byLanguage(
    en: 'Lowest Amount',
    bs: 'Najmanji iznos',
    da: 'Laveste belob',
  );
  String historyTotalsLabel(int itemCount, int receiptCount) => _byLanguage(
    en: '$itemCount total items from $receiptCount receipts',
    bs: '$itemCount ukupno stavki iz $receiptCount racuna',
    da: '$itemCount varer fra $receiptCount kvitteringer',
  );
  String get noBudgetsYet => _byLanguage(
    en: 'No budgets yet',
    bs: 'Jos nema budzeta',
    da: 'Ingen budgetter endnu',
  );
  String get noBudgetsYetMessage => _byLanguage(
    en: 'Create monthly category budgets from Manage and track each spend bucket here.',
    bs: 'Kreiraj mjesecne budzete po kategoriji iz Upravljaj i prati potrosnju ovdje.',
    da: 'Opret manedlige kategoribudgetter fra Administrer og spor hvert forbrugsomrade her.',
  );
  String get show => _byLanguage(en: 'Show', bs: 'Prikazi', da: 'Vis');
  String get hide => _byLanguage(en: 'Hide', bs: 'Sakrij', da: 'Skjul');
  String get manage => _byLanguage(
    en: 'Manage',
    bs: 'Upravljaj',
    da: 'Administrer',
  );
  String get categoryBudgets => _byLanguage(
    en: 'Category Budgets',
    bs: 'Budzeti po kategoriji',
    da: 'Kategoribudgetter',
  );
  String get localDeviceData => _byLanguage(
    en: 'Local device data',
    bs: 'Lokalni podaci uredjaja',
    da: 'Lokale enhedsdata',
  );
  String get theme => _byLanguage(en: 'Theme', bs: 'Tema', da: 'Tema');
  String get aiConfiguration => _byLanguage(
    en: 'AI configuration',
    bs: 'AI konfiguracija',
    da: 'AI-konfiguration',
  );
  String get homeSpendingOverview => _byLanguage(
    en: "Here's your spending overview",
    bs: 'Ovo je pregled tvoje potrosnje',
    da: 'Her er dit forbrugsoverblik',
  );
  String get thisMonth => _byLanguage(
    en: 'This Month',
    bs: 'Ovaj mjesec',
    da: 'Denne maned',
  );
  String get budget => _byLanguage(
    en: 'Budget',
    bs: 'Budzet',
    da: 'Budget',
  );
  String spentAmountLabel(String amount, [String currency = '']) => _byLanguage(
    en: '$amount${currency.isNotEmpty ? ' $currency' : ''} spent',
    bs: 'Potroseno $amount${currency.isNotEmpty ? ' $currency' : ''}',
    da: '$amount${currency.isNotEmpty ? ' $currency' : ''} brugt',
  );
  String remainingAmountLabel(String amount, [String currency = '']) => _byLanguage(
    en: '$amount${currency.isNotEmpty ? ' $currency' : ''} left',
    bs: 'Preostalo $amount${currency.isNotEmpty ? ' $currency' : ''}',
    da: '$amount${currency.isNotEmpty ? ' $currency' : ''} tilbage',
  );
  String overBudgetLabel(String amount, [String currency = '']) => _byLanguage(
    en: '$amount${currency.isNotEmpty ? ' $currency' : ''} over',
    bs: '$amount${currency.isNotEmpty ? ' $currency' : ''} preko',
    da: '$amount${currency.isNotEmpty ? ' $currency' : ''} over',
  );
  String get itemsInThisCategory => _byLanguage(
    en: 'Items in this category',
    bs: 'Stavke u ovoj kategoriji',
    da: 'Varer i denne kategori',
  );
  String itemsInCategoryThisMonthLabel(String categoryLabel) => _byLanguage(
    en: 'Current month purchases matched to ${categoryLabel.toLowerCase()}.',
    bs: 'Kupovine iz tekuceg mjeseca povezane sa kategorijom ${categoryLabel.toLowerCase()}.',
    da: 'Denne maneds kob matcher kategorien ${categoryLabel.toLowerCase()}.',
  );
  String noTrackedItemsInCategoryLabel(String categoryLabel) => _byLanguage(
    en: 'No tracked items yet for $categoryLabel in current month.',
    bs: 'Jos nema pracenih stavki za kategoriju $categoryLabel u tekucom mjesecu.',
    da: 'Ingen sporede varer endnu for $categoryLabel i denne maned.',
  );
  String get item => _byLanguage(en: 'Item', bs: 'Stavka', da: 'Vare');
  String get receiptNotFound => _byLanguage(
    en: 'Receipt not found',
    bs: 'Racun nije pronadjen',
    da: 'Kvittering ikke fundet',
  );
  String usedPercentLabel(int percent) => _byLanguage(
    en: '$percent% used',
    bs: '$percent% potroseno',
    da: '$percent% brugt',
  );
  String remainingBudgetLabel(String amount, [String currency = '']) => _byLanguage(
    en: '$amount${currency.isNotEmpty ? ' $currency' : ''} left',
    bs: 'Preostalo $amount${currency.isNotEmpty ? ' $currency' : ''}',
    da: '$amount${currency.isNotEmpty ? ' $currency' : ''} tilbage',
  );
  String get retryHome => _byLanguage(
    en: 'Retry',
    bs: 'Pokusaj ponovo',
    da: 'Prov igen',
  );
  String activeBudgetsLabel(int count) => _byLanguage(
    en: '$count active budgets',
    bs: '$count aktivnih budzeta',
    da: '$count aktive budgetter',
  );
  String budgetCategoriesHiddenLabel(int count) => _byLanguage(
    en: '$count budget categories hidden',
    bs: '$count kategorija budzeta sakriveno',
    da: '$count budgetkategorier skjult',
  );
  String get budgetSheetDescription => _byLanguage(
    en: 'Set monthly limits by category. Save each card when ready.',
    bs: 'Postavi mjesecne limite po kategoriji. Sacuvaj svaku karticu kada zavrsis.',
    da: 'Saet manedlige graenser pr. kategori. Gem hvert kort, nar du er klar.',
  );
  String get noBudgetSet => _byLanguage(
    en: 'No budget set',
    bs: 'Budzet nije postavljen',
    da: 'Intet budget sat',
  );
  String activeBudgetAmountLabel(String amount, [String currency = '']) => _byLanguage(
    en: '$amount${currency.isNotEmpty ? ' $currency' : ''} active',
    bs: '$amount${currency.isNotEmpty ? ' $currency' : ''} aktivno',
    da: '$amount${currency.isNotEmpty ? ' $currency' : ''} aktivt',
  );
  String get enterMonthlyBudget => _byLanguage(
    en: 'Enter monthly budget',
    bs: 'Unesi mjesecni budzet',
    da: 'Indtast manedligt budget',
  );
  String get enterValidBudgetAmount => _byLanguage(
    en: 'Enter a valid budget amount.',
    bs: 'Unesi ispravan iznos budzeta.',
    da: 'Indtast et gyldigt budgetbelob.',
  );
  String budgetDeletedLabel(String category) => _byLanguage(
    en: '$category budget deleted.',
    bs: 'Budzet za $category je obrisan.',
    da: '$category-budget slettet.',
  );
  String budgetSavedLabel(String category) => _byLanguage(
    en: '$category budget saved.',
    bs: 'Budzet za $category je sacuvan.',
    da: '$category-budget gemt.',
  );
  String get settingsExportDescription => _byLanguage(
    en: 'Share all saved receipts as CSV, PDF, or a prefilled email draft.',
    bs: 'Podijeli sve sacuvane racune kao CSV, PDF ili unaprijed popunjen email.',
    da: 'Del alle gemte kvitteringer som CSV, PDF eller et forudfyldt e-mailudkast.',
  );
  String get localDeviceDataDescription => _byLanguage(
    en: 'Manage on-device data with backup export, restore, and full reset.',
    bs: 'Upravljaj lokalnim podacima kroz izvoz backupa, vracanje i potpuno brisanje.',
    da: 'Administrer lokale data med backup-eksport, gendannelse og fuld nulstilling.',
  );
  String get preparingBackup => _byLanguage(en: 'Preparing backup...', bs: 'Priprema backup...', da: 'Forbereder backup...');
  String get exportBackup => _byLanguage(en: 'Export backup', bs: 'Izvezi backup', da: 'Eksporter backup');
  String get importingBackup => _byLanguage(en: 'Importing backup...', bs: 'Uvoz backupa...', da: 'Importerer backup...');
  String get importBackup => _byLanguage(en: 'Import backup', bs: 'Uvezi backup', da: 'Importer backup');
  String get clearingData => _byLanguage(en: 'Clearing data...', bs: 'Brisanje podataka...', da: 'Rydder data...');
  String get clearLocalData => _byLanguage(en: 'Clear local data', bs: 'Obrisi lokalne podatke', da: 'Ryd lokale data');
  String get csvExportTitle => _byLanguage(en: 'CSV export', bs: 'CSV izvoz', da: 'CSV-eksport');
  String get csvExportSubtitle => _byLanguage(en: 'Spreadsheet-friendly export for all saved receipts.', bs: 'Izvoz prilagodjen tabelama za sve sacuvane racune.', da: 'Regnearksvenlig eksport for alle gemte kvitteringer.');
  String get exportCsv => _byLanguage(en: 'Export CSV', bs: 'Izvezi CSV', da: 'Eksporter CSV');
  String get preparingCsv => _byLanguage(en: 'Preparing CSV...', bs: 'Priprema CSV...', da: 'Forbereder CSV...');
  String get pdfReportTitle => _byLanguage(en: 'PDF report', bs: 'PDF izvjestaj', da: 'PDF-rapport');
  String get pdfReportSubtitle => _byLanguage(en: 'Readable summary report with receipt totals and items.', bs: 'Citljiv sazetak sa ukupnim iznosima i stavkama racuna.', da: 'Laesbar oversigtsrapport med kvitteringstotaler og varer.');
  String get exportPdf => _byLanguage(en: 'Export PDF', bs: 'Izvezi PDF', da: 'Eksporter PDF');
  String get preparingPdf => _byLanguage(en: 'Preparing PDF...', bs: 'Priprema PDF...', da: 'Forbereder PDF...');
  String get emailDraftTitle => _byLanguage(en: 'Email draft', bs: 'Email nacrt', da: 'E-mailudkast');
  String get emailDraftSubtitle => _byLanguage(en: 'Open mail app with a prefilled receipt report and attachments.', bs: 'Otvori mail aplikaciju sa unaprijed popunjenim izvjestajem i prilozima.', da: 'Abn mailappen med en forudfyldt kvitteringsrapport og vedhaeftninger.');
  String get composeEmail => _byLanguage(en: 'Compose email', bs: 'Napisi email', da: 'Skriv e-mail');
  String get openingMail => _byLanguage(en: 'Opening mail...', bs: 'Otvaranje maila...', da: 'Abner mail...');
  String get builtInKeyActive => _byLanguage(en: 'Built-in key active', bs: 'Ugradjeni kljuc aktivan', da: 'Indbygget nogle aktiv');
  String get pasteGoogleAiKey => _byLanguage(en: 'Paste your Google AI API key', bs: 'Zalijepi svoj Google AI API kljuc', da: 'Indsaet din Google AI API-nogle');
  String get defaultKeyHiddenHelper => _byLanguage(en: 'Default key is hidden. Enter a custom key to override.', bs: 'Podrazumijevani kljuc je skriven. Unesi vlastiti kljuc za zamjenu.', da: 'Standardnoglen er skjult. Indtast en brugerdefineret nogel for at tilsidesaette den.');
  String get apiKey => _byLanguage(en: 'API key', bs: 'API kljuc', da: 'API-nogle');
  String get model => _byLanguage(en: 'Model', bs: 'Model', da: 'Model');
  String get modelSelectionDescription => _byLanguage(en: 'Pick which Gemma model handles receipt extraction.', bs: 'Izaberi koji Gemma model obradjuje izdvajanje racuna.', da: 'Vaelg hvilken Gemma-model der handterer kvitteringsudtraek.');
  String get deeperThinking => _byLanguage(en: 'Deeper thinking', bs: 'Dublje razmisljanje', da: 'Dybere taenkning');
  String get deeperThinkingOn => _byLanguage(en: 'Slower scans, more accurate parsing for tricky receipts.', bs: 'Sporije skeniranje, preciznije parsiranje za zahtjevne racune.', da: 'Langsommere scanninger, mere praecis parsing for svaere kvitteringer.');
  String get deeperThinkingOff => _byLanguage(en: 'Fast scans with minimal reasoning. Best default for clear receipts.', bs: 'Brzo skeniranje sa minimalnim razmisljanjem. Najbolji izbor za jasne racune.', da: 'Hurtige scanninger med minimal taenkning. Bedste standardvalg for tydelige kvitteringer.');
  String aiModelsAvailableLabel(int count) => _byLanguage(en: 'Key confirmed. $count Gemma models available.', bs: 'Kljuc potvrden. Dostupno $count Gemma modela.', da: 'Nogle bekraeftet. $count Gemma-modeller tilgaengelige.');
  String get builtInKeyInUse => _byLanguage(en: 'Built-in key in use. Override by entering your own key.', bs: 'Ugradjeni kljuc je u upotrebi. Zamijeni ga unosom vlastitog kljuca.', da: 'Indbygget nogel er i brug. Tilsidesaet den ved at indtaste din egen nogel.');
  String get savedKeyInvalid => _byLanguage(en: 'Saved key is invalid. Re-enter and confirm again.', bs: 'Sacuvani kljuc nije ispravan. Unesi ga ponovo i potvrdi.', da: 'Den gemte nogel er ugyldig. Indtast og bekraeft igen.');
  String get noKeySet => _byLanguage(en: 'No key set. Add one to enable scanning.', bs: 'Kljuc nije postavljen. Dodaj ga da omogucis skeniranje.', da: 'Ingen nogel sat. Tilfoj en for at aktivere scanning.');
  String get loadingSavedAiConfiguration => _byLanguage(en: 'Loading saved AI configuration...', bs: 'Ucitam sacuvanu AI konfiguraciju...', da: 'Indlaeser gemt AI-konfiguration...');
  String get confirmingKeyWithGoogleAi => _byLanguage(en: 'Confirming key with Google AI...', bs: 'Potvrda kljuca sa Google AI...', da: 'Bekraefter nogle med Google AI...');
  String get aiConfigurationDescription => _byLanguage(en: 'Connect a Google AI key to scan receipts. Pick a Gemma model and toggle deeper thinking when needed.', bs: 'Povezi Google AI kljuc za skeniranje racuna. Izaberi Gemma model i ukljuci dublje razmisljanje po potrebi.', da: 'Forbind en Google AI-nogle for at scanne kvitteringer. Vaelg en Gemma-model og sla dybere taenkning til ved behov.');
  String get howAiConfigurationWorks => _byLanguage(en: 'How AI configuration works', bs: 'Kako radi AI konfiguracija', da: 'Sadan fungerer AI-konfiguration');
  String get aiInfoSubtitle => _byLanguage(en: 'How your key, model, and thinking level affect scans.', bs: 'Kako kljuc, model i nivo razmisljanja uticu na skeniranje.', da: 'Hvordan din nogel, model og taenkeniveau paavirker scanninger.');
  String get bringYourOwnKey => _byLanguage(en: 'Bring your own key', bs: 'Koristi svoj kljuc', da: 'Brug din egen nogel');
  String get bringYourOwnKeyBody => _byLanguage(en: 'Receipt sends image data directly to Google AI using your API key. No middleman.', bs: 'Aplikacija salje podatke slike direktno Google AI koristeci tvoj API kljuc. Bez posrednika.', da: 'Appen sender billeddata direkte til Google AI med din API-nogle. Ingen mellemmand.');
  String get staysOnDevice => _byLanguage(en: 'Stays on device', bs: 'Ostaje na uredjaju', da: 'Bliver pa enheden');
  String get staysOnDeviceBody => _byLanguage(en: 'Your key is stored locally only. It never leaves the app except in requests to Google AI.', bs: 'Tvoj kljuc se cuva samo lokalno. Ne napusta aplikaciju osim u zahtjevima prema Google AI.', da: 'Din nogel gemmes kun lokalt. Den forlader kun appen i anmodninger til Google AI.');
  String get quotaIsYours => _byLanguage(en: '15,000 free requests per day', bs: '15,000 zahtjeva dnevno.', da: 'Kvoten er din');
  String get quotaIsYoursBody => _byLanguage(en: 'Receipt scan calls count against your own Google AI quota and billing.', bs: 'Pozivi za skeniranje racuna trose tvoju Google AI kvotu i naplatu.', da: 'Kvitteringsscanninger taeller mod din egen Google AI-kvote og fakturering.');
  String get pickGemmaModel => _byLanguage(en: 'Pick a Gemma model', bs: 'Izaberi Gemma model', da: 'Vaelg en Gemma-model');
  String get pickGemmaModelBody => _byLanguage(en: 'After confirming a key, Receipt loads compatible Gemma models you can pick from.', bs: 'Nakon potvrde kljuca aplikacija ucitava kompatibilne Gemma modele koje mozes izabrati.', da: 'Efter bekraeftelse af en nogel indlaeser appen kompatible Gemma-modeller, du kan vaelge imellem.');
  String get quickSteps => _byLanguage(en: 'Quick steps', bs: 'Brzi koraci', da: 'Hurtige trin');
  String get quickStep1 => _byLanguage(en: '1. Get a Google AI Studio API key.', bs: '1. Nabavi Google AI Studio API kljuc.', da: '1. Hent en Google AI Studio API-nogle.');
  String get quickStep2 => _byLanguage(en: '2. Paste it above and tap Confirm.', bs: '2. Zalijepi ga iznad i dodirni Potvrdi.', da: '2. Indsaet den ovenfor og tryk Bekraeft.');
  String get quickStep3 => _byLanguage(en: '3. Pick a Gemma model from the dropdown.', bs: '3. Izaberi Gemma model iz padajuceg menija.', da: '3. Vaelg en Gemma-model fra rullemenuen.');
  String get quickStep4 => _byLanguage(en: '4. Optional: enable deeper thinking for tricky receipts.', bs: '4. Opcionalno: ukljuci dublje razmisljanje za zahtjevne racune.', da: '4. Valgfrit: aktiver dybere taenkning for svaere kvitteringer.');
  String get gotIt => _byLanguage(en: 'Got it', bs: 'Razumijem', da: 'Forstaet');
  String get aiConfigurationFailed => _byLanguage(en: 'AI configuration failed', bs: 'AI konfiguracija nije uspjela', da: 'AI-konfiguration mislykkedes');
  String get addApiKeyBeforeConfirming => _byLanguage(en: 'Add an API key before confirming.', bs: 'Dodaj API kljuc prije potvrde.', da: 'Tilfoj en API-nogle for bekraeftelse.');
  String get aiConfigurationConfirmFailed => _byLanguage(en: 'Could not confirm AI configuration. Try again.', bs: 'Nije moguce potvrditi AI konfiguraciju. Pokusaj ponovo.', da: 'Kunne ikke bekraefte AI-konfiguration. Prov igen.');
  String get backupFailed => _byLanguage(en: 'Backup failed', bs: 'Backup nije uspio', da: 'Backup mislykkedes');
  String backupReadyLabel(int receiptCount, int attachmentCount) => _byLanguage(en: 'Backup ready. Receipts: $receiptCount, attachments: $attachmentCount.', bs: 'Backup spreman. Racuni: $receiptCount, prilozi: $attachmentCount.', da: 'Backup klar. Kvitteringer: $receiptCount, vedhaeftninger: $attachmentCount.');
  String get exportFailed => _byLanguage(en: 'Export failed', bs: 'Izvoz nije uspio', da: 'Eksport mislykkedes');
  String exportReadyLabel(String formatLabel) => _byLanguage(en: '$formatLabel export ready.', bs: '$formatLabel izvoz je spreman.', da: '$formatLabel-eksport klar.');
  String get mailAppOpenedWithExport => _byLanguage(en: 'Mail app opened with receipt export.', bs: 'Mail aplikacija je otvorena sa izvozom racuna.', da: 'Mailappen blev abnet med kvitteringseksport.');
  String get mailAppOpenedManualAttachments => _byLanguage(en: 'Mail app opened. Attachments may need manual add.', bs: 'Mail aplikacija je otvorena. Prilozi ce mozda trebati rucno dodati.', da: 'Mailappen blev abnet. Vedhaeftninger skal muligvis tilfojes manuelt.');
  String get emailUnavailable => _byLanguage(en: 'Email unavailable', bs: 'Email nije dostupan', da: 'E-mail ikke tilgaengelig');
  String get noMailAppAvailable => _byLanguage(en: 'No mail app available on this device.', bs: 'Na ovom uredjaju nema dostupne mail aplikacije.', da: 'Ingen mailapp tilgaengelig pa denne enhed.');
  String get emailExportFailed => _byLanguage(en: 'Email export failed', bs: 'Email izvoz nije uspio', da: 'E-maileksport mislykkedes');
  String get importBackupQuestion => _byLanguage(en: 'Import backup?', bs: 'Uvesti backup?', da: 'Importer backup?');
  String get importBackupWarning => _byLanguage(en: 'This replaces all current local receipts, budgets, and settings on this device.', bs: 'Ovo zamjenjuje sve trenutne lokalne racune, budzete i postavke na ovom uredjaju.', da: 'Dette erstatter alle nuvaerende lokale kvitteringer, budgetter og indstillinger pa denne enhed.');
  String get restoreFailed => _byLanguage(en: 'Restore failed', bs: 'Vracanje nije uspjelo', da: 'Gendannelse mislykkedes');
  String backupRestoredLabel(int receiptCount, int attachmentCount) => _byLanguage(en: 'Backup restored. Receipts: $receiptCount, attachments: $attachmentCount.', bs: 'Backup vracen. Racuni: $receiptCount, prilozi: $attachmentCount.', da: 'Backup gendannet. Kvitteringer: $receiptCount, vedhaeftninger: $attachmentCount.');
  String get clearLocalDataQuestion => _byLanguage(en: 'Clear local data?', bs: 'Obrisati lokalne podatke?', da: 'Ryd lokale data?');
  String get clearLocalDataWarning => _byLanguage(en: 'This deletes receipts, budgets, and app settings from this device.', bs: 'Ovo brise racune, budzete i postavke aplikacije sa ovog uredjaja.', da: 'Dette sletter kvitteringer, budgetter og appindstillinger fra denne enhed.');
  String get localDataCleared => _byLanguage(en: 'Local data cleared.', bs: 'Lokalni podaci obrisani.', da: 'Lokale data ryddet.');
  String get clearFailed => _byLanguage(en: 'Clear failed', bs: 'Brisanje nije uspjelo', da: 'Rydning mislykkedes');
  String get privacyPolicyPlaceholder => _byLanguage(en: 'Privacy policy details will be added in a future phase.', bs: 'Detalji pravila privatnosti ce biti dodani u narednoj fazi.', da: 'Detaljer om privatlivspolitik tilfojes i en fremtidig fase.');
  String get termsOfServicePlaceholder => _byLanguage(en: 'Terms of service details will be added in a future phase.', bs: 'Detalji uslova koristenja ce biti dodani u narednoj fazi.', da: 'Detaljer om servicevilkar tilfojes i en fremtidig fase.');
  String get unknownError => _byLanguage(en: 'Unknown error.', bs: 'Nepoznata greska.', da: 'Ukendt fejl.');
  String get deleteReceiptQuestion => _byLanguage(en: 'Delete Receipt?', bs: 'Obrisati racun?', da: 'Slet kvittering?');
  String get deleteReceiptWarning => _byLanguage(en: 'This action cannot be undone. This will permanently delete this receipt from your history.', bs: 'Ovu radnju nije moguce ponistiti. Racun ce trajno biti obrisan iz historije.', da: 'Denne handling kan ikke fortrydes. Denne kvittering slettes permanent fra din historik.');
  String fileSavedLabel(String formatLabel, String path) => _byLanguage(en: '$formatLabel saved: $path', bs: '$formatLabel sacuvan: $path', da: '$formatLabel gemt: $path');
  String get editReceipt => _byLanguage(en: 'Edit Receipt', bs: 'Uredi racun', da: 'Rediger kvittering');
  String get receiptUpdated => _byLanguage(en: 'Receipt updated.', bs: 'Racun azuriran.', da: 'Kvittering opdateret.');
  String get changeItemCategory => _byLanguage(en: 'Change item category', bs: 'Promijeni kategoriju stavke', da: 'Aendr varekategori');
  String get itemName => _byLanguage(en: 'Item name', bs: 'Naziv stavke', da: 'Varenavn');
  String get saveChanges => _byLanguage(en: 'Save changes', bs: 'Sacuvaj izmjene', da: 'Gem aendringer');
  String itemUpdatedLabel(String itemName) => _byLanguage(en: '$itemName updated.', bs: '$itemName azuriran.', da: '$itemName opdateret.');
  String get noReceiptImageAvailable => _byLanguage(en: 'No receipt image available.', bs: 'Slika racuna nije dostupna.', da: 'Intet kvitteringsbillede tilgaengeligt.');
  String get unableToLoadImage => _byLanguage(en: 'Unable to load image.', bs: 'Nije moguce ucitati sliku.', da: 'Kan ikke indlaese billede.');
  String get scanImageUploadFailedTitle => _byLanguage(en: 'Image upload failed', bs: 'Otpremanje slike nije uspjelo', da: 'Billedupload mislykkedes');
  String get scanImageUploadFailedMessage => _byLanguage(en: 'Could not read selected image. Please try another image.', bs: 'Nije moguce procitati izabranu sliku. Pokusaj drugu sliku.', da: 'Kunne ikke laese det valgte billede. Prov et andet billede.');
  String get scanNoImageSelectedTitle => _byLanguage(en: 'No image selected', bs: 'Nijedna slika nije izabrana', da: 'Intet billede valgt');
  String get scanNoImageSelectedMessage => _byLanguage(en: 'Select image first, then tap scan.', bs: 'Prvo izaberi sliku, pa zatim dodirni skeniraj.', da: 'Vaelg forst et billede, og tryk derefter scan.');
  String get scanFinishedNotice => _byLanguage(en: 'Receipt scan finished.', bs: 'Skeniranje racuna zavrseno.', da: 'Kvitteringsscanning faerdig.');
  String get scanUnexpectedFailureTitle => _byLanguage(en: 'Unexpected scan failure', bs: 'Neocekivana greska pri skeniranju', da: 'Uventet scanningsfejl');
  String get scanUnexpectedFailureMessage => _byLanguage(en: 'Something went wrong during scan.', bs: 'Doslo je do greske tokom skeniranja.', da: 'Noget gik galt under scanning.');
  String get scanFailedNotice => _byLanguage(en: 'Receipt scan failed.', bs: 'Skeniranje racuna nije uspjelo.', da: 'Kvitteringsscanning mislykkedes.');
  String get scanSaveFailedTitle => _byLanguage(en: 'Save failed', bs: 'Cuvanje nije uspjelo', da: 'Gemming mislykkedes');
  String get scanSaveFailedMessage => _byLanguage(en: 'Could not save receipt. Try again.', bs: 'Nije moguce sacuvati racun. Pokusaj ponovo.', da: 'Kunne ikke gemme kvittering. Prov igen.');
  String get notReceiptTitle => _byLanguage(en: 'Not a receipt', bs: 'Nije racun', da: 'Ikke en kvittering');
  String notReceiptMessage(String reason) => _byLanguage(en: reason.isEmpty ? 'Selected image is not a receipt. Try a clear receipt photo.' : 'Selected image is not a receipt. $reason', bs: reason.isEmpty ? 'Izabrana slika nije racun. Pokusaj jasnu fotografiju racuna.' : 'Izabrana slika nije racun. $reason', da: reason.isEmpty ? 'Det valgte billede er ikke en kvittering. Prov et tydeligt kvitteringsfoto.' : 'Det valgte billede er ikke en kvittering. $reason');
  String get imageQualityIssueTitle => _byLanguage(en: 'Image quality issue', bs: 'Problem s kvalitetom slike', da: 'Problem med billedkvalitet');
  String imageQualityIssueMessage(String reason) => _byLanguage(en: reason.isEmpty ? 'Receipt image is not clear enough. Try a sharper photo.' : 'Receipt image is not clear enough. $reason', bs: reason.isEmpty ? 'Slika racuna nije dovoljno jasna. Pokusaj ostriju fotografiju.' : 'Slika racuna nije dovoljno jasna. $reason', da: reason.isEmpty ? 'Kvitteringsbilledet er ikke tydeligt nok. Prov et skarpere foto.' : 'Kvitteringsbilledet er ikke tydeligt nok. $reason');
  String get scanFailedTitle => _byLanguage(en: 'Scan failed', bs: 'Skeniranje nije uspjelo', da: 'Scanning mislykkedes');
  String get scanFailedMessage => _byLanguage(en: 'Could not parse receipt data.', bs: 'Nije moguce obraditi podatke racuna.', da: 'Kunne ikke parse kvitteringsdata.');
  String get cannotSaveReceiptTitle => _byLanguage(en: 'Cannot save receipt', bs: 'Nije moguce sacuvati racun', da: 'Kan ikke gemme kvittering');
  String get cannotSaveReceiptMessage => _byLanguage(en: 'Receipt fields invalid. Fix values before saving.', bs: 'Polja racuna nisu ispravna. Ispravi vrijednosti prije cuvanja.', da: 'Kvitteringsfelter er ugyldige. Ret vaerdierne for gemning.');
  String get invalidJsonResponseTitle => _byLanguage(en: 'Invalid JSON response', bs: 'Neispravan JSON odgovor', da: 'Ugyldigt JSON-svar');
  String get invalidJsonResponseMessage => _byLanguage(en: 'AI returned broken JSON. Please retry scan.', bs: 'AI je vratio neispravan JSON. Pokusaj ponovo skenirati.', da: 'AI returnerede ugyldig JSON. Prov at scanne igen.');
  String get aiResponseFailedTitle => _byLanguage(en: 'AI response failed', bs: 'AI odgovor nije uspio', da: 'AI-svar mislykkedes');
  String get aiResponseFailedMessage => _byLanguage(en: 'Could not get valid AI response for this image.', bs: 'Nije moguce dobiti ispravan AI odgovor za ovu sliku.', da: 'Kunne ikke hente et gyldigt AI-svar for dette billede.');

  String get currency => _byLanguage(
    en: 'Currency',
    bs: 'Valuta',
    da: 'Valuta',
  );
  String get currencyDescription => _byLanguage(
    en: 'Set the default currency for budgets and spending summaries.',
    bs: 'Postavi zadanu valutu za budzete i preglede potrosnje.',
    da: 'Indstil standardvalutaen for budgetter og forbrugsoversigter.',
  );
  String get currencyCustomHint => _byLanguage(
    en: 'Or type a custom currency code',
    bs: 'Ili unesi prilagodeni kod valute',
    da: 'Eller skriv en brugerdefineret valutakode',
  );
  String currencySavedLabel(String code) => _byLanguage(
    en: 'Currency set to $code.',
    bs: 'Valuta postavljena na $code.',
    da: 'Valuta sat til $code.',
  );

  String categoryLabel(String category) {
    switch (category.trim().toLowerCase()) {
      case 'groceries':
        return _byLanguage(en: 'Groceries', bs: 'Namirnice', da: 'Dagligvarer');
      case 'fuel':
        return _byLanguage(en: 'Fuel', bs: 'Gorivo', da: 'Braendstof');
      case 'household':
        return _byLanguage(en: 'Household', bs: 'Domacinstvo', da: 'Husholdning');
      case 'pets':
        return _byLanguage(en: 'Pets', bs: 'Ljubimci', da: 'Kaledyr');
      case 'clothing':
        return _byLanguage(en: 'Clothing', bs: 'Odjeca', da: 'Toj');
      case 'pharmacy':
        return _byLanguage(en: 'Pharmacy', bs: 'Apoteka', da: 'Apotek');
      case 'dental':
        return _byLanguage(en: 'Dental', bs: 'Dentalno', da: 'Tandlaege');
      case 'night out':
        return _byLanguage(en: 'Night Out', bs: 'Izlazak', da: 'Bytur');
      case 'cigarettes':
        return _byLanguage(en: 'Cigarettes', bs: 'Cigarete', da: 'Cigaretter');
      default:
        return _byLanguage(en: 'Misc', bs: 'Ostalo', da: 'Diverse');
    }
  }

  String _byLanguage({
    required String en,
    required String bs,
    required String da,
  }) {
    switch (_languageCode) {
      case 'bs':
        return bs;
      case 'da':
        return da;
      default:
        return en;
    }
  }

  String get _languageCode =>
      _localizedValues.containsKey(locale.languageCode)
          ? locale.languageCode
          : 'en';

  String _text(String key) {
    return _localizedValues[_languageCode]?[key] ??
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
