import '../../domain/repositories/debt_repository.dart';
import '../../../../core/api/api_result.dart';

/// Qarzni o'chirish — UseCase
class DeleteDebtUseCase {
  final DebtRepository _repository;

  const DeleteDebtUseCase(this._repository);

  Future<ApiResult<void>> call(String id) {
    return _repository.deleteDebt(id);
  }
}
