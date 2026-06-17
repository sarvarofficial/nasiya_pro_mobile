import 'package:equatable/equatable.dart';
import '../../domain/entities/debt.dart';

/// Debt state
sealed class DebtState extends Equatable {
  const DebtState();
  @override
  List<Object?> get props => [];
}

class DebtInitial extends DebtState {
  const DebtInitial();
}

class DebtLoading extends DebtState {
  const DebtLoading();
}

class DebtLoaded extends DebtState {
  final List<Debt> debts;
  final DebtStats stats;
  final DebtFilter filter;
  final bool hasMore;
  final bool isLoadingMore;

  const DebtLoaded({
    required this.debts,
    this.stats = const DebtStats(),
    this.filter = const DebtFilter(),
    this.hasMore = true,
    this.isLoadingMore = false,
  });

  DebtLoaded copyWith({
    List<Debt>? debts,
    DebtStats? stats,
    DebtFilter? filter,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return DebtLoaded(
      debts: debts ?? this.debts,
      stats: stats ?? this.stats,
      filter: filter ?? this.filter,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [debts, stats, filter, hasMore, isLoadingMore];
}

class DebtError extends DebtState {
  final String message;
  const DebtError({required this.message});
  @override
  List<Object?> get props => [message];
}

class DebtCreating extends DebtState {
  const DebtCreating();
}

class DebtCreated extends DebtState {
  final Debt debt;
  const DebtCreated({required this.debt});
  @override
  List<Object?> get props => [debt];
}
