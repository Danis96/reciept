import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:refyn/app/features/budgets/repository/category_budget_repository.dart';
import 'package:refyn/app/models/category_budget_model.dart';
import 'package:refyn/app/models/receipt/receipt_db_mapper.dart';
import 'package:refyn/app/models/receipt/receipt_model.dart';
import 'package:refyn/database/app_database.dart';

class LocalBackupService {
  LocalBackupService({
    required AppDatabase database,
    required ReceiptDao receiptDao,
    required AppSettingsDao appSettingsDao,
    required CategoryBudgetRepository categoryBudgetRepository,
  }) : _database = database,
       _receiptDao = receiptDao,
       _appSettingsDao = appSettingsDao,
       _categoryBudgetRepository = categoryBudgetRepository;

  static const int _backupVersion = 1;
  static const String _manifestPath = 'backup.json';
  static const String _restoredImagesDirectoryName = 'receipt_images';

  final AppDatabase _database;
  final ReceiptDao _receiptDao;
  final AppSettingsDao _appSettingsDao;
  final CategoryBudgetRepository _categoryBudgetRepository;

  Future<LocalBackupExportResult> exportBackup() async {
    final Archive archive = Archive();
    final List<ReceiptModel> receipts = await _getReceipts();
    final List<CategoryBudgetModel> budgets = await _categoryBudgetRepository
        .getBudgets();
    final List<AppSetting> settings = await _appSettingsDao.getAllSettings();
    final List<_BackupFileRecord> files = <_BackupFileRecord>[];

    for (final ReceiptModel receipt in receipts) {
      await _appendFileToArchive(
        archive: archive,
        sourcePath: receipt.imagePath,
        archiveFolder: 'files/receipt_images',
        records: files,
      );
    }

    final Map<String, dynamic> manifest = <String, dynamic>{
      'version': _backupVersion,
      'createdAt': DateTime.now().toUtc().toIso8601String(),
      'settings': <String, String>{
        for (final AppSetting setting in settings) setting.key: setting.value,
      },
      'budgets': budgets.map(_budgetToJson).toList(growable: false),
      'receipts': receipts
          .map((ReceiptModel receipt) => receipt.toJson())
          .toList(growable: false),
      'files': files.map((record) => record.toJson()).toList(growable: false),
    };

    archive.addFile(ArchiveFile.string(_manifestPath, jsonEncode(manifest)));

    final Directory temporaryDirectory = await Directory.systemTemp.createTemp(
      'refyn_backup_',
    );
    final String safeTimestamp = DateTime.now()
        .toIso8601String()
        .replaceAll(':', '-')
        .replaceAll('.', '-');
    final String zipPath = p.join(
      temporaryDirectory.path,
      'refyn-backup-$safeTimestamp.zip',
    );

    final List<int> encoded = ZipEncoder().encode(archive);
    final File file = File(zipPath);
    await file.writeAsBytes(encoded, flush: true);

    return LocalBackupExportResult(
      archivePath: file.path,
      receiptCount: receipts.length,
      attachmentCount: files.length,
    );
  }

