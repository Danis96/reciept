part of '../app_database.dart';

class ReceiptWithItems {
  const ReceiptWithItems({required this.receipt, required this.items});

  final Receipt receipt;
  final List<ReceiptItem> items;
}

@DriftAccessor(tables: [Receipts, ReceiptItems])
class ReceiptDao extends DatabaseAccessor<AppDatabase> with _$ReceiptDaoMixin {
  ReceiptDao(super.attachedDatabase);

  Future<int> upsertReceiptWithItems(
    ReceiptsCompanion receipt,
    List<ReceiptItemsCompanion> items,
  ) {
    return transaction(() async {
      final String receiptId = receipt.receiptId.value;
      final Receipt? existing = await (select(
        receipts,
      )..where((tbl) => tbl.receiptId.equals(receiptId))).getSingleOrNull();

      late final int localReceiptId;
      if (existing == null) {
        final Receipt inserted = await into(receipts).insertReturning(receipt);
        localReceiptId = inserted.localId;
      } else {
        localReceiptId = existing.localId;
        await (update(
          receipts,
        )..where((tbl) => tbl.localId.equals(localReceiptId))).write(receipt);
        await (delete(
          receiptItems,
        )..where((tbl) => tbl.receiptLocalId.equals(localReceiptId))).go();
      }

      if (items.isNotEmpty) {
        await batch((Batch batch) {
          batch.insertAll(
            receiptItems,
            items
                .map(
                  (ReceiptItemsCompanion item) =>
                      item.copyWith(receiptLocalId: Value(localReceiptId)),
                )
                .toList(),
          );
        });
      }

      return localReceiptId;
    });
  }

  Future<List<ReceiptWithItems>> getReceiptsWithItems() async {
    final List<Receipt> receiptRows = await (select(
      receipts,
    )..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)])).get();
    return _attachItems(receiptRows);
  }

  Future<List<ReceiptWithItems>> getRecentReceiptsWithItems(int limit) async {
    final List<Receipt> receiptRows =
        await (select(receipts)
              ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)])
              ..limit(limit))
            .get();
    return _attachItems(receiptRows);
  }

  Future<ReceiptWithItems?> getReceiptWithItemsByReceiptId(
    String receiptId,
  ) async {
    final Receipt? receipt = await (select(
      receipts,
    )..where((tbl) => tbl.receiptId.equals(receiptId))).getSingleOrNull();
    if (receipt == null) {
      return null;
    }
    final List<ReceiptWithItems> rows = await _attachItems(<Receipt>[receipt]);
    if (rows.isEmpty) {
      return null;
    }
    return rows.first;
  }

  Future<List<ReceiptWithItems>> _attachItems(List<Receipt> receiptRows) async {
    if (receiptRows.isEmpty) {
      return const <ReceiptWithItems>[];
    }

    final List<int> receiptIds = receiptRows
        .map((Receipt row) => row.localId)
        .toList();

    final List<ReceiptItem> itemRows =
        await (select(receiptItems)
              ..where((tbl) => tbl.receiptLocalId.isIn(receiptIds))
              ..orderBy([(tbl) => OrderingTerm.asc(tbl.position)]))
            .get();

    final Map<int, List<ReceiptItem>> groupedItems = <int, List<ReceiptItem>>{};

    for (final ReceiptItem item in itemRows) {
      groupedItems
          .putIfAbsent(item.receiptLocalId, () => <ReceiptItem>[])
          .add(item);
    }

    return receiptRows
        .map(
          (Receipt receipt) => ReceiptWithItems(
            receipt: receipt,
            items: groupedItems[receipt.localId] ?? const <ReceiptItem>[],
          ),
        )
        .toList();
  }

  Future<int> getReceiptCount() async {
    final QueryRow row = await customSelect(
      'SELECT COUNT(*) AS count FROM receipts',
    ).getSingle();
    return row.read<int>('count');
  }

  Future<double> getTotalSpentBetween({
    required DateTime fromInclusive,
    required DateTime toExclusive,
  }) async {
    final QueryRow row = await customSelect(
      '''
      SELECT COALESCE(SUM(total_amount), 0) AS total
      FROM receipts
      WHERE created_at >= ? AND created_at < ?
      ''',
      variables: <Variable<Object>>[
        Variable<DateTime>(fromInclusive),
        Variable<DateTime>(toExclusive),
      ],
    ).getSingle();

    final dynamic totalRaw = row.data['total'];
    if (totalRaw is int) {
      return totalRaw.toDouble();
    }
    if (totalRaw is double) {
      return totalRaw;
    }
    return 0;
  }

  Future<int> getReceiptCountBetween({
    required DateTime fromInclusive,
    required DateTime toExclusive,
  }) async {
    final QueryRow row = await customSelect(
      '''
      SELECT COUNT(*) AS count
      FROM receipts
      WHERE created_at >= ? AND created_at < ?
      ''',
      variables: <Variable<Object>>[
        Variable<DateTime>(fromInclusive),
        Variable<DateTime>(toExclusive),
      ],
    ).getSingle();

    return row.read<int>('count');
  }

  Future<Map<String, double>> getCategorySpendBetween({
    required DateTime fromInclusive,
    required DateTime toExclusive,
  }) async {
    final List<QueryRow> rows = await customSelect(
      '''
      SELECT i.category AS category, COALESCE(SUM(i.final_price), 0) AS spent
      FROM receipt_items i
      INNER JOIN receipts r ON r.local_id = i.receipt_local_id
      WHERE r.created_at >= ? AND r.created_at < ?
      GROUP BY i.category
      ''',
      variables: <Variable<Object>>[
        Variable<DateTime>(fromInclusive),
        Variable<DateTime>(toExclusive),
      ],
    ).get();

    final Map<String, double> result = <String, double>{};
    for (final QueryRow row in rows) {
      final String category = row.read<String>('category');
      final dynamic spentRaw = row.data['spent'];
      if (spentRaw is int) {
        result[category] = spentRaw.toDouble();
      } else if (spentRaw is double) {
        result[category] = spentRaw;
      } else {
        result[category] = 0;
      }
    }
    return result;
  }

  Future<int> deleteReceiptByReceiptId(String receiptId) {
    return (delete(
      receipts,
    )..where((tbl) => tbl.receiptId.equals(receiptId))).go();
  }
}
