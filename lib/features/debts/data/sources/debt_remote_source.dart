import 'package:dio/dio.dart';
import '../models/debt_model.dart';

/// Debt API calls — API doc bo'yicha
/// Base: /api/v1/debts
class DebtRemoteSource {
  final Dio _dio;

  DebtRemoteSource({required Dio dio}) : _dio = dio;

  /// GET /api/v1/debts
  Future<List<DebtModel>> getDebts({Map<String, dynamic>? queryParams}) async {
    final response = await _dio.get('/debts', queryParameters: queryParams);
    final list = response.data['data'] as List<dynamic>;
    return list.map((e) => DebtModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// GET /api/v1/debts/:id
  Future<DebtModel> getDebt(String id) async {
    final response = await _dio.get('/debts/$id');
    return DebtModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  /// POST /api/v1/debts
  Future<DebtModel> createDebt(Map<String, dynamic> data) async {
    final response = await _dio.post('/debts', data: data);
    return DebtModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  /// PATCH /api/v1/debts/:id
  Future<DebtModel> updateDebt(String id, Map<String, dynamic> data) async {
    final response = await _dio.patch('/debts/$id', data: data);
    return DebtModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  /// DELETE /api/v1/debts/:id  (soft delete)
  Future<void> deleteDebt(String id) async {
    await _dio.delete('/debts/$id');
  }

  /// GET /api/v1/reports/dashboard
  /// API doc bo'yicha response strukturasi:
  /// { debts: {total, active, overdue, paid}, amounts: {totalDebt, totalPaid, totalRemaining}, today: {...} }
  Future<Map<String, dynamic>> getStats() async {
    final response = await _dio.get('/reports/dashboard');
    final raw = response.data['data'] as Map<String, dynamic>;
    final debts = raw['debts'] as Map<String, dynamic>? ?? {};
    final amounts = raw['amounts'] as Map<String, dynamic>? ?? {};
    // Normalize to expected format
    return {
      'totalDebts': debts['total'] as int? ?? 0,
      'activeDebts': debts['active'] as int? ?? 0,
      'overdueDebts': debts['overdue'] as int? ?? 0,
      'paidDebts': debts['paid'] as int? ?? 0,
      'totalAmount': amounts['totalDebt'] as int? ?? 0,
      'paidAmount': amounts['totalPaid'] as int? ?? 0,
      'remainingAmount': amounts['totalRemaining'] as int? ?? 0,
    };
  }
}