  Future<LocalBackupImportResult> importBackup(String archivePath) async {
    final File archiveFile = File(archivePath);
    if (!await archiveFile.exists()) {
      throw StateError('Selected backup file no longer exists.');
    }

    final List<int> bytes = await archiveFile.readAsBytes();
    final Archive archive = ZipDecoder().decodeBytes(bytes);
    final ArchiveFile? manifestEntry = archive.findFile(_manifestPath);
    if (manifestEntry == null) {
      throw StateError('Backup file is missing backup.json.');
    }

    final String manifestRaw = utf8.decode(manifestEntry.content as List<int>);
    final Map<String, dynamic> manifest =
        jsonDecode(manifestRaw) as Map<String, dynamic>;
    final Object? version = manifest['version'];
    if (version is! int || version != _backupVersion) {
      throw StateError('Backup version is not supported.');
    }

    final List<Map<String, dynamic>> receiptJson =
        (manifest['receipts'] as List<dynamic>? ?? const <dynamic>[])
            .whereType<Map<String, dynamic>>()
            .toList(growable: false);
    final List<Map<String, dynamic>> budgetJson =
        (manifest['budgets'] as List<dynamic>? ?? const <dynamic>[])
            .whereType<Map<String, dynamic>>()
            .toList(growable: false);
    final List<_BackupFileRecord> fileRecords =
        (manifest['files'] as List<dynamic>? ?? const <dynamic>[])
            .whereType<Map<String, dynamic>>()
            .map(_BackupFileRecord.fromJson)
            .toList(growable: false);
    final Map<String, String> settings = _readSettingsMap(manifest['settings']);

    await clearAllLocalData();

    final Map<String, String> restoredPaths = await _restoreArchivedFiles(
      archive,
      fileRecords,
    );
    final List<ReceiptModel> receipts = receiptJson
        .map(
          (Map<String, dynamic> json) =>
              _restoreReceiptFromJson(json, restoredPaths),
        )
        .toList(growable: false);

    for (final ReceiptModel receipt in receipts) {
      await _receiptDao.upsertReceiptWithItems(
        receipt.toReceiptCompanion(),
        receipt.toReceiptItemsCompanions(),
      );
    }

    for (final Map<String, dynamic> json in budgetJson) {
      await _categoryBudgetRepository.upsertBudget(
        category: _readRequiredString(json, 'category'),
        budgetAmount: _readRequiredDouble(json, 'budget_amount'),
        spentAmount: _readRequiredDouble(json, 'spent_amount'),
        currency: _readRequiredString(json, 'currency'),
        period: _readRequiredString(json, 'period'),
      );
    }

    await _appSettingsDao.replaceAllSettings(settings);

    return LocalBackupImportResult(
      receiptCount: receipts.length,
      attachmentCount: restoredPaths.length,
    );
  }

  Future<void> clearAllLocalData() async {
    await _database.transaction(() async {
      await _database.delete(_database.receiptItems).go();
      await _database.delete(_database.receipts).go();
      await _database.delete(_database.categoryBudgets).go();
      await _database.delete(_database.appSettings).go();
    });

    final Directory appDirectory = await getApplicationDocumentsDirectory();
    final Directory restoredImagesDirectory = Directory(
      p.join(appDirectory.path, _restoredImagesDirectoryName),
    );
    if (await restoredImagesDirectory.exists()) {
      await restoredImagesDirectory.delete(recursive: true);
    }
  }

  Future<List<ReceiptModel>> _getReceipts() async {
    final List<ReceiptWithItems> rows = await _receiptDao
        .getReceiptsWithItems();
    return rows
        .map((ReceiptWithItems row) => row.toReceiptModel())
        .toList(growable: false);
  }

  Future<void> _appendFileToArchive({
    required Archive archive,
    required String? sourcePath,
    required String archiveFolder,
    required List<_BackupFileRecord> records,
  }) async {
    final String? normalizedPath = sourcePath?.trim();
    if (normalizedPath == null || normalizedPath.isEmpty) {
      return;
    }

    final File file = File(normalizedPath);
    if (!await file.exists()) {
      return;
    }

    final List<int> bytes = await file.readAsBytes();
    final String archivePath = p.join(
      archiveFolder,
      '${records.length}_${p.basename(normalizedPath)}',
    );

    archive.addFile(
      ArchiveFile(archivePath, bytes.length, bytes)
        ..mode = file.statSync().mode,
    );

    records.add(
      _BackupFileRecord(originalPath: normalizedPath, archivePath: archivePath),
    );
  }

