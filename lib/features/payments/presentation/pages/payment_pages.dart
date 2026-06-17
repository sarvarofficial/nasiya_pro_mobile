import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../shared/widgets/widgets.dart';

/// To'lovlar ro'yxati sahifasi
class PaymentListPage extends StatelessWidget {
  const PaymentListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('To\'lovlar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),
      body: const EmptyState(
        icon: Icons.payment_outlined,
        title: 'To\'lovlar yo\'q',
        subtitle: 'Qarz sahifasidan to\'lov qo\'shing',
      ),
    );
  }
}

/// To'lov qo'shish sahifasi
class AddPaymentPage extends StatefulWidget {
  final String? debtId;

  const AddPaymentPage({super.key, this.debtId});

  @override
  State<AddPaymentPage> createState() => _AddPaymentPageState();
}

class _AddPaymentPageState extends State<AddPaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  String _selectedMethod = 'cash';

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final methods = [
      ('cash', 'Naqd', Icons.money),
      ('card', 'Karta', Icons.credit_card),
      ('transfer', 'O\'tkazma', Icons.send),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('To\'lov qilish')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          children: [
            // Amount
            Text('Miqdor', style: AppTextStyles.labelMedium),
            const SizedBox(height: AppSpacing.sm),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              style: AppTextStyles.amountLarge,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: '0',
                hintStyle: AppTextStyles.amountLarge.copyWith(
                  color: AppColors.textTertiary,
                ),
                suffixText: 'UZS',
                suffixStyle: AppTextStyles.h4.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Miqdorni kiriting';
                final amount = double.tryParse(v.replaceAll(',', ''));
                if (amount == null || amount <= 0) return 'To\'g\'ri miqdor kiriting';
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.xl),

            // Payment method
            Text('To\'lov usuli', style: AppTextStyles.labelMedium),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: methods.map((m) {
                final (value, label, icon) = m;
                final isSelected = _selectedMethod == value;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedMethod = value),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: EdgeInsets.only(
                        right: value != 'transfer' ? AppSpacing.sm : 0,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withValues(alpha: 0.1)
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : AppColors.border,
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(icon, color: isSelected ? AppColors.primary : AppColors.textTertiary),
                          const SizedBox(height: 6),
                          Text(
                            label,
                            style: AppTextStyles.chip.copyWith(
                              color: isSelected ? AppColors.primary : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.xxl),

            // Submit
            ElevatedButton(
              onPressed: _onSubmit,
              child: const Text('To\'lovni tasdiqlash'),
            ),
          ],
        ),
      ),
    );
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Submit payment via bloc
    }
  }
}
