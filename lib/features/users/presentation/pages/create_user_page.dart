import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';

class CreateUserPage extends StatefulWidget {
  const CreateUserPage({super.key});

  @override
  State<CreateUserPage> createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController(text: '+998 ');
  final _passwordController = TextEditingController();
  
  String _role = 'seller'; // seller, manager, accountant
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Connect to UserBloc to save employee
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Xodim muvaffaqiyatli qo'shildi")),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Yangi xodim qo'shish"),
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
                "Xodim ma'lumotlari",
                style: AppTextStyles.h3,
              ),
              const SizedBox(height: AppSpacing.lg),
              
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'F.I.Sh.',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Ismni kiriting' : null,
              ),
              const SizedBox(height: AppSpacing.lg),
              
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[\\d+ ]')),
                  LengthLimitingTextInputFormatter(17),
                ],
                decoration: const InputDecoration(
                  labelText: 'Telefon raqami (Login uchun)',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                validator: (val) => val == null || val.trim().length < 9 ? "To'g'ri raqam kiriting" : null,
              ),
              const SizedBox(height: AppSpacing.lg),

              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Parol (Vaqtinchalik)',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: AppColors.textTertiary,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                validator: (val) => val == null || val.trim().length < 6 ? 'Kamida 6 ta belgi kiriting' : null,
              ),
              const SizedBox(height: AppSpacing.lg),
              
              DropdownButtonFormField<String>(
                value: _role,
                decoration: const InputDecoration(
                  labelText: 'Rol',
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
                items: const [
                  DropdownMenuItem(value: 'seller', child: Text('Sotuvchi (Seller)')),
                  DropdownMenuItem(value: 'manager', child: Text('Menejer (Manager)')),
                  DropdownMenuItem(value: 'accountant', child: Text('Buxgalter (Accountant)')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _role = val);
                },
              ),
              const SizedBox(height: AppSpacing.xxl),
              
              SizedBox(
                height: AppSpacing.buttonHeight,
                child: ElevatedButton(
                  onPressed: _onSave,
                  child: const Text('Xodimni Saqlash'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