  Future<Map<String, String>> _restoreArchivedFiles(
    Archive archive,
    List<_BackupFileRecord> records,
  ) async {
    if (records.isEmpty) {
      return const <String, String>{};
    }

    final Directory appDirectory = await getApplicationDocumentsDirectory();
    final Directory targetDirectory = Directory(
      p.join(appDirectory.path, _restoredImagesDirectoryName),
    );
    if (!await targetDirectory.exists()) {
      await targetDirectory.create(recursive: true);
    }

    final Map<String, String> restoredPaths = <String, String>{};
    for (final _BackupFileRecord record in records) {
      final ArchiveFile? archiveEntry = archive.findFile(record.archivePath);
      if (archiveEntry == null) {
        continue;
      }

      final String targetPath = p.join(
        targetDirectory.path,
        p.basename(record.archivePath),
      );
      final File targetFile = File(targetPath);
      await targetFile.writeAsBytes(
        archiveEntry.content as List<int>,
        flush: true,
      );
      restoredPaths[record.originalPath] = targetFile.path;
    }

    return restoredPaths;
  }

  ReceiptModel _restoreReceiptFromJson(
    Map<String, dynamic> json,
    Map<String, String> restoredPaths,
  ) {
    final Map<String, dynamic> normalized = Map<String, dynamic>.from(json);
    final String? originalPath = _readNullableString(normalized['image_path']);
    if (originalPath != null && restoredPaths.containsKey(originalPath)) {
      normalized['image_path'] = restoredPaths[originalPath];
    }
    return ReceiptModel.fromJson(normalized);
  }

  Map<String, String> _readSettingsMap(Object? value) {
    final Map<dynamic, dynamic> raw = value is Map<dynamic, dynamic>
        ? value
        : const <dynamic, dynamic>{};
    return raw.map(
      (dynamic key, dynamic mapValue) =>
          MapEntry(key.toString(), mapValue.toString()),
    );
  }

  Map<String, dynamic> _budgetToJson(CategoryBudgetModel budget) {
    return <String, dynamic>{
      'category': budget.category,
      'budget_amount': budget.budgetAmount,
      'spent_amount': budget.spentAmount,
      'currency': budget.currency,
      'period': budget.period,
      'updated_at': budget.updatedAt.toIso8601String(),
    };
  }

  String _readRequiredString(Map<String, dynamic> json, String key) {
    final Object? value = json[key];
    if (value is! String || value.trim().isEmpty) {
      throw StateError('Backup is missing required field "$key".');
    }
    return value.trim();
  }

  double _readRequiredDouble(Map<String, dynamic> json, String key) {
    final Object? value = json[key];
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      final double? parsed = double.tryParse(value.trim());
      if (parsed != null) {
        return parsed;
      }
    }
    throw StateError('Backup is missing required number "$key".');
  }

  String? _readNullableString(Object? value) {
    if (value is! String) {
      return null;
    }
    final String normalized = value.trim();
    return normalized.isEmpty ? null : normalized;
  }
}

class LocalBackupExportResult {
  const LocalBackupExportResult({
    required this.archivePath,
    required this.receiptCount,
    required this.attachmentCount,
  });

  final String archivePath;
  final int receiptCount;
  final int attachmentCount;
}

class LocalBackupImportResult {
  const LocalBackupImportResult({
    required this.receiptCount,
    required this.attachmentCount,
  });

  final int receiptCount;
  final int attachmentCount;
}

class _BackupFileRecord {
  const _BackupFileRecord({
    required this.originalPath,
    required this.archivePath,
  });

  factory _BackupFileRecord.fromJson(Map<String, dynamic> json) {
    final Object? originalPath = json['original_path'];
    final Object? archivePath = json['archive_path'];
    if (originalPath is! String ||
        originalPath.trim().isEmpty ||
        archivePath is! String ||
        archivePath.trim().isEmpty) {
      throw StateError('Backup contains an invalid file entry.');
    }
    return _BackupFileRecord(
      originalPath: originalPath.trim(),
      archivePath: archivePath.trim(),
    );
  }

  final String originalPath;
  final String archivePath;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'original_path': originalPath,
      'archive_path': archivePath,
    };
  }
}
