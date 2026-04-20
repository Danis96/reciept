import 'package:flutter/widgets.dart';
import 'package:reciep/app/features/scan/controllers/scan_view_state.dart';
import 'package:reciep/app/features/scan/repository/scan_failure.dart';
import 'package:reciep/app/features/scan/repository/scan_repository.dart';
import 'package:reciep/app/models/receipt/merchant_model.dart';
import 'package:reciep/app/models/receipt/payment_info_model.dart';
import 'package:reciep/app/models/receipt/receipt_model.dart';
import 'package:reciep/app/models/receipt/receipt_totals_model.dart';

class ScanForegroundNotice {
  const ScanForegroundNotice({required this.message, required this.isError});

  final String message;
  final bool isError;
}

class ScanController extends ChangeNotifier with WidgetsBindingObserver {
  ScanController({required ScanRepository repository})
    : _repository = repository {
    WidgetsBinding.instance.addObserver(this);
  }

  final ScanRepository _repository;

  ScanViewState _state = ScanViewState.idle;
  String? _selectedImagePath;
  ScanFailure? _failure;
  ReceiptModel? _lastScannedReceipt;
  ReceiptModel? _pendingReceiptDraft;
  int _loadingStep = 0;
  bool _busy = false;
  bool _savingDraft = false;
  List<ReceiptModel> _recentReceipts = const <ReceiptModel>[];
  AppLifecycleState _appLifecycleState = AppLifecycleState.resumed;
  ScanForegroundNotice? _pendingForegroundNotice;
  int _activeScanRequestId = 0;

  static const double _lowConfidenceThreshold = 0.65;

  ScanViewState get state => _state;
  String? get selectedImagePath => _selectedImagePath;
  ScanFailure? get failure => _failure;
  String? get errorMessage => _failure?.message;
  ReceiptModel? get lastScannedReceipt => _lastScannedReceipt;
  ReceiptModel? get pendingReceiptDraft => _pendingReceiptDraft;
  bool get hasPendingReceiptDraft => _pendingReceiptDraft != null;
  bool get isLowConfidence =>
      (_pendingReceiptDraft ?? _lastScannedReceipt)?.confidence != null &&
      ((_pendingReceiptDraft ?? _lastScannedReceipt)!.confidence <
          _lowConfidenceThreshold);
  int get loadingStep => _loadingStep;
  bool get busy => _busy;
  bool get savingDraft => _savingDraft;
  List<ReceiptModel> get recentReceipts => _recentReceipts;

  ScanForegroundNotice? consumeForegroundNotice() {
    final ScanForegroundNotice? notice = _pendingForegroundNotice;
    if (notice != null) {
      _pendingForegroundNotice = null;
    }
    return notice;
  }

  /// Consumes the failure event, returning the failure and clearing it.
  /// This ensures a failure is only handled once by the UI.
  ScanFailure? consumeFailure() {
    final ScanFailure? consumedFailure = _failure;
    if (consumedFailure != null) {
      _failure = null;
    }
    return consumedFailure;
  }

  Future<void> initialize() async {
    await _loadRecentReceipts();
  }

  Future<void> pickFromGallery() async {
    await _pickImage(_repository.pickImageFromGallery);
  }

  Future<void> pickFromCamera() async {
    await _pickImage(_repository.pickImageFromCamera);
  }

  Future<void> _pickImage(Future<String?> Function() picker) async {
    if (_busy) {
      return;
    }

    _busy = true;
    _clearFailure();
    notifyListeners();

    try {
      final String? path = await picker();
      if (path == null || path.trim().isEmpty) {
        _busy = false;
        notifyListeners();
        return;
      }

      _selectedImagePath = path;
      _state = ScanViewState.imageSelected;
    } catch (error) {
      _setFailure(
        ScanFailure(
          type: ScanFailureType.imageUploadFailed,
          title: 'Image upload failed',
          message: 'Could not read selected image. Please try another image.',
          technicalDetails: error.toString(),
        ),
      );
    }

    _busy = false;
    notifyListeners();
  }

  void clearSelection() {
    _activeScanRequestId++;
    _selectedImagePath = null;
    _clearFailure();
    _loadingStep = 0;
    _lastScannedReceipt = null;
    _pendingReceiptDraft = null;
    _state = ScanViewState.idle;
    notifyListeners();
  }

