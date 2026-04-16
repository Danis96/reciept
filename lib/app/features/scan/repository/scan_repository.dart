import 'package:reciep/app/features/budgets/repository/monthly_budget_sync_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reciep/app/features/scan/repository/gemma_receipt_mapper.dart';
import 'package:reciep/app/features/scan/repository/gemma_receipt_response_validator.dart';
import 'package:reciep/app/features/scan/repository/gemma_receipt_scan_service.dart';
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

  Future<ReceiptModel> scanAndSaveReceipt({required String imagePath}) async {
    final Map<String, dynamic> aiPayload = await _gemmaService.scanReceiptImage(
      imagePath: imagePath,
    );

    final List<String> payloadErrors = GemmaReceiptResponseValidator.validate(
      aiPayload,
    );
    if (payloadErrors.isNotEmpty) {
      throw GemmaScanException(
        'Invalid structured AI response: ${payloadErrors.join('; ')}',
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
      throw StateError('Invalid parsed receipt: ${modelErrors.join('; ')}');
    }

    await _receiptDao.upsertReceiptWithItems(
      scanned.toReceiptCompanion(),
      scanned.toReceiptItemsCompanions(),
    );
    await _monthlyBudgetSyncRepository.syncCurrentMonth();

    return scanned;
  }
}
