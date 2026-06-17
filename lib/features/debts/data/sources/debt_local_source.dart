import 'dart:convert';
import 'package:drift/drift.dart';
import '../../../../core/db/app_database.dart';
import '../models/debt_model.dart';

/// Qarzlar uchun local data source (Drift)
class DebtLocalSource {
  final AppDatabase _db;

  DebtLocalSource({required AppDatabase db}) : _db = db;

  /// Local DB dan qarzlar ro'yxatini olish
  Future<List<DebtModel>> getDebts() async {
    final rows = await _db.select(_db.localDebts).get();
    return rows.map((row) {
      final json = jsonDecode(row.rawJson) as Map<String, dynamic>;
      return DebtModel.fromJson(json);
    }).toList();
  }

  /// Local DB ga qarz saqlash / yangilash
  Future<void> upsertDebt(DebtModel model) async {
    await _db
        .into(_db.localDebts)
        .insertOnConflictUpdate(
          LocalDebtsCompanion(
            id: Value(model.id),
            debtNumber: Value(model.debtNumber),
            customerId: Value(model.customerId),
            totalAmount: Value(model.totalAmount.toDouble()),
            paidAmount: Value(model.paidAmount.toDouble()),
            status: Value(model.status),
            dueDate: Value(model.dueDate),
            rawJson: Value(jsonEncode(model.toJson())),
            pendingSync: const Value(false),
            cachedAt: Value(DateTime.now()),
          ),
        );
  }

  /// Ko'p qarzni saqlash (bulk cache)
  Future<void> upsertDebts(List<DebtModel> models) async {
    await _db.batch((batch) {
      batch.insertAll(
        _db.localDebts,
        models.map((model) => LocalDebtsCompanion(
          id: Value(model.id),
          debtNumber: Value(model.debtNumber),
          customerId: Value(model.customerId),
          totalAmount: Value(model.totalAmount.toDouble()),
          paidAmount: Value(model.paidAmount.toDouble()),
          status: Value(model.status),
          dueDate: Value(model.dueDate),
          rawJson: Value(jsonEncode(model.toJson())),
          pendingSync: const Value(false),
          cachedAt: Value(DateTime.now()),
        )).toList(),
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  /// Offline yaratilgan qarzni pending queue ga qo'shish
  Future<void> savePendingDebt({
    required String localId,
    required Map<String, dynamic> payload,
  }) async {
    await _db
        .into(_db.localPendingActions)
        .insert(
          LocalPendingActionsCompanion(
            entityType: const Value('debt'),
            action: const Value('CREATE'),
            payload: Value(jsonEncode(payload)),
            createdAt: Value(DateTime.now()),
          ),
        );
  }

  /// Pending action ni o'chirish (sync muvaffaqiyatli bo'lgandan keyin)
  Future<void> deletePendingAction(int id) async {
    await (_db.delete(
      _db.localPendingActions,
    )..where((t) => t.id.equals(id))).go();
  }

  /// Barcha pending actionlarni olish
  Future<List<LocalPendingAction>> getPendingActions() async {
    return (_db.select(
      _db.localPendingActions,
    )..orderBy([(t) => OrderingTerm(expression: t.createdAt)])).get();
  }

  /// Retry count ni oshirish
  Future<void> incrementRetry(int id) async {
    final action = await (_db.select(
      _db.localPendingActions,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (action == null) return;

    await (_db.update(
      _db.localPendingActions,
    )..where((t) => t.id.equals(id))).write(
      LocalPendingActionsCompanion(retryCount: Value(action.retryCount + 1)),
    );
  }
}
