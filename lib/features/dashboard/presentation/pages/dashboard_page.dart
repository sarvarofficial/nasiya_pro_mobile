import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// Bosh sahifa — umumiy statistika
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nasiya Pro', style: AppTextStyles.h4),
            Text(
              'Bosh sahifa',
              style: AppTextStyles.caption,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications_outlined),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // TODO: Refresh dashboard data
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Overview cards
              _buildOverviewCards(context),
              const SizedBox(height: AppSpacing.xl),

              // Quick actions
              Text('Tez amallar', style: AppTextStyles.h4),
              const SizedBox(height: AppSpacing.md),
              _buildQuickActions(context),
              const SizedBox(height: AppSpacing.xl),

              // Overdue alert
              _buildOverdueAlert(context),
              const SizedBox(height: AppSpacing.xl),

              // Recent debts
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('So\'nggi qarzlar', style: AppTextStyles.h4),
                  TextButton(
                    onPressed: () => context.go('/debts'),
                    child: const Text('Barchasi'),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildRecentDebtsPlaceholder(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewCards(BuildContext context) {
    return Column(
      children: [
        // Main stat card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Umumiy qoldiq',
                style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
              ),
              const SizedBox(height: 8),
              Text(
                '0 UZS',
                style: AppTextStyles.amountLarge.copyWith(color: Colors.white),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  _MiniStat(label: 'Faol', value: '0', color: Colors.white),
                  const SizedBox(width: AppSpacing.xl),
                  _MiniStat(label: 'Muddati o\'tgan', value: '0', color: AppColors.partial),
                  const SizedBox(width: AppSpacing.xl),
                  _MiniStat(label: 'To\'langan', value: '0', color: AppColors.paid),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Sub stat cards
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.trending_up,
                iconColor: AppColors.success,
                label: 'Bugun yig\'ilgan',
                value: '0 UZS',
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _StatCard(
                icon: Icons.people_outline,
                iconColor: AppColors.secondary,
                label: 'Mijozlar',
                value: '0',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickAction(
            icon: Icons.add_circle_outline,
            label: 'Yangi qarz',
            color: AppColors.primary,
            onTap: () => context.push('/debts/create'),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _QuickAction(
            icon: Icons.payments_outlined,
            label: 'To\'lov olish',
            color: AppColors.secondary,
            onTap: () => context.go('/payments'),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _QuickAction(
            icon: Icons.person_add_outlined,
            label: 'Yangi mijoz',
            color: AppColors.accent,
            onTap: () => context.go('/customers'),
          ),
        ),
      ],
    );
  }

  Widget _buildOverdueAlert(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.overdue.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: AppColors.overdue.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.overdue.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.warning_amber, color: AppColors.overdue, size: 24),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Muddati o\'tgan qarzlar',
                  style: AppTextStyles.labelMedium.copyWith(color: AppColors.overdue),
                ),
                const SizedBox(height: 2),
                Text(
                  '0 ta qarzning muddati o\'tgan',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.overdue),
        ],
      ),
    );
  }

  Widget _buildRecentDebtsPlaceholder() {
    return const EmptyState(
      icon: Icons.receipt_long_outlined,
      title: 'Hali qarzlar yo\'q',
      subtitle: 'Birinchi qarzni yarating',
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _MiniStat({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: AppTextStyles.labelLarge.copyWith(color: color)),
        Text(label, style: AppTextStyles.caption.copyWith(color: Colors.white60)),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  const _StatCard({required this.icon, required this.iconColor, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
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
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(value, style: AppTextStyles.labelLarge),
          const SizedBox(height: 2),
          Text(label, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _QuickAction({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTextStyles.chip.copyWith(color: color),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
