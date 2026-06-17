import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasiya_pro/features/debts/domain/entities/debt.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../shared/widgets/widgets.dart';
import '../bloc/debt_bloc.dart';
import '../bloc/debt_event.dart';
import '../bloc/debt_state.dart';
import '../widgets/debt_card.dart';
import 'package:go_router/go_router.dart';

/// Qarzlar ro'yxati sahifasi
class DebtListPage extends StatefulWidget {
  const DebtListPage({super.key});

  @override
  State<DebtListPage> createState() => _DebtListPageState();
}

class _DebtListPageState extends State<DebtListPage> {
  final _scrollController = ScrollController();
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<DebtBloc>().add(const LoadMoreDebts());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Qarzlar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Search
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          // Status filter chips
          _buildFilterChips(),

          // Debt list
          Expanded(
            child: BlocBuilder<DebtBloc, DebtState>(
              builder: (context, state) {
                if (state is DebtLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is DebtError) {
                  return EmptyState(
                    icon: Icons.error_outline,
                    title: 'Xatolik yuz berdi',
                    subtitle: state.message,
                    actionText: 'Qayta urinish',
                    onAction: () =>
                        context.read<DebtBloc>().add(const RefreshDebts()),
                  );
                }

                if (state is DebtLoaded) {
                  if (state.debts.isEmpty) {
                    return EmptyState(
                      icon: Icons.receipt_long_outlined,
                      title: 'Qarzlar yo\'q',
                      subtitle: 'Yangi qarz qo\'shish uchun + tugmasini bosing',
                      actionText: 'Qarz qo\'shish',
                      onAction: () => context.push('/debts/create'),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<DebtBloc>().add(const RefreshDebts());
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(AppSpacing.pagePadding),
                      itemCount:
                          state.debts.length + (state.isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= state.debts.length) {
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        }
                        final debt = state.debts[index];
                        return DebtCard(
                          debt: debt,
                          onTap: () => context.push('/debts/${debt.id}'),
                          onPayTap: () {
                            // TODO: Navigate to payment page
                          },
                        );
                      },
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/debts/create'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilterChips() {
    final statuses = [
      (null, 'Barchasi'),
      ('active', 'Faol'),
      ('overdue', 'Muddati o\'tgan'),
      ('partial', 'Qisman'),
      ('paid', 'To\'langan'),
    ];

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
        itemCount: statuses.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final (status, label) = statuses[index];
          final isSelected = _selectedStatus == status;

          return FilterChip(
            label: Text(label),
            selected: isSelected,
            onSelected: (_) {
              setState(() => _selectedStatus = status);
              context.read<DebtBloc>().add(
                LoadDebts(filter: DebtFilter(status: status)),
              );
            },
            selectedColor: AppColors.primary.withValues(alpha: 0.15),
            checkmarkColor: AppColors.primary,
            labelStyle: AppTextStyles.chip.copyWith(
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
          );
        },
      ),
    );
  }

  void _showFilterSheet() {
    // TODO: Bottom sheet with advanced filters
  }
}
