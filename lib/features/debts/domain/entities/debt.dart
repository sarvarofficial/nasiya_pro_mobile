import 'package:equatable/equatable.dart';

/// Debt entity — pure Dart, Flutter import yo'q
class Debt extends Equatable {
  final String id;
  final String debtNumber;
  final String branchId;
  final String customerId;
  final String customerName;
  final int totalAmount;      // tiyin da
  final int paidAmount;       // tiyin da
  final int remainingAmount;  // tiyin da
  final String status;        // active/partial/paid/overdue/written_off
  final DateTime dueDate;
  final String? note;
  final List<DebtItem> items;
  final String createdBy;
  final String? lastModifiedBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Debt({
    required this.id,
    required this.debtNumber,
    required this.branchId,
    required this.customerId,
    required this.customerName,
    required this.totalAmount,
    required this.paidAmount,
    required this.remainingAmount,
    required this.status,
    required this.dueDate,
    this.note,
    this.items = const [],
    required this.createdBy,
    this.lastModifiedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  /// To'langan foiz (0.0 - 1.0)
  double get paidRatio => totalAmount > 0 ? paidAmount / totalAmount : 0;

  /// Muddati o'tganmi
  bool get isOverdue => status == 'overdue' || 
    (status == 'active' && DateTime.now().isAfter(dueDate));

  /// To'liq to'langanmi
  bool get isPaid => status == 'paid';

  @override
  List<Object?> get props => [id, status, paidAmount, remainingAmount];
}

/// Qarz tarkibidagi mahsulot
class DebtItem extends Equatable {
  final String product;
  final int quantity;
  final int price; // tiyin da

  const DebtItem({
    required this.product,
    required this.quantity,
    required this.price,
  });

  int get total => quantity * price;

  @override
  List<Object?> get props => [product, quantity, price];
}

/// Debt filtr
class DebtFilter extends Equatable {
  final String? status;
  final String? branchId;
  final String? customerId;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String? search;
  final int page;
  final int limit;

  const DebtFilter({
    this.status,
    this.branchId,
    this.customerId,
    this.fromDate,
    this.toDate,
    this.search,
    this.page = 1,
    this.limit = 20,
  });

  DebtFilter copyWith({
    String? status,
    String? branchId,
    String? customerId,
    DateTime? fromDate,
    DateTime? toDate,
    String? search,
    int? page,
    int? limit,
  }) {
    return DebtFilter(
      status: status ?? this.status,
      branchId: branchId ?? this.branchId,
      customerId: customerId ?? this.customerId,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      search: search ?? this.search,
      page: page ?? this.page,
      limit: limit ?? this.limit,
    );
  }

  @override
  List<Object?> get props => [status, branchId, customerId, fromDate, toDate, search, page, limit];
}

/// Debt statistikasi
class DebtStats extends Equatable {
  final int totalDebts;
  final int activeDebts;
  final int overdueDebts;
  final int totalAmount;
  final int paidAmount;
  final int remainingAmount;

  const DebtStats({
    this.totalDebts = 0,
    this.activeDebts = 0,
    this.overdueDebts = 0,
    this.totalAmount = 0,
    this.paidAmount = 0,
    this.remainingAmount = 0,
  });

  @override
  List<Object?> get props => [totalDebts, activeDebts, overdueDebts, totalAmount];
}
