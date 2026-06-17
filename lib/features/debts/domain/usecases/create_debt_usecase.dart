import '../../domain/entities/debt.dart';
import '../../domain/repositories/debt_repository.dart';
import '../../../../core/api/api_result.dart';

/// Yangi qarz yaratish — UseCase
class CreateDebtUseCase {
  final DebtRepository _repository;

  const CreateDebtUseCase(this._repository);

  Future<ApiResult<Debt>> call(CreateDebtDto dto) {
    return _repository.createDebt(dto);
  }
}
