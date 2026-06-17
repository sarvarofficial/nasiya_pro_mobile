import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../domain/entities/debt.dart';

/// DebtCard — asosiy list item widget
class DebtCard extends StatelessWidget {
  final Debt debt;
  final VoidCallback onTap;
  final VoidCallback? onPayTap;

  const DebtCard({
    super.key,
    required this.debt,
    required this.onTap,
    this.onPayTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Customer + Status
            Row(
              children: [
                CustomerAvatar(name: debt.customerName, size: 40),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        debt.customerName,
                        style: AppTextStyles.labelMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        AppFormatters.formatDebtNumber(debt.debtNumber),
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
                StatusBadge(status: debt.status),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Amount row
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Umumiy', style: AppTextStyles.caption),
                      const SizedBox(height: 2),
                      AmountDisplay(
                        amount: debt.totalAmount,
                        style: AppTextStyles.labelLarge,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Qoldiq', style: AppTextStyles.caption),
                      const SizedBox(height: 2),
                      AmountDisplay(
                        amount: debt.remainingAmount,
                        type: debt.remainingAmount > 0
                            ? AmountType.debt
                            : AmountType.payment,
                        style: AppTextStyles.labelLarge,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: debt.paidRatio,
                backgroundColor: AppColors.surfaceVariant,
                valueColor: AlwaysStoppedAnimation(
                  AppColors.statusColor(debt.status),
                ),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            // Footer: Due date + Pay button
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 14,
                  color: _dueDateColor,
                ),
                const SizedBox(width: 4),
                Text(
                  AppFormatters.formatRelative(debt.dueDate),
                  style: AppTextStyles.caption.copyWith(color: _dueDateColor),
                ),
                const Spacer(),
                if (onPayTap != null && !debt.isPaid)
                  _PayButton(onTap: onPayTap!),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color get _dueDateColor {
    final status = AppFormatters.formatDueStatus(debt.dueDate);
    return switch (status) {
      'overdue' => AppColors.overdue,
      'today' => AppColors.warning,
      'soon' => AppColors.partial,
      _ => AppColors.textTertiary,
    };
  }
}

class _PayButton extends StatelessWidget {
  final VoidCallback onTap;
  const _PayButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.payments_outlined, size: 16, color: AppColors.primary),
            const SizedBox(width: 4),
            Text(
              'To\'lash',
              style: AppTextStyles.chip.copyWith(color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
