import '../../domain/entities/debt.dart';
import '../../domain/repositories/debt_repository.dart';
import '../../../../core/api/api_result.dart';

/// Qarzlar ro'yxatini olish — UseCase
class GetDebtsUseCase {
  final DebtRepository _repository;

  const GetDebtsUseCase(this._repository);

  Future<ApiResult<List<Debt>>> call(DebtFilter filter) {
    return _repository.getDebts(filter);
  }
}