  Future<void> scanSelectedImage() async {
    if (_busy) {
      return;
    }

    final String? path = _selectedImagePath;
    if (path == null || path.trim().isEmpty) {
      _setFailure(
        const ScanFailure(
          type: ScanFailureType.imageUploadFailed,
          title: 'No image selected',
          message: 'Select image first, then tap scan.',
        ),
      );
      notifyListeners();
      return;
    }

    _busy = true;
    final int requestId = ++_activeScanRequestId;
    _state = ScanViewState.loading;
    _clearFailure();
    _loadingStep = 0;
    _lastScannedReceipt = null;
    _pendingReceiptDraft = null;
    notifyListeners();

    try {
      _advanceLoadingSteps();
      final ReceiptModel scanned = await _repository.scanReceipt(
        imagePath: path,
      );
      if (requestId != _activeScanRequestId) {
        return;
      }
      _pendingReceiptDraft = scanned;
      _lastScannedReceipt = scanned;
      _state = ScanViewState.success;
      _queueForegroundNoticeIfBackgrounded(
        const ScanForegroundNotice(
          message: 'Receipt scan finished.',
          isError: false,
        ),
      );
    } on ScanException catch (error) {
      if (requestId != _activeScanRequestId) {
        return;
      }
      _setFailure(error.failure);
      _queueForegroundNoticeIfBackgrounded(
        ScanForegroundNotice(message: error.failure.message, isError: true),
      );
    } catch (error) {
      if (requestId != _activeScanRequestId) {
        return;
      }
      _setFailure(
        ScanFailure(
          type: ScanFailureType.parseFailure,
          title: 'Unexpected scan failure',
          message: 'Something went wrong during scan.',
          technicalDetails: error.toString(),
        ),
      );
      _queueForegroundNoticeIfBackgrounded(
        const ScanForegroundNotice(
          message: 'Receipt scan failed.',
          isError: true,
        ),
      );
    }

    if (requestId != _activeScanRequestId) {
      return;
    }
    _busy = false;
    notifyListeners();
  }

  Future<void> saveDraftReceipt() async {
    if (_busy || _savingDraft || _pendingReceiptDraft == null) {
      return;
    }
    _savingDraft = true;
    _clearFailure();
    notifyListeners();
    try {
      await _repository.saveReceipt(_pendingReceiptDraft!);
      _pendingReceiptDraft = null;
      await _loadRecentReceipts();
    } on ScanException catch (error) {
      _setFailure(error.failure);
    } catch (error) {
      _setFailure(
        ScanFailure(
          type: ScanFailureType.parseFailure,
          title: 'Save failed',
          message: 'Could not save receipt. Try again.',
          technicalDetails: error.toString(),
        ),
      );
    }
    _savingDraft = false;
    notifyListeners();
  }

  void updateDraftReceipt({
    required String merchantName,
    required String paymentMethod,
    required double total,
  }) {
    final ReceiptModel? draft = _pendingReceiptDraft;
    if (draft == null) {
      return;
    }
    _pendingReceiptDraft = ReceiptModel(
      id: draft.id,
      country: draft.country,
      currency: draft.currency,
      merchant: MerchantModel(
        name: merchantName,
        storeName: draft.merchant.storeName,
        address: draft.merchant.address,
        city: draft.merchant.city,
        jib: draft.merchant.jib,
        pib: draft.merchant.pib,
      ),
      receiptInfo: draft.receiptInfo,
      items: draft.items,
      totals: ReceiptTotalsModel(
        total: total,
        subtotal: draft.totals.subtotal,
        discountTotal: draft.totals.discountTotal,
        taxableAmount: draft.totals.taxableAmount,
        vatRate: draft.totals.vatRate,
        vatAmount: draft.totals.vatAmount,
      ),
      payment: PaymentInfoModel(
        method: paymentMethod,
        paid: draft.payment.paid,
        change: draft.payment.change,
      ),
      category: draft.category,
      confidence: draft.confidence,
      createdAt: draft.createdAt,
      fiscal: draft.fiscal,
      rawText: draft.rawText,
      rawJson: draft.rawJson,
      imagePath: draft.imagePath,
    );
    _lastScannedReceipt = _pendingReceiptDraft;
    notifyListeners();
  }

  Future<void> showReadyToScan() async {
    _activeScanRequestId++;
    _selectedImagePath = null;
    _lastScannedReceipt = null;
    _pendingReceiptDraft = null;
    _clearFailure();
    _loadingStep = 0;
    _state = ScanViewState.idle;
    notifyListeners();
  }

  Future<void> _loadRecentReceipts() async {
    _recentReceipts = await _repository.getRecentReceipts(limit: 2);
    notifyListeners();
  }

  Future<void> _advanceLoadingSteps() async {
    const List<int> delays = <int>[550, 550, 550, 550, 520];
    final int requestId = _activeScanRequestId;
    for (int i = 0; i < delays.length; i++) {
      if (requestId != _activeScanRequestId ||
          _state != ScanViewState.loading) {
        return;
      }
      _loadingStep = i + 1;
      notifyListeners();
      await Future<void>.delayed(Duration(milliseconds: delays[i]));
    }
  }

  void _setFailure(ScanFailure failure) {
    _failure = failure;
    _state = ScanViewState.error;
  }

  void _clearFailure() {
    _failure = null;
  }

  void _queueForegroundNoticeIfBackgrounded(ScanForegroundNotice notice) {
    if (_appLifecycleState == AppLifecycleState.resumed) {
      return;
    }
    _pendingForegroundNotice = notice;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _appLifecycleState = state;
    if (state == AppLifecycleState.resumed &&
        _pendingForegroundNotice != null) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
