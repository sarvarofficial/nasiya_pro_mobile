import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../db/app_database.dart';
import '../../../features/debts/data/sources/debt_remote_source.dart';

/// Offline Sync Manager — network restored bo'lganda pending actionlarni yuboradi
class SyncManager {
  final AppDatabase _db;
  final DebtRemoteSource _debtRemoteSource;

  SyncManager({
    required AppDatabase db,
    required DebtRemoteSource debtRemoteSource,
  }) : _db = db,
       _debtRemoteSource = debtRemoteSource;

  /// Network holatini tekshirish
  Future<bool> isOnline() async {
    final results = await Connectivity().checkConnectivity();
    return !results.contains(ConnectivityResult.none);
  }

  /// Network restored yoki app started → pending actionlarni sync qilish
  Future<void> syncPending() async {
    if (!await isOnline()) return;

    final actions = await (_db.select(
      _db.localPendingActions,
    )..orderBy([(t) => OrderingTerm(expression: t.createdAt)])).get();

    for (final action in actions) {
      try {
        await _processAction(action);
        await (_db.delete(
          _db.localPendingActions,
        )..where((t) => t.id.equals(action.id))).go();
      } catch (e) {
        // Retry count ni oshirish
        await (_db.update(
          _db.localPendingActions,
        )..where((t) => t.id.equals(action.id))).write(
          LocalPendingActionsCompanion(
            retryCount: Value(action.retryCount + 1),
          ),
        );

        // 3 martadan ortiq uringan bo'lsa — skip
        if (action.retryCount >= 3) {
          // TODO: notify user / flag for manual review
        }
      }
    }
  }

  Future<void> _processAction(LocalPendingAction action) async {
    final payload = jsonDecode(action.payload) as Map<String, dynamic>;

    switch (action.entityType) {
      case 'debt':
        if (action.action == 'CREATE') {
          await _debtRemoteSource.createDebt(payload);
        } else if (action.action == 'UPDATE') {
          final id = payload['id'] as String;
          await _debtRemoteSource.updateDebt(id, payload);
        } else if (action.action == 'DELETE') {
          final id = payload['id'] as String;
          await _debtRemoteSource.deleteDebt(id);
        }
        break;
      // payment entity kelajakda qo'shiladi
    }
  }
}
