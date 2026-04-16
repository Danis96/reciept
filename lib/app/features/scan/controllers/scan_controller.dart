import 'package:flutter/foundation.dart';
import 'package:reciep/app/features/scan/controllers/scan_view_state.dart';
import 'package:reciep/app/features/scan/repository/scan_repository.dart';
import 'package:reciep/app/models/receipt/receipt_model.dart';

class ScanController extends ChangeNotifier {
  ScanController({required ScanRepository repository})
    : _repository = repository;

  final ScanRepository _repository;

  ScanViewState _state = ScanViewState.idle;
  String? _selectedImagePath;
  String? _errorMessage;
  ReceiptModel? _lastScannedReceipt;
  int _loadingStep = 0;
  bool _busy = false;
  List<ReceiptModel> _recentReceipts = const <ReceiptModel>[];

  ScanViewState get state => _state;
  String? get selectedImagePath => _selectedImagePath;
  String? get errorMessage => _errorMessage;
  ReceiptModel? get lastScannedReceipt => _lastScannedReceipt;
  int get loadingStep => _loadingStep;
  bool get busy => _busy;
  List<ReceiptModel> get recentReceipts => _recentReceipts;

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
    _errorMessage = null;
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
    } catch (_) {
      _state = ScanViewState.error;
      _errorMessage = 'Could not access image source.';
    }

    _busy = false;
    notifyListeners();
  }

  void clearSelection() {
    _selectedImagePath = null;
    _errorMessage = null;
    _loadingStep = 0;
    _lastScannedReceipt = null;
    _state = ScanViewState.idle;
    notifyListeners();
  }

  Future<void> scanSelectedImage() async {
    if (_busy) {
      return;
    }

    final String? path = _selectedImagePath;
    if (path == null || path.trim().isEmpty) {
      _state = ScanViewState.error;
      _errorMessage = 'Select image first.';
      notifyListeners();
      return;
    }

    _busy = true;
    _state = ScanViewState.loading;
    _errorMessage = null;
    _loadingStep = 0;
    notifyListeners();

    try {
      await _advanceLoadingSteps();
      final ReceiptModel scanned = await _repository.scanAndSaveReceipt(
        imagePath: path,
      );
      _lastScannedReceipt = scanned;
      _state = ScanViewState.success;
      await _loadRecentReceipts();
    } catch (error) {
      _state = ScanViewState.error;
      _errorMessage = error.toString().replaceFirst('Exception: ', '');
    }

    _busy = false;
    notifyListeners();
  }

  Future<void> showReadyToScan() async {
    _selectedImagePath = null;
    _lastScannedReceipt = null;
    _errorMessage = null;
    _loadingStep = 0;
    _state = ScanViewState.idle;
    notifyListeners();
  }

  Future<void> _loadRecentReceipts() async {
    _recentReceipts = await _repository.getRecentReceipts(limit: 2);
    notifyListeners();
  }

  Future<void> _advanceLoadingSteps() async {
    _loadingStep = 1;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 350));

    _loadingStep = 2;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 350));

    _loadingStep = 3;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 350));

    _loadingStep = 4;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 350));

    _loadingStep = 5;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 220));
  }
}
