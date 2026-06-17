// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $LocalDebtsTable extends LocalDebts
    with TableInfo<$LocalDebtsTable, LocalDebt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalDebtsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _debtNumberMeta = const VerificationMeta(
    'debtNumber',
  );
  @override
  late final GeneratedColumn<String> debtNumber = GeneratedColumn<String>(
    'debt_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
    'customer_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalAmountMeta = const VerificationMeta(
    'totalAmount',
  );
  @override
  late final GeneratedColumn<double> totalAmount = GeneratedColumn<double>(
    'total_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paidAmountMeta = const VerificationMeta(
    'paidAmount',
  );
  @override
  late final GeneratedColumn<double> paidAmount = GeneratedColumn<double>(
    'paid_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rawJsonMeta = const VerificationMeta(
    'rawJson',
  );
  @override
  late final GeneratedColumn<String> rawJson = GeneratedColumn<String>(
    'raw_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pendingSyncMeta = const VerificationMeta(
    'pendingSync',
  );
  @override
  late final GeneratedColumn<bool> pendingSync = GeneratedColumn<bool>(
    'pending_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("pending_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _pendingActionMeta = const VerificationMeta(
    'pendingAction',
  );
  @override
  late final GeneratedColumn<String> pendingAction = GeneratedColumn<String>(
    'pending_action',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    debtNumber,
    customerId,
    totalAmount,
    paidAmount,
    status,
    dueDate,
    rawJson,
    pendingSync,
    pendingAction,
    cachedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_debts';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalDebt> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('debt_number')) {
      context.handle(
        _debtNumberMeta,
        debtNumber.isAcceptableOrUnknown(data['debt_number']!, _debtNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_debtNumberMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_customerIdMeta);
    }
    if (data.containsKey('total_amount')) {
      context.handle(
        _totalAmountMeta,
        totalAmount.isAcceptableOrUnknown(
          data['total_amount']!,
          _totalAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalAmountMeta);
    }
    if (data.containsKey('paid_amount')) {
      context.handle(
        _paidAmountMeta,
        paidAmount.isAcceptableOrUnknown(data['paid_amount']!, _paidAmountMeta),
      );
    } else if (isInserting) {
      context.missing(_paidAmountMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    } else if (isInserting) {
      context.missing(_dueDateMeta);
    }
    if (data.containsKey('raw_json')) {
      context.handle(
        _rawJsonMeta,
        rawJson.isAcceptableOrUnknown(data['raw_json']!, _rawJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_rawJsonMeta);
    }
    if (data.containsKey('pending_sync')) {
      context.handle(
        _pendingSyncMeta,
        pendingSync.isAcceptableOrUnknown(
          data['pending_sync']!,
          _pendingSyncMeta,
        ),
      );
    }
    if (data.containsKey('pending_action')) {
      context.handle(
        _pendingActionMeta,
        pendingAction.isAcceptableOrUnknown(
          data['pending_action']!,
          _pendingActionMeta,
        ),
      );
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalDebt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalDebt(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      debtNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}debt_number'],
      )!,
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_id'],
      )!,
      totalAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_amount'],
      )!,
      paidAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}paid_amount'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      )!,
      rawJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_json'],
      )!,
      pendingSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}pending_sync'],
      )!,
      pendingAction: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pending_action'],
      ),
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $LocalDebtsTable createAlias(String alias) {
    return $LocalDebtsTable(attachedDatabase, alias);
  }
}

