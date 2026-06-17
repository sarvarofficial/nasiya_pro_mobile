import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';

class CreatePaymentPage extends StatefulWidget {
  const CreatePaymentPage({super.key});

  @override
  State<CreatePaymentPage> createState() => _CreatePaymentPageState();
}

class _CreatePaymentPageState extends State<CreatePaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  
  String _paymentMethod = 'naqd'; // naqd, karta, o'tkazma
  
  // As a real MVP, we'd pick a customer/debt. For now, simple form to mock the structure.
  
  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Connect to PaymentBloc to save payment
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("To'lov qabul qilindi")),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("To'lov qabul qilish"),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0.5,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              Text(
                "To'lov tafsilotlari",
                style: AppTextStyles.h3,
              ),
              const SizedBox(height: AppSpacing.lg),
              
              // Summa kiritish
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\\d+\\.?\\d*')),
                ],
                decoration: const InputDecoration(
                  labelText: 'Summa',
                  prefixIcon: Icon(Icons.attach_money),
                  suffixText: "so'm",
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Summani kiriting';
                  if (double.tryParse(val) == null || double.parse(val) <= 0) {
                    return "Noto'g'ri summa";
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              
              // To'lov turi
              DropdownButtonFormField<String>(
                value: _paymentMethod,
                decoration: const InputDecoration(
                  labelText: "To'lov usuli",
                  prefixIcon: Icon(Icons.payment),
                ),
                items: const [
                  DropdownMenuItem(value: 'naqd', child: Text('Naqd pul')),
                  DropdownMenuItem(value: 'karta', child: Text('Plastik karta (Terminal)')),
                  DropdownMenuItem(value: 'otkazma', child: Text("Pul o'tkazish (Click/Payme)")),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _paymentMethod = val);
                  }
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              
              // Izoh
              TextFormField(
                controller: _noteController,
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Izoh (Ixtiyoriy)',
                  prefixIcon: Icon(Icons.note_outlined),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              
              SizedBox(
                height: AppSpacing.buttonHeight,
                child: ElevatedButton(
                  onPressed: _onSave,
                  child: const Text('Saqlash va Tasdiqlash'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
