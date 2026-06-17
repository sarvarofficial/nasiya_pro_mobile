import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

// ─── Tables ───────────────────────────────────────────────

/// Local debts cache table
@DataClassName('LocalDebt')
class LocalDebts extends Table {
  TextColumn get id => text()();
  TextColumn get debtNumber => text()();
  TextColumn get customerId => text()();
  RealColumn get totalAmount => real()();
  RealColumn get paidAmount => real()();
  TextColumn get status => text()();
  DateTimeColumn get dueDate => dateTime()();
  TextColumn get rawJson => text()(); // full JSON cached
  BoolColumn get pendingSync => boolean().withDefault(const Constant(false))();
  TextColumn get pendingAction => text().nullable()(); // CREATE/UPDATE/DELETE
  DateTimeColumn get cachedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Pending actions for offline sync queue
@DataClassName('LocalPendingAction')
class LocalPendingActions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entityType => text()(); // debt / payment / customer
  TextColumn get action => text()(); // CREATE / UPDATE / DELETE
  TextColumn get payload => text()(); // JSON string
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
}

// ─── Database ─────────────────────────────────────────────

@DriftDatabase(tables: [LocalDebts, LocalPendingActions])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'nasiya_pro.sqlite'));
      return NativeDatabase.createInBackground(file);
    });
  }
}
