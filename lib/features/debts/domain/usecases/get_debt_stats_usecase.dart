import '../../domain/entities/debt.dart';
import '../../domain/repositories/debt_repository.dart';
import '../../../../core/api/api_result.dart';

/// Qarz statistikasini olish — UseCase
class GetDebtStatsUseCase {
  final DebtRepository _repository;

  const GetDebtStatsUseCase(this._repository);

  Future<ApiResult<DebtStats>> call() {
    return _repository.getStats();
  }
}
