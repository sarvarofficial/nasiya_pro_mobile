import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/debt.dart';
import '../../domain/repositories/debt_repository.dart';
import '../../domain/usecases/get_debts_usecase.dart';
import '../../domain/usecases/get_debt_stats_usecase.dart';
import '../../domain/usecases/create_debt_usecase.dart';
import '../../domain/usecases/delete_debt_usecase.dart';
import 'debt_event.dart';
import 'debt_state.dart';

/// DebtBloc — qarzlar boshqaruvchisi (UseCase orqali)
class DebtBloc extends Bloc<DebtEvent, DebtState> {
  final GetDebtsUseCase _getDebts;
  final GetDebtStatsUseCase _getStats;
  final CreateDebtUseCase _createDebt;
  final DeleteDebtUseCase _deleteDebt;

  DebtFilter _currentFilter = const DebtFilter();

  DebtBloc({
    required GetDebtsUseCase getDebts,
    required GetDebtStatsUseCase getStats,
    required CreateDebtUseCase createDebt,
    required DeleteDebtUseCase deleteDebt,
  })  : _getDebts = getDebts,
        _getStats = getStats,
        _createDebt = createDebt,
        _deleteDebt = deleteDebt,
        super(const DebtInitial()) {
    on<LoadDebts>(_onLoadDebts);
    on<LoadMoreDebts>(_onLoadMoreDebts);
    on<RefreshDebts>(_onRefreshDebts);
    on<CreateDebtEvent>(_onCreateDebt);
    on<DeleteDebtEvent>(_onDeleteDebt);
  }

  Future<void> _onLoadDebts(LoadDebts event, Emitter<DebtState> emit) async {
    emit(const DebtLoading());
    _currentFilter = event.filter;
    try {
      final result = await _getDebts(_currentFilter);
      final statsResult = await _getStats();

      result.when(
        success: (debts) {
          final stats = statsResult.dataOrNull ?? const DebtStats();
          emit(DebtLoaded(
            debts: debts,
            stats: stats,
            filter: _currentFilter,
            hasMore: debts.length >= _currentFilter.limit,
          ));
        },
        failure: (error) => emit(DebtError(message: error.message)),
      );
    } catch (e) {
      emit(DebtError(message: e.toString()));
    }
  }

  Future<void> _onLoadMoreDebts(
      LoadMoreDebts event, Emitter<DebtState> emit) async {
    final currentState = state;
    if (currentState is! DebtLoaded ||
        !currentState.hasMore ||
        currentState.isLoadingMore) {
      return;
    }

    emit(currentState.copyWith(isLoadingMore: true));
    _currentFilter = _currentFilter.copyWith(page: _currentFilter.page + 1);

    try {
      final result = await _getDebts(_currentFilter);
      result.when(
        success: (newDebts) {
          emit(currentState.copyWith(
            debts: [...currentState.debts, ...newDebts],
            filter: _currentFilter,
            hasMore: newDebts.length >= _currentFilter.limit,
            isLoadingMore: false,
          ));
        },
        failure: (_) => emit(currentState.copyWith(isLoadingMore: false)),
      );
    } catch (e) {
      emit(currentState.copyWith(isLoadingMore: false));
    }
  }

  Future<void> _onRefreshDebts(
      RefreshDebts event, Emitter<DebtState> emit) async {
    _currentFilter = _currentFilter.copyWith(page: 1);
    add(LoadDebts(filter: _currentFilter));
  }

  Future<void> _onCreateDebt(
      CreateDebtEvent event, Emitter<DebtState> emit) async {
    emit(const DebtCreating());
    try {
      final dto = CreateDebtDto(
        customerId: event.customerId,
        items: event.items,
        dueDate: event.dueDate,
        note: event.note,
      );
      final result = await _createDebt(dto);
      result.when(
        success: (debt) => emit(DebtCreated(debt: debt)),
        failure: (error) => emit(DebtError(message: error.message)),
      );
    } catch (e) {
      emit(DebtError(message: e.toString()));
    }
  }

  Future<void> _onDeleteDebt(
      DeleteDebtEvent event, Emitter<DebtState> emit) async {
    try {
      final result = await _deleteDebt(event.id);
      result.when(
        success: (_) => add(const RefreshDebts()),
        failure: (error) => emit(DebtError(message: error.message)),
      );
    } catch (e) {
      emit(DebtError(message: e.toString()));
    }
  }
}
