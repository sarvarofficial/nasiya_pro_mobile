import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../shared/widgets/widgets.dart';

/// Mijozlar ro'yxati
class CustomerListPage extends StatelessWidget {
  const CustomerListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Mijozlar'),
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),
      body: const EmptyState(
        icon: Icons.people_outline,
        title: 'Mijozlar yo\'q',
        subtitle: 'Yangi mijoz qo\'shing',
        actionText: 'Mijoz qo\'shish',
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/customers/create');
        },
        child: const Icon(Icons.person_add),
      ),
    );
  }
}

/// Mijoz tafsilotlari
class CustomerDetailPage extends StatelessWidget {
  final String id;
  const CustomerDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Mijoz tafsiloti')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        child: Column(
          children: [
            // Profile card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  const CustomerAvatar(name: 'Mijoz', size: 64),
                  const SizedBox(height: AppSpacing.md),
                  Text('Mijoz ismi', style: AppTextStyles.h3),
                  const SizedBox(height: 4),
                  Text('+998 90 123 45 67', style: AppTextStyles.bodySmall),
                  const SizedBox(height: AppSpacing.lg),

                  // Trust score
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.verified,
                        color: AppColors.success,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Ishonch balli: 100',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Stats
            Row(
              children: [
                _CustomerStat(label: 'Jami qarzlar', value: '0'),
                const SizedBox(width: AppSpacing.md),
                _CustomerStat(label: 'Faol', value: '0'),
                const SizedBox(width: AppSpacing.md),
                _CustomerStat(label: 'Muddati o\'tgan', value: '0'),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            // Debts
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Qarzlar tarixi', style: AppTextStyles.h4),
            ),
            const SizedBox(height: AppSpacing.md),
            const EmptyState(
              icon: Icons.receipt_long_outlined,
              title: 'Qarzlar yo\'q',
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomerStat extends StatelessWidget {
  final String label;
  final String value;
  const _CustomerStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Text(value, style: AppTextStyles.h3),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.caption,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
