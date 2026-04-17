import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';
part 'daos/app_settings_dao.dart';
part 'daos/category_budget_dao.dart';
part 'daos/receipt_dao.dart';

class Receipts extends Table {
  IntColumn get localId => integer().autoIncrement()();
  TextColumn get receiptId => text().unique()();

  TextColumn get country => text().withDefault(const Constant('BA'))();
  TextColumn get currency => text().withDefault(const Constant('BAM'))();

  TextColumn get merchantName => text().withDefault(const Constant(''))();
  TextColumn get merchantStoreName => text().nullable()();
  TextColumn get merchantAddress => text().nullable()();
  TextColumn get merchantCity => text().nullable()();
  TextColumn get merchantJib => text().nullable()();
  TextColumn get merchantPib => text().nullable()();

  TextColumn get receiptType => text().withDefault(const Constant('fiscal'))();
  TextColumn get receiptNumber => text().nullable()();
  DateTimeColumn get receiptDateTime => dateTime().nullable()();
  TextColumn get receiptDateText => text().nullable()();
  TextColumn get receiptTimeText => text().nullable()();

  RealColumn get subtotal => real().nullable()();
  RealColumn get discountTotal => real().nullable()();
  RealColumn get taxableAmount => real().nullable()();
  RealColumn get vatRate => real().nullable()();
  RealColumn get vatAmount => real().nullable()();
  RealColumn get totalAmount => real().withDefault(const Constant(0))();

  TextColumn get paymentMethod =>
      text().withDefault(const Constant('unknown'))();
  RealColumn get paymentPaid => real().nullable()();
  RealColumn get paymentChange => real().nullable()();

  TextColumn get fiscalIbfm => text().nullable()();
  BoolColumn get fiscalQrPresent =>
      boolean().withDefault(const Constant(false))();
  TextColumn get fiscalVerificationCode => text().nullable()();

  TextColumn get category =>
      text().withDefault(const Constant('miscellaneous'))();
  RealColumn get confidence => real().withDefault(const Constant(0))();

  TextColumn get rawText => text().nullable()();
  TextColumn get rawJson => text().nullable()();
  TextColumn get imagePath => text().nullable()();

  TextColumn get payloadJson => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class ReceiptItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get receiptLocalId =>
      integer().references(Receipts, #localId, onDelete: KeyAction.cascade)();

  IntColumn get position => integer().withDefault(const Constant(0))();
  TextColumn get name => text().withDefault(const Constant(''))();
  TextColumn get category =>
      text().withDefault(const Constant('miscellaneous'))();
  TextColumn get unit => text().nullable()();
  RealColumn get quantity => real().withDefault(const Constant(1))();
  RealColumn get unitPrice => real().nullable()();
  RealColumn get discountPercent => real().nullable()();
  RealColumn get discountAmount => real().nullable()();
  RealColumn get finalPrice => real().withDefault(const Constant(0))();
}

class CategoryBudgets extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get category => text().unique()();
  RealColumn get budgetAmount => real().withDefault(const Constant(0))();
  RealColumn get spentAmount => real().withDefault(const Constant(0))();
  TextColumn get currency => text().withDefault(const Constant('BAM'))();
  TextColumn get period => text().withDefault(const Constant('monthly'))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{key};
}

@DriftDatabase(
  tables: [Receipts, ReceiptItems, CategoryBudgets, AppSettings],
  daos: [ReceiptDao, CategoryBudgetDao, AppSettingsDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'receipt_local_db'));

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 3) {
        await customStatement('DROP TABLE IF EXISTS receipt_items');
        await customStatement('DROP TABLE IF EXISTS receipts');
        await customStatement('DROP TABLE IF EXISTS category_budgets');
        await customStatement('DROP TABLE IF EXISTS app_settings');
        await m.createAll();
        return;
      }
      if (from < 4) {
        await m.addColumn(receiptItems, receiptItems.category);
      }
    },
  );
}
