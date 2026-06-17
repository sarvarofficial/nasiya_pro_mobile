import '../../domain/entities/debt.dart';
import '../../domain/repositories/debt_repository.dart';
import '../../../../core/api/api_result.dart';

/// Bitta qarzni olish — UseCase
class GetDebtDetailUseCase {
  final DebtRepository _repository;

  const GetDebtDetailUseCase(this._repository);

  Future<ApiResult<Debt>> call(String id) {
    return _repository.getDebt(id);
  }
}
