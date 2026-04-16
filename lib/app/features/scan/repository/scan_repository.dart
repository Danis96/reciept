import 'package:reciep/app/features/budgets/repository/monthly_budget_sync_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reciep/app/features/scan/repository/gemma_receipt_mapper.dart';
import 'package:reciep/app/features/scan/repository/gemma_receipt_response_validator.dart';
import 'package:reciep/app/features/scan/repository/gemma_receipt_scan_service.dart';
import 'package:reciep/app/features/scan/repository/scan_failure.dart';
import 'package:reciep/app/models/receipt/receipt_db_mapper.dart';
import 'package:reciep/app/models/receipt/receipt_model.dart';
import 'package:reciep/app/models/receipt/receipt_validator.dart';
import 'package:reciep/database/app_database.dart';

class ScanRepository {
  ScanRepository({
    required ReceiptDao receiptDao,
    required GemmaReceiptScanService gemmaService,
    required MonthlyBudgetSyncRepository monthlyBudgetSyncRepository,
    ImagePicker? imagePicker,
  }) : _receiptDao = receiptDao,
       _gemmaService = gemmaService,
       _monthlyBudgetSyncRepository = monthlyBudgetSyncRepository,
       _imagePicker = imagePicker ?? ImagePicker();

  final ReceiptDao _receiptDao;
  final GemmaReceiptScanService _gemmaService;
  final MonthlyBudgetSyncRepository _monthlyBudgetSyncRepository;
  final ImagePicker _imagePicker;

  Future<String?> pickImageFromGallery() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );
    return image?.path;
  }

  Future<String?> pickImageFromCamera() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 90,
    );
    return image?.path;
  }

  Future<List<ReceiptModel>> getRecentReceipts({int limit = 2}) async {
    final List<ReceiptWithItems> rows = await _receiptDao
        .getRecentReceiptsWithItems(limit);
    return rows
        .map((ReceiptWithItems row) => row.toReceiptModel())
        .toList(growable: false);
  }

  Future<ReceiptModel> scanReceipt({required String imagePath}) async {
    try {
      final Map<String, dynamic> aiPayload = await _gemmaService
          .scanReceiptImage(imagePath: imagePath);

      final List<String> payloadErrors = GemmaReceiptResponseValidator.validate(
        aiPayload,
      );
      if (payloadErrors.isNotEmpty) {
        throw ScanException(
          ScanFailure(
            type: ScanFailureType.parseFailure,
            title: 'Incomplete receipt data',
            message: 'AI result missing required fields. Try clearer image.',
            technicalDetails: payloadErrors.join('; '),
          ),
        );
      }

      final ReceiptModel scanned = GemmaReceiptMapper.toReceiptModel(
        payload: aiPayload,
        imagePath: imagePath,
      );

      final List<String> modelErrors = ReceiptSaveValidator.validateModel(
        scanned,
      );
      if (modelErrors.isNotEmpty) {
        throw ScanException(
          ScanFailure(
            type: ScanFailureType.parseFailure,
            title: 'Parse failed',
            message: 'Parsed receipt invalid. Edit fields and retry.',
            technicalDetails: modelErrors.join('; '),
          ),
        );
      }

      return scanned;
    } on ScanException {
      rethrow;
    } on GemmaScanException catch (error) {
      final ScanFailure failure = _failureFromGemmaError(error.message);
      throw ScanException(failure);
    } catch (error) {
      throw ScanException(
        ScanFailure(
          type: ScanFailureType.parseFailure,
          title: 'Scan failed',
          message: 'Could not parse receipt data.',
          technicalDetails: error.toString(),
        ),
      );
    }
  }

  Future<void> saveReceipt(ReceiptModel receipt) async {
    final List<String> modelErrors = ReceiptSaveValidator.validateModel(
      receipt,
    );
    if (modelErrors.isNotEmpty) {
      throw ScanException(
        ScanFailure(
          type: ScanFailureType.parseFailure,
          title: 'Cannot save receipt',
          message: 'Receipt fields invalid. Fix values before saving.',
          technicalDetails: modelErrors.join('; '),
        ),
      );
    }
    await _receiptDao.upsertReceiptWithItems(
      receipt.toReceiptCompanion(),
      receipt.toReceiptItemsCompanions(),
    );
    await _monthlyBudgetSyncRepository.syncCurrentMonth();
  }

  ScanFailure _failureFromGemmaError(String message) {
    final String lowered = message.toLowerCase();
    if (lowered.contains('invalid structured json payload') ||
        lowered.contains('invalid json envelope') ||
        lowered.contains('not a json object')) {
      return ScanFailure(
        type: ScanFailureType.invalidJson,
        title: 'Invalid JSON response',
        message: 'AI returned broken JSON. Please retry scan.',
        technicalDetails: message,
      );
    }
    return ScanFailure(
      type: ScanFailureType.aiResponseFailed,
      title: 'AI response failed',
      message: 'Could not get valid AI response for this image.',
      technicalDetails: message,
    );
  }
}
