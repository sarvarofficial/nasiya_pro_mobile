import '../entities/debt.dart';
import '../../../../core/api/api_result.dart';

/// Debt repository — abstract interface
abstract class DebtRepository {
  /// Qarzlar ro'yxatini olish (filtrlangan)
  Future<ApiResult<List<Debt>>> getDebts(DebtFilter filter);

  /// Bitta qarzni olish
  Future<ApiResult<Debt>> getDebt(String id);

  /// Yangi qarz yaratish
  Future<ApiResult<Debt>> createDebt(CreateDebtDto dto);

  /// Qarzni tahrirlash
  Future<ApiResult<Debt>> updateDebt(String id, UpdateDebtDto dto);

  /// Qarzni o'chirish (soft delete)
  Future<ApiResult<void>> deleteDebt(String id);

  /// Statistika
  Future<ApiResult<DebtStats>> getStats();
}

/// Yangi qarz uchun DTO
class CreateDebtDto {
  final String customerId;
  final List<DebtItem> items;
  final DateTime dueDate;
  final String? note;

  const CreateDebtDto({
    required this.customerId,
    required this.items,
    required this.dueDate,
    this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      'customerId': customerId,
      'items': items.map((e) => {
        'product': e.product,
        'qty': e.quantity,
        'price': e.price,
      }).toList(),
      'dueDate': dueDate.toIso8601String(),
      if (note != null) 'note': note,
    };
  }
}

/// Qarzni yangilash uchun DTO
class UpdateDebtDto {
  final DateTime? dueDate;
  final String? note;
  final String? status;

  const UpdateDebtDto({this.dueDate, this.note, this.status});

  Map<String, dynamic> toJson() {
    return {
      if (dueDate != null) 'dueDate': dueDate!.toIso8601String(),
      if (note != null) 'note': note,
      if (status != null) 'status': status,
    };
  }
}
