import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';

/// Yangi qarz yaratish sahifasi
class CreateDebtPage extends StatefulWidget {
  const CreateDebtPage({super.key});

  @override
  State<CreateDebtPage> createState() => _CreateDebtPageState();
}

class _CreateDebtPageState extends State<CreateDebtPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedCustomerId;
  DateTime? _dueDate;
  final _noteController = TextEditingController();
  final List<_ItemEntry> _items = [_ItemEntry()];

  @override
  void dispose() {
    _noteController.dispose();
    for (final item in _items) {
      item.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Yangi qarz'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          children: [
            // Customer selection
            _buildSection(
              title: 'Mijoz',
              child: _buildCustomerSelector(),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Items
            _buildSection(
              title: 'Mahsulotlar',
              child: _buildItemsList(),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Due date
            _buildSection(
              title: 'Muddat',
              child: _buildDatePicker(),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Note
            _buildSection(
              title: 'Izoh (ixtiyoriy)',
              child: TextFormField(
                controller: _noteController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Qo\'shimcha ma\'lumot...',
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),

            // Total
            _buildTotal(),
            const SizedBox(height: AppSpacing.lg),

            // Submit button
            ElevatedButton(
              onPressed: _onSubmit,
              child: const Text('Qarz yaratish'),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.labelMedium),
        const SizedBox(height: AppSpacing.sm),
        child,
      ],
    );
  }

  Widget _buildCustomerSelector() {
    return InkWell(
      onTap: () {
        // TODO: Customer search/select dialog
      },
      borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(
              Icons.person_search_outlined,
              color: _selectedCustomerId != null
                  ? AppColors.primary
                  : AppColors.textTertiary,
            ),
            const SizedBox(width: 12),
            Text(
              _selectedCustomerId != null ? 'Mijoz tanlangan' : 'Mijozni tanlang',
              style: AppTextStyles.bodyMedium.copyWith(
                color: _selectedCustomerId != null
                    ? AppColors.textPrimary
                    : AppColors.textTertiary,
              ),
            ),
            const Spacer(),
            const Icon(Icons.chevron_right, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsList() {
    return Column(
      children: [
        ...List.generate(_items.length, (index) {
          return Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                TextFormField(
                  controller: _items[index].productController,
                  decoration: const InputDecoration(
                    labelText: 'Mahsulot nomi',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  validator: (v) => v?.isEmpty == true ? 'Kiriting' : null,
                ),
                const Divider(),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _items[index].qtyController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Soni',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        validator: (v) => v?.isEmpty == true ? 'Kiriting' : null,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: TextFormField(
                        controller: _items[index].priceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Narxi (so\'m)',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        validator: (v) => v?.isEmpty == true ? 'Kiriting' : null,
                      ),
                    ),
                    if (_items.length > 1)
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        color: AppColors.error,
                        onPressed: () => setState(() => _items.removeAt(index)),
                      ),
                  ],
                ),
              ],
            ),
          );
        }),
        TextButton.icon(
          onPressed: () => setState(() => _items.add(_ItemEntry())),
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Mahsulot qo\'shish'),
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now().add(const Duration(days: 30)),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (date != null) setState(() => _dueDate = date);
      },
      borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              color: _dueDate != null ? AppColors.primary : AppColors.textTertiary,
            ),
            const SizedBox(width: 12),
            Text(
              _dueDate != null
                  ? '${_dueDate!.day}.${_dueDate!.month.toString().padLeft(2, '0')}.${_dueDate!.year}'
                  : 'Muddatni tanlang',
              style: AppTextStyles.bodyMedium.copyWith(
                color: _dueDate != null ? AppColors.textPrimary : AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotal() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Jami:', style: AppTextStyles.h4),
          Text(
            '0 UZS',
            style: AppTextStyles.h3.copyWith(color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Create debt via bloc
    }
  }
}

/// Helper class for item entry controllers
class _ItemEntry {
  final productController = TextEditingController();
  final qtyController = TextEditingController();
  final priceController = TextEditingController();

  void dispose() {
    productController.dispose();
    qtyController.dispose();
    priceController.dispose();
  }
}
