import 'package:equatable/equatable.dart';
import '../../domain/entities/debt.dart';

/// Debt eventlar
sealed class DebtEvent extends Equatable {
  const DebtEvent();
  @override
  List<Object?> get props => [];
}

class LoadDebts extends DebtEvent {
  final DebtFilter filter;
  const LoadDebts({this.filter = const DebtFilter()});
  @override
  List<Object?> get props => [filter];
}

class LoadMoreDebts extends DebtEvent {
  const LoadMoreDebts();
}

class RefreshDebts extends DebtEvent {
  const RefreshDebts();
}

class CreateDebtEvent extends DebtEvent {
  final String customerId;
  final List<DebtItem> items;
  final DateTime dueDate;
  final String? note;

  const CreateDebtEvent({
    required this.customerId,
    required this.items,
    required this.dueDate,
    this.note,
  });

  @override
  List<Object?> get props => [customerId, items, dueDate];
}

class DeleteDebtEvent extends DebtEvent {
  final String id;
  const DeleteDebtEvent({required this.id});
  @override
  List<Object?> get props => [id];
}
