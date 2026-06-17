import '../../domain/entities/debt.dart';

/// Debt model — JSON serializable
class DebtModel {
  final String id;
  final String debtNumber;
  final String branchId;
  final String customerId;
  final String customerName;
  final int totalAmount;
  final int paidAmount;
  final int remainingAmount;
  final String status;
  final DateTime dueDate;
  final String? note;
  final List<DebtItemModel> items;
  final String createdBy;
  final String? lastModifiedBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DebtModel({
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

  /// Helper: amount string yoki int ni parse qiladi → int (tiyin)
  static int _parseAmount(dynamic val) {
    if (val == null) return 0;
    if (val is int) return val;
    if (val is double) return val.round();
    if (val is String) return double.tryParse(val)?.round() ?? 0;
    return 0;
  }

  factory DebtModel.fromJson(Map<String, dynamic> json) {
    return DebtModel(
      id: json['id'] as String,
      debtNumber: json['debtNumber'] as String? ?? json['debt_number'] as String? ?? '',
      branchId: json['branchId'] as String? ?? json['branch_id'] as String? ?? '',
      customerId: json['customerId'] as String? ?? json['customer_id'] as String? ?? '',
      customerName: json['customerName'] as String? ??
          json['customer_name'] as String? ??
          json['customer']?['fullName'] as String? ?? '',
      totalAmount: _parseAmount(json['totalAmount'] ?? json['total_amount']),
      paidAmount: _parseAmount(json['paidAmount'] ?? json['paid_amount']),
      remainingAmount: _parseAmount(json['remainingAmount'] ?? json['remaining_amount']),
      status: json['status'] as String? ?? 'active',
      dueDate: DateTime.parse(json['dueDate'] as String? ?? json['due_date'] as String? ?? DateTime.now().toIso8601String()),
      note: json['note'] as String?,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => DebtItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ?? [],
      createdBy: json['createdBy'] as String? ?? json['created_by'] as String? ?? '',
      lastModifiedBy: json['lastModifiedBy'] as String? ?? json['last_modified_by'] as String?,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? json['created_at'] as String? ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? json['updated_at'] as String? ?? '') ?? DateTime.now(),
    );
  }


  /// Domain entity ga convert
  Debt toEntity() {
    return Debt(
      id: id,
      debtNumber: debtNumber,
      branchId: branchId,
      customerId: customerId,
      customerName: customerName,
      totalAmount: totalAmount,
      paidAmount: paidAmount,
      remainingAmount: remainingAmount,
      status: status,
      dueDate: dueDate,
      note: note,
      items: items.map((e) => e.toEntity()).toList(),
      createdBy: createdBy,
      lastModifiedBy: lastModifiedBy,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// JSON ga convert (local cache uchun)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'debtNumber': debtNumber,
      'branchId': branchId,
      'customerId': customerId,
      'customerName': customerName,
      'totalAmount': totalAmount,
      'paidAmount': paidAmount,
      'remainingAmount': remainingAmount,
      'status': status,
      'dueDate': dueDate.toIso8601String(),
      'note': note,
      'items': items.map((e) => e.toJson()).toList(),
      'createdBy': createdBy,
      'lastModifiedBy': lastModifiedBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class DebtItemModel {
  final String product;
  final int quantity;
  final int price;

  const DebtItemModel({
    required this.product,
    required this.quantity,
    required this.price,
  });

  factory DebtItemModel.fromJson(Map<String, dynamic> json) {
    return DebtItemModel(
      product: json['product'] as String,
      quantity: (json['qty'] ?? json['quantity'] ?? 0) as int,
      price: (json['price'] ?? 0) as int,
    );
  }

  DebtItem toEntity() => DebtItem(product: product, quantity: quantity, price: price);

  Map<String, dynamic> toJson() => {
    'product': product,
    'qty': quantity,
    'price': price,
  };
}

