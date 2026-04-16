part of '../app_database.dart';

@DriftAccessor(tables: [AppSettings])
class AppSettingsDao extends DatabaseAccessor<AppDatabase>
    with _$AppSettingsDaoMixin {
  AppSettingsDao(super.attachedDatabase);

  Future<void> upsertSetting({required String key, required String value}) {
    return into(appSettings).insertOnConflictUpdate(
      AppSettingsCompanion(
        key: Value(key),
        value: Value(value),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<String?> getSetting(String key) async {
    final AppSetting? setting = await (select(
      appSettings,
    )..where((tbl) => tbl.key.equals(key))).getSingleOrNull();
    return setting?.value;
  }

  Future<int> deleteSetting(String key) {
    return (delete(appSettings)..where((tbl) => tbl.key.equals(key))).go();
  }
}
