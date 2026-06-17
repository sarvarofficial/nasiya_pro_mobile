import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../shared/widgets/widgets.dart';

/// Qarz tafsilotlari sahifasi
class DebtDetailPage extends StatelessWidget {
  final String id;

  const DebtDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    // TODO: BlocProvider bilan real data olish
    // Hozircha placeholder UI
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Qarz tafsiloti'),
        actions: [
          IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () {}),
          PopupMenuButton(
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_outline,
                      color: AppColors.error,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text('O\'chirish'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card
            _buildHeaderCard(context),
            const SizedBox(height: AppSpacing.lg),

            // Amount details
            _buildAmountCard(context),
            const SizedBox(height: AppSpacing.lg),

            // Items
            _buildItemsCard(context),
            const SizedBox(height: AppSpacing.lg),

            // Payment history section title
            Text('To\'lovlar tarixi', style: AppTextStyles.h4),
            const SizedBox(height: AppSpacing.md),
            _buildPaymentPlaceholder(),
            const SizedBox(height: AppSpacing.xl),

            // Pay button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.payments_outlined),
                label: const Text('To\'lov qilish'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CustomerAvatar(name: 'Mijoz ismi', size: 52),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Mijoz ismi', style: AppTextStyles.h4),
                    const SizedBox(height: 4),
                    Text('#DBT-2026-00001', style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
              const StatusBadge(status: 'active', large: true),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              _InfoItem(
                icon: Icons.calendar_today_outlined,
                label: 'Muddat',
                value: '30.05.2026',
              ),
              _InfoItem(
                icon: Icons.person_outline,
                label: 'Yaratuvchi',
                value: 'Sotuvchi',
              ),
              _InfoItem(
                icon: Icons.access_time,
                label: 'Yaratilgan',
                value: '23.04.2026',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAmountCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Umumiy qarz',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '5,000,000 UZS',
                    style: AppTextStyles.amountLarge.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: 0.4,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation(Colors.white),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'To\'langan: 2,000,000 UZS',
                style: AppTextStyles.caption.copyWith(color: Colors.white70),
              ),
              Text(
                'Qoldiq: 3,000,000 UZS',
                style: AppTextStyles.caption.copyWith(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItemsCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Mahsulotlar', style: AppTextStyles.labelMedium),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Hali mahsulotlar qo\'shilmagan',
            style: AppTextStyles.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentPlaceholder() {
    return const EmptyState(
      icon: Icons.payment_outlined,
      title: 'To\'lovlar yo\'q',
      subtitle: 'Hali to\'lov qilinmagan',
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 18, color: AppColors.textTertiary),
          const SizedBox(height: 4),
          Text(label, style: AppTextStyles.caption),
          const SizedBox(height: 2),
          Text(value, style: AppTextStyles.labelSmall),
        ],
      ),
    );
  }
}
