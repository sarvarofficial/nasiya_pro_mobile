import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/auth/auth_bloc.dart';
import '../../../../core/auth/auth_event.dart';
import '../../../../core/auth/auth_state.dart';
import '../../../../core/utils/validators.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../shared/extensions/extensions.dart';

class RegisterOwnerPage extends StatefulWidget {
  const RegisterOwnerPage({super.key});

  @override
  State<RegisterOwnerPage> createState() => _RegisterOwnerPageState();
}

class _RegisterOwnerPageState extends State<RegisterOwnerPage> {
  final _formKey = GlobalKey<FormState>();
  
  final _businessNameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController(text: '+998 ');
  final _passwordController = TextEditingController();

  final _businessNameFocus = FocusNode();
  final _fullNameFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _passwordFocus = FocusNode();
  
  bool _obscurePassword = true;

  @override
  void dispose() {
    _businessNameController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    
    _businessNameFocus.dispose();
    _fullNameFocus.dispose();
    _phoneFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _onRegister() {
    if (_formKey.currentState?.validate() ?? false) {
      final phone = _phoneController.text.replaceAll(RegExp(r'[^\d+]'), '');
      context.read<AuthBloc>().add(AuthRegisterOwnerRequested(
        businessName: _businessNameController.text.trim(),
        fullName: _fullNameController.text.trim(),
        phone: phone,
        password: _passwordController.text,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.go('/login'),
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoginFailure) {
            context.showErrorSnackBar(state.message);
          } else if (state is AuthAuthenticated) {
            context.go('/dashboard');
          }
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.md,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Ro\'yxatdan o\'tish',
                    style: AppTextStyles.h2,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Yangi biznes hisobini yarating',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  
                  _buildForm(),
                  const SizedBox(height: AppSpacing.xl),
                  
                  _buildRegisterButton(),
                  
                  const SizedBox(height: AppSpacing.xl),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Hisobingiz bormi? ',
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                      ),
                      TextButton(
                        onPressed: () => context.go('/login'),
                        child: const Text('Kirish'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _businessNameController,
            focusNode: _businessNameFocus,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Biznes nomi',
              prefixIcon: Icon(Icons.store_outlined),
              hintText: 'Masalan: Ali Med Farm',
            ),
            validator: (value) => 
              value == null || value.trim().isEmpty ? 'Biznes nomini kiriting' : null,
            onFieldSubmitted: (_) => _fullNameFocus.requestFocus(),
          ),
          const SizedBox(height: AppSpacing.lg),

          TextFormField(
            controller: _fullNameController,
            focusNode: _fullNameFocus,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'F.I.Sh',
              prefixIcon: Icon(Icons.person_outline),
              hintText: 'Masalan: Ali Valiyev',
            ),
            validator: (value) => 
              value == null || value.trim().isEmpty ? 'Ism-sharifingizni kiriting' : null,
            onFieldSubmitted: (_) => _phoneFocus.requestFocus(),
          ),
          const SizedBox(height: AppSpacing.lg),

          TextFormField(
            controller: _phoneController,
            focusNode: _phoneFocus,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[\d+ ]')),
              LengthLimitingTextInputFormatter(17),
            ],
            decoration: const InputDecoration(
              labelText: 'Telefon raqam',
              prefixIcon: Icon(Icons.phone_outlined),
              hintText: '+998 90 123 45 67',
            ),
            validator: AppValidators.phone,
            onFieldSubmitted: (_) => _passwordFocus.requestFocus(),
          ),
          const SizedBox(height: AppSpacing.lg),

          TextFormField(
            controller: _passwordController,
            focusNode: _passwordFocus,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: 'Parol',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: AppColors.textTertiary,
                ),
                onPressed: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
              ),
            ),
            validator: AppValidators.password,
            onFieldSubmitted: (_) => _onRegister(),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterButton() {
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (prev, curr) =>
          curr is AuthLoginInProgress ||
          curr is AuthLoginFailure ||
          curr is AuthAuthenticated,
      builder: (context, state) {
        final isLoading = state is AuthLoginInProgress;

        return SizedBox(
          height: AppSpacing.buttonHeight,
          child: ElevatedButton(
            onPressed: isLoading ? null : _onRegister,
            child: isLoading
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                : const Text('Ro\'yxatdan o\'tish'),
          ),
        );
      },
    );
  }
}