class LocalDebt extends DataClass implements Insertable<LocalDebt> {
  final String id;
  final String debtNumber;
  final String customerId;
  final double totalAmount;
  final double paidAmount;
  final String status;
  final DateTime dueDate;
  final String rawJson;
  final bool pendingSync;
  final String? pendingAction;
  final DateTime cachedAt;
  const LocalDebt({
    required this.id,
    required this.debtNumber,
    required this.customerId,
    required this.totalAmount,
    required this.paidAmount,
    required this.status,
    required this.dueDate,
    required this.rawJson,
    required this.pendingSync,
    this.pendingAction,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['debt_number'] = Variable<String>(debtNumber);
    map['customer_id'] = Variable<String>(customerId);
    map['total_amount'] = Variable<double>(totalAmount);
    map['paid_amount'] = Variable<double>(paidAmount);
    map['status'] = Variable<String>(status);
    map['due_date'] = Variable<DateTime>(dueDate);
    map['raw_json'] = Variable<String>(rawJson);
    map['pending_sync'] = Variable<bool>(pendingSync);
    if (!nullToAbsent || pendingAction != null) {
      map['pending_action'] = Variable<String>(pendingAction);
    }
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  LocalDebtsCompanion toCompanion(bool nullToAbsent) {
    return LocalDebtsCompanion(
      id: Value(id),
      debtNumber: Value(debtNumber),
      customerId: Value(customerId),
      totalAmount: Value(totalAmount),
      paidAmount: Value(paidAmount),
      status: Value(status),
      dueDate: Value(dueDate),
      rawJson: Value(rawJson),
      pendingSync: Value(pendingSync),
      pendingAction: pendingAction == null && nullToAbsent
          ? const Value.absent()
          : Value(pendingAction),
      cachedAt: Value(cachedAt),
    );
  }

  factory LocalDebt.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalDebt(
      id: serializer.fromJson<String>(json['id']),
      debtNumber: serializer.fromJson<String>(json['debtNumber']),
      customerId: serializer.fromJson<String>(json['customerId']),
      totalAmount: serializer.fromJson<double>(json['totalAmount']),
      paidAmount: serializer.fromJson<double>(json['paidAmount']),
      status: serializer.fromJson<String>(json['status']),
      dueDate: serializer.fromJson<DateTime>(json['dueDate']),
      rawJson: serializer.fromJson<String>(json['rawJson']),
      pendingSync: serializer.fromJson<bool>(json['pendingSync']),
      pendingAction: serializer.fromJson<String?>(json['pendingAction']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'debtNumber': serializer.toJson<String>(debtNumber),
      'customerId': serializer.toJson<String>(customerId),
      'totalAmount': serializer.toJson<double>(totalAmount),
      'paidAmount': serializer.toJson<double>(paidAmount),
      'status': serializer.toJson<String>(status),
      'dueDate': serializer.toJson<DateTime>(dueDate),
      'rawJson': serializer.toJson<String>(rawJson),
      'pendingSync': serializer.toJson<bool>(pendingSync),
      'pendingAction': serializer.toJson<String?>(pendingAction),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  LocalDebt copyWith({
    String? id,
    String? debtNumber,
    String? customerId,
    double? totalAmount,
    double? paidAmount,
    String? status,
    DateTime? dueDate,
    String? rawJson,
    bool? pendingSync,
    Value<String?> pendingAction = const Value.absent(),
    DateTime? cachedAt,
  }) => LocalDebt(
    id: id ?? this.id,
    debtNumber: debtNumber ?? this.debtNumber,
    customerId: customerId ?? this.customerId,
    totalAmount: totalAmount ?? this.totalAmount,
    paidAmount: paidAmount ?? this.paidAmount,
    status: status ?? this.status,
    dueDate: dueDate ?? this.dueDate,
    rawJson: rawJson ?? this.rawJson,
    pendingSync: pendingSync ?? this.pendingSync,
    pendingAction: pendingAction.present
        ? pendingAction.value
        : this.pendingAction,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  LocalDebt copyWithCompanion(LocalDebtsCompanion data) {
    return LocalDebt(
      id: data.id.present ? data.id.value : this.id,
      debtNumber: data.debtNumber.present
          ? data.debtNumber.value
          : this.debtNumber,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      totalAmount: data.totalAmount.present
          ? data.totalAmount.value
          : this.totalAmount,
      paidAmount: data.paidAmount.present
          ? data.paidAmount.value
          : this.paidAmount,
      status: data.status.present ? data.status.value : this.status,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      rawJson: data.rawJson.present ? data.rawJson.value : this.rawJson,
      pendingSync: data.pendingSync.present
          ? data.pendingSync.value
          : this.pendingSync,
      pendingAction: data.pendingAction.present
          ? data.pendingAction.value
          : this.pendingAction,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalDebt(')
          ..write('id: $id, ')
          ..write('debtNumber: $debtNumber, ')
          ..write('customerId: $customerId, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('paidAmount: $paidAmount, ')
          ..write('status: $status, ')
          ..write('dueDate: $dueDate, ')
          ..write('rawJson: $rawJson, ')
          ..write('pendingSync: $pendingSync, ')
          ..write('pendingAction: $pendingAction, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    debtNumber,
    customerId,
    totalAmount,
    paidAmount,
    status,
    dueDate,
    rawJson,
    pendingSync,
    pendingAction,
    cachedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalDebt &&
          other.id == this.id &&
          other.debtNumber == this.debtNumber &&
          other.customerId == this.customerId &&
          other.totalAmount == this.totalAmount &&
          other.paidAmount == this.paidAmount &&
          other.status == this.status &&
          other.dueDate == this.dueDate &&
          other.rawJson == this.rawJson &&
          other.pendingSync == this.pendingSync &&
          other.pendingAction == this.pendingAction &&
          other.cachedAt == this.cachedAt);
}

class LocalDebtsCompanion extends UpdateCompanion<LocalDebt> {
  final Value<String> id;
  final Value<String> debtNumber;
  final Value<String> customerId;
  final Value<double> totalAmount;
  final Value<double> paidAmount;
  final Value<String> status;
  final Value<DateTime> dueDate;
  final Value<String> rawJson;
  final Value<bool> pendingSync;
  final Value<String?> pendingAction;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const LocalDebtsCompanion({
    this.id = const Value.absent(),
    this.debtNumber = const Value.absent(),
    this.customerId = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.paidAmount = const Value.absent(),
    this.status = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.rawJson = const Value.absent(),
    this.pendingSync = const Value.absent(),
    this.pendingAction = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalDebtsCompanion.insert({
    required String id,
    required String debtNumber,
    required String customerId,
    required double totalAmount,
    required double paidAmount,
    required String status,
    required DateTime dueDate,
    required String rawJson,
    this.pendingSync = const Value.absent(),
    this.pendingAction = const Value.absent(),
    required DateTime cachedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       debtNumber = Value(debtNumber),
       customerId = Value(customerId),
       totalAmount = Value(totalAmount),
       paidAmount = Value(paidAmount),
       status = Value(status),
       dueDate = Value(dueDate),
       rawJson = Value(rawJson),
       cachedAt = Value(cachedAt);
  static Insertable<LocalDebt> custom({
    Expression<String>? id,
    Expression<String>? debtNumber,
    Expression<String>? customerId,
    Expression<double>? totalAmount,
    Expression<double>? paidAmount,
    Expression<String>? status,
    Expression<DateTime>? dueDate,
    Expression<String>? rawJson,
    Expression<bool>? pendingSync,
    Expression<String>? pendingAction,
    Expression<DateTime>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (debtNumber != null) 'debt_number': debtNumber,
      if (customerId != null) 'customer_id': customerId,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (paidAmount != null) 'paid_amount': paidAmount,
      if (status != null) 'status': status,
      if (dueDate != null) 'due_date': dueDate,
      if (rawJson != null) 'raw_json': rawJson,
      if (pendingSync != null) 'pending_sync': pendingSync,
      if (pendingAction != null) 'pending_action': pendingAction,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalDebtsCompanion copyWith({
    Value<String>? id,
    Value<String>? debtNumber,
    Value<String>? customerId,
    Value<double>? totalAmount,
    Value<double>? paidAmount,
    Value<String>? status,
    Value<DateTime>? dueDate,
    Value<String>? rawJson,
    Value<bool>? pendingSync,
    Value<String?>? pendingAction,
    Value<DateTime>? cachedAt,
    Value<int>? rowid,
  }) {
    return LocalDebtsCompanion(
      id: id ?? this.id,
      debtNumber: debtNumber ?? this.debtNumber,
      customerId: customerId ?? this.customerId,
      totalAmount: totalAmount ?? this.totalAmount,
      paidAmount: paidAmount ?? this.paidAmount,
      status: status ?? this.status,
      dueDate: dueDate ?? this.dueDate,
      rawJson: rawJson ?? this.rawJson,
      pendingSync: pendingSync ?? this.pendingSync,
      pendingAction: pendingAction ?? this.pendingAction,
      cachedAt: cachedAt ?? this.cachedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (debtNumber.present) {
      map['debt_number'] = Variable<String>(debtNumber.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<double>(totalAmount.value);
    }
    if (paidAmount.present) {
      map['paid_amount'] = Variable<double>(paidAmount.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (rawJson.present) {
      map['raw_json'] = Variable<String>(rawJson.value);
    }
    if (pendingSync.present) {
      map['pending_sync'] = Variable<bool>(pendingSync.value);
    }
    if (pendingAction.present) {
      map['pending_action'] = Variable<String>(pendingAction.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalDebtsCompanion(')
          ..write('id: $id, ')
          ..write('debtNumber: $debtNumber, ')
          ..write('customerId: $customerId, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('paidAmount: $paidAmount, ')
          ..write('status: $status, ')
          ..write('dueDate: $dueDate, ')
          ..write('rawJson: $rawJson, ')
          ..write('pendingSync: $pendingSync, ')
          ..write('pendingAction: $pendingAction, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalPendingActionsTable extends LocalPendingActions
    with TableInfo<$LocalPendingActionsTable, LocalPendingAction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalPendingActionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
    'action',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _retryCountMeta = const VerificationMeta(
    'retryCount',
  );
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
    'retry_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entityType,
    action,
    payload,
    retryCount,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_pending_actions';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalPendingAction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('action')) {
      context.handle(
        _actionMeta,
        action.isAcceptableOrUnknown(data['action']!, _actionMeta),
      );
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('retry_count')) {
      context.handle(
        _retryCountMeta,
        retryCount.isAcceptableOrUnknown(data['retry_count']!, _retryCountMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalPendingAction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalPendingAction(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      action: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      retryCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retry_count'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $LocalPendingActionsTable createAlias(String alias) {
    return $LocalPendingActionsTable(attachedDatabase, alias);
  }
}

class LocalPendingAction extends DataClass
    implements Insertable<LocalPendingAction> {
  final int id;
  final String entityType;
  final String action;
  final String payload;
  final int retryCount;
  final DateTime createdAt;
  const LocalPendingAction({
    required this.id,
    required this.entityType,
    required this.action,
    required this.payload,
    required this.retryCount,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['entity_type'] = Variable<String>(entityType);
    map['action'] = Variable<String>(action);
    map['payload'] = Variable<String>(payload);
    map['retry_count'] = Variable<int>(retryCount);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  LocalPendingActionsCompanion toCompanion(bool nullToAbsent) {
    return LocalPendingActionsCompanion(
      id: Value(id),
      entityType: Value(entityType),
      action: Value(action),
      payload: Value(payload),
      retryCount: Value(retryCount),
      createdAt: Value(createdAt),
    );
  }

  factory LocalPendingAction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalPendingAction(
      id: serializer.fromJson<int>(json['id']),
      entityType: serializer.fromJson<String>(json['entityType']),
      action: serializer.fromJson<String>(json['action']),
      payload: serializer.fromJson<String>(json['payload']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'entityType': serializer.toJson<String>(entityType),
      'action': serializer.toJson<String>(action),
      'payload': serializer.toJson<String>(payload),
      'retryCount': serializer.toJson<int>(retryCount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  LocalPendingAction copyWith({
    int? id,
    String? entityType,
    String? action,
    String? payload,
    int? retryCount,
    DateTime? createdAt,
  }) => LocalPendingAction(
    id: id ?? this.id,
    entityType: entityType ?? this.entityType,
    action: action ?? this.action,
    payload: payload ?? this.payload,
    retryCount: retryCount ?? this.retryCount,
    createdAt: createdAt ?? this.createdAt,
  );
  LocalPendingAction copyWithCompanion(LocalPendingActionsCompanion data) {
    return LocalPendingAction(
      id: data.id.present ? data.id.value : this.id,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      action: data.action.present ? data.action.value : this.action,
      payload: data.payload.present ? data.payload.value : this.payload,
      retryCount: data.retryCount.present
          ? data.retryCount.value
          : this.retryCount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalPendingAction(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('action: $action, ')
          ..write('payload: $payload, ')
          ..write('retryCount: $retryCount, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, entityType, action, payload, retryCount, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalPendingAction &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.action == this.action &&
          other.payload == this.payload &&
          other.retryCount == this.retryCount &&
          other.createdAt == this.createdAt);
}

class LocalPendingActionsCompanion extends UpdateCompanion<LocalPendingAction> {
  final Value<int> id;
  final Value<String> entityType;
  final Value<String> action;
  final Value<String> payload;
  final Value<int> retryCount;
  final Value<DateTime> createdAt;
  const LocalPendingActionsCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.action = const Value.absent(),
    this.payload = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  LocalPendingActionsCompanion.insert({
    this.id = const Value.absent(),
    required String entityType,
    required String action,
    required String payload,
    this.retryCount = const Value.absent(),
    required DateTime createdAt,
  }) : entityType = Value(entityType),
       action = Value(action),
       payload = Value(payload),
       createdAt = Value(createdAt);
  static Insertable<LocalPendingAction> custom({
    Expression<int>? id,
    Expression<String>? entityType,
    Expression<String>? action,
    Expression<String>? payload,
    Expression<int>? retryCount,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (action != null) 'action': action,
      if (payload != null) 'payload': payload,
      if (retryCount != null) 'retry_count': retryCount,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  LocalPendingActionsCompanion copyWith({
    Value<int>? id,
    Value<String>? entityType,
    Value<String>? action,
    Value<String>? payload,
    Value<int>? retryCount,
    Value<DateTime>? createdAt,
  }) {
    return LocalPendingActionsCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      action: action ?? this.action,
      payload: payload ?? this.payload,
      retryCount: retryCount ?? this.retryCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalPendingActionsCompanion(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('action: $action, ')
          ..write('payload: $payload, ')
          ..write('retryCount: $retryCount, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LocalDebtsTable localDebts = $LocalDebtsTable(this);
  late final $LocalPendingActionsTable localPendingActions =
      $LocalPendingActionsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    localDebts,
    localPendingActions,
  ];
}

typedef $$LocalDebtsTableCreateCompanionBuilder =
    LocalDebtsCompanion Function({
      required String id,
      required String debtNumber,
      required String customerId,
      required double totalAmount,
      required double paidAmount,
      required String status,
      required DateTime dueDate,
      required String rawJson,
      Value<bool> pendingSync,
      Value<String?> pendingAction,
      required DateTime cachedAt,
      Value<int> rowid,
    });
typedef $$LocalDebtsTableUpdateCompanionBuilder =
    LocalDebtsCompanion Function({
      Value<String> id,
      Value<String> debtNumber,
      Value<String> customerId,
      Value<double> totalAmount,
      Value<double> paidAmount,
      Value<String> status,
      Value<DateTime> dueDate,
      Value<String> rawJson,
      Value<bool> pendingSync,
      Value<String?> pendingAction,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });

class $$LocalDebtsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalDebtsTable> {
  $$LocalDebtsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get debtNumber => $composableBuilder(
    column: $table.debtNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get paidAmount => $composableBuilder(
    column: $table.paidAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawJson => $composableBuilder(
    column: $table.rawJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get pendingSync => $composableBuilder(
    column: $table.pendingSync,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pendingAction => $composableBuilder(
    column: $table.pendingAction,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalDebtsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalDebtsTable> {
  $$LocalDebtsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get debtNumber => $composableBuilder(
    column: $table.debtNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get paidAmount => $composableBuilder(
    column: $table.paidAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawJson => $composableBuilder(
    column: $table.rawJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get pendingSync => $composableBuilder(
    column: $table.pendingSync,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pendingAction => $composableBuilder(
    column: $table.pendingAction,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalDebtsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalDebtsTable> {
  $$LocalDebtsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get debtNumber => $composableBuilder(
    column: $table.debtNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get paidAmount => $composableBuilder(
    column: $table.paidAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<String> get rawJson =>
      $composableBuilder(column: $table.rawJson, builder: (column) => column);

  GeneratedColumn<bool> get pendingSync => $composableBuilder(
    column: $table.pendingSync,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pendingAction => $composableBuilder(
    column: $table.pendingAction,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$LocalDebtsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalDebtsTable,
          LocalDebt,
          $$LocalDebtsTableFilterComposer,
          $$LocalDebtsTableOrderingComposer,
          $$LocalDebtsTableAnnotationComposer,
          $$LocalDebtsTableCreateCompanionBuilder,
          $$LocalDebtsTableUpdateCompanionBuilder,
          (
            LocalDebt,
            BaseReferences<_$AppDatabase, $LocalDebtsTable, LocalDebt>,
          ),
          LocalDebt,
          PrefetchHooks Function()
        > {
  $$LocalDebtsTableTableManager(_$AppDatabase db, $LocalDebtsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalDebtsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalDebtsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalDebtsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> debtNumber = const Value.absent(),
                Value<String> customerId = const Value.absent(),
                Value<double> totalAmount = const Value.absent(),
                Value<double> paidAmount = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> dueDate = const Value.absent(),
                Value<String> rawJson = const Value.absent(),
                Value<bool> pendingSync = const Value.absent(),
                Value<String?> pendingAction = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalDebtsCompanion(
                id: id,
                debtNumber: debtNumber,
                customerId: customerId,
                totalAmount: totalAmount,
                paidAmount: paidAmount,
                status: status,
                dueDate: dueDate,
                rawJson: rawJson,
                pendingSync: pendingSync,
                pendingAction: pendingAction,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String debtNumber,
                required String customerId,
                required double totalAmount,
                required double paidAmount,
                required String status,
                required DateTime dueDate,
                required String rawJson,
                Value<bool> pendingSync = const Value.absent(),
                Value<String?> pendingAction = const Value.absent(),
                required DateTime cachedAt,
                Value<int> rowid = const Value.absent(),
              }) => LocalDebtsCompanion.insert(
                id: id,
                debtNumber: debtNumber,
                customerId: customerId,
                totalAmount: totalAmount,
                paidAmount: paidAmount,
                status: status,
                dueDate: dueDate,
                rawJson: rawJson,
                pendingSync: pendingSync,
                pendingAction: pendingAction,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalDebtsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalDebtsTable,
      LocalDebt,
      $$LocalDebtsTableFilterComposer,
      $$LocalDebtsTableOrderingComposer,
      $$LocalDebtsTableAnnotationComposer,
      $$LocalDebtsTableCreateCompanionBuilder,
      $$LocalDebtsTableUpdateCompanionBuilder,
      (LocalDebt, BaseReferences<_$AppDatabase, $LocalDebtsTable, LocalDebt>),
      LocalDebt,
      PrefetchHooks Function()
    >;
typedef $$LocalPendingActionsTableCreateCompanionBuilder =
    LocalPendingActionsCompanion Function({
      Value<int> id,
      required String entityType,
      required String action,
      required String payload,
      Value<int> retryCount,
      required DateTime createdAt,
    });
typedef $$LocalPendingActionsTableUpdateCompanionBuilder =
    LocalPendingActionsCompanion Function({
      Value<int> id,
      Value<String> entityType,
      Value<String> action,
      Value<String> payload,
      Value<int> retryCount,
      Value<DateTime> createdAt,
    });

class $$LocalPendingActionsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalPendingActionsTable> {
  $$LocalPendingActionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalPendingActionsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalPendingActionsTable> {
  $$LocalPendingActionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalPendingActionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalPendingActionsTable> {
  $$LocalPendingActionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$LocalPendingActionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalPendingActionsTable,
          LocalPendingAction,
          $$LocalPendingActionsTableFilterComposer,
          $$LocalPendingActionsTableOrderingComposer,
          $$LocalPendingActionsTableAnnotationComposer,
          $$LocalPendingActionsTableCreateCompanionBuilder,
          $$LocalPendingActionsTableUpdateCompanionBuilder,
          (
            LocalPendingAction,
            BaseReferences<
              _$AppDatabase,
              $LocalPendingActionsTable,
              LocalPendingAction
            >,
          ),
          LocalPendingAction,
          PrefetchHooks Function()
        > {
  $$LocalPendingActionsTableTableManager(
    _$AppDatabase db,
    $LocalPendingActionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalPendingActionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalPendingActionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalPendingActionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> action = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => LocalPendingActionsCompanion(
                id: id,
                entityType: entityType,
                action: action,
                payload: payload,
                retryCount: retryCount,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String entityType,
                required String action,
                required String payload,
                Value<int> retryCount = const Value.absent(),
                required DateTime createdAt,
              }) => LocalPendingActionsCompanion.insert(
                id: id,
                entityType: entityType,
                action: action,
                payload: payload,
                retryCount: retryCount,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalPendingActionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalPendingActionsTable,
      LocalPendingAction,
      $$LocalPendingActionsTableFilterComposer,
      $$LocalPendingActionsTableOrderingComposer,
      $$LocalPendingActionsTableAnnotationComposer,
      $$LocalPendingActionsTableCreateCompanionBuilder,
      $$LocalPendingActionsTableUpdateCompanionBuilder,
      (
        LocalPendingAction,
        BaseReferences<
          _$AppDatabase,
          $LocalPendingActionsTable,
          LocalPendingAction
        >,
      ),
      LocalPendingAction,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LocalDebtsTableTableManager get localDebts =>
      $$LocalDebtsTableTableManager(_db, _db.localDebts);
  $$LocalPendingActionsTableTableManager get localPendingActions =>
      $$LocalPendingActionsTableTableManager(_db, _db.localPendingActions);
}
