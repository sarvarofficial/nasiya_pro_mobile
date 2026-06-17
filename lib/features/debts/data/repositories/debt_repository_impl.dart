import 'package:connectivity_plus/connectivity_plus.dart';
import '../../domain/entities/debt.dart';
import '../../domain/repositories/debt_repository.dart';
import '../sources/debt_remote_source.dart';
import '../sources/debt_local_source.dart';
import '../../../../core/api/api_result.dart';

/// Debt repository — offline-first implementatsiya
///
/// Strategiya:
/// 1. Online → remote dan ol, local ga cache qil
/// 2. Offline → local dan ol
/// 3. Offline write → local ga yoz + queue ga qo'sh, sync bo'lganda serverga yubor
class DebtRepositoryImpl implements DebtRepository {
  final DebtRemoteSource _remoteSource;
  final DebtLocalSource _localSource;

  DebtRepositoryImpl({
    required DebtRemoteSource remoteSource,
    required DebtLocalSource localSource,
  })  : _remoteSource = remoteSource,
        _localSource = localSource;

  @override
  Future<ApiResult<List<Debt>>> getDebts(DebtFilter filter) async {
    try {
      final isOnline = await _isOnline();
      if (isOnline) {
        final params = <String, dynamic>{
          'page': filter.page,
          'limit': filter.limit,
          if (filter.status != null) 'status': filter.status,
          if (filter.branchId != null) 'branch': filter.branchId,
          if (filter.customerId != null) 'customer': filter.customerId,
          if (filter.search != null) 'search': filter.search,
        };
        final models = await _remoteSource.getDebts(queryParams: params);
        // Cache local ga
        await _localSource.upsertDebts(models);
        return ApiResult.success(models.map((m) => m.toEntity()).toList());
      } else {
        // Offline — local dan
        final models = await _localSource.getDebts();
        return ApiResult.success(models.map((m) => m.toEntity()).toList());
      }
    } catch (e) {
      // Xatolik bo'lsa local dan urinib ko'r
      try {
        final models = await _localSource.getDebts();
        return ApiResult.success(models.map((m) => m.toEntity()).toList());
      } catch (_) {
        return ApiResult.failure(_handleError(e));
      }
    }
  }

  @override
  Future<ApiResult<Debt>> getDebt(String id) async {
    try {
      final model = await _remoteSource.getDebt(id);
      await _localSource.upsertDebt(model);
      return ApiResult.success(model.toEntity());
    } catch (e) {
      return ApiResult.failure(_handleError(e));
    }
  }

  @override
  Future<ApiResult<Debt>> createDebt(CreateDebtDto dto) async {
    try {
      final isOnline = await _isOnline();
      if (isOnline) {
        final model = await _remoteSource.createDebt(dto.toJson());
        await _localSource.upsertDebt(model);
        return ApiResult.success(model.toEntity());
      } else {
        // Offline — queue ga qo'sh
        await _localSource.savePendingDebt(
          localId: DateTime.now().millisecondsSinceEpoch.toString(),
          payload: dto.toJson(),
        );
        // Optimistic response — haqiqiy ID yo'q, lekin UI ko'rsatiladi
        return ApiResult.failure(
          AppError.network('Offline rejim: qarz sync bo\'lganda yuboriladi'),
        );
      }
    } catch (e) {
      return ApiResult.failure(_handleError(e));
    }
  }

  @override
  Future<ApiResult<Debt>> updateDebt(String id, UpdateDebtDto dto) async {
    try {
      final model = await _remoteSource.updateDebt(id, dto.toJson());
      await _localSource.upsertDebt(model);
      return ApiResult.success(model.toEntity());
    } catch (e) {
      return ApiResult.failure(_handleError(e));
    }
  }

  @override
  Future<ApiResult<void>> deleteDebt(String id) async {
    try {
      await _remoteSource.deleteDebt(id);
      return const ApiResult.success(null);
    } catch (e) {
      return ApiResult.failure(_handleError(e));
    }
  }

  @override
  Future<ApiResult<DebtStats>> getStats() async {
    try {
      final data = await _remoteSource.getStats();
      return ApiResult.success(DebtStats(
        totalDebts: data['totalDebts'] as int? ?? 0,
        activeDebts: data['activeDebts'] as int? ?? 0,
        overdueDebts: data['overdueDebts'] as int? ?? 0,
        totalAmount: data['totalAmount'] as int? ?? 0,
        paidAmount: data['paidAmount'] as int? ?? 0,
        remainingAmount: data['remainingAmount'] as int? ?? 0,
      ));
    } catch (e) {
      return ApiResult.failure(_handleError(e));
    }
  }

  Future<bool> _isOnline() async {
    final result = await Connectivity().checkConnectivity();
    return result.isNotEmpty && !result.contains(ConnectivityResult.none);
  }

  AppError _handleError(dynamic e) {
    if (e is AppError) return e;
    final msg = e.toString();
    if (msg.contains('SocketException') || msg.contains('Connection')) {
      return AppError.network();
    }
    return AppError.unknown(msg);
  }
}
