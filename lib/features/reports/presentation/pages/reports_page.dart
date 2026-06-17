import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Hisobotlar'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0.5,
      ),
      body: const Center(
        child: Text("Hisobotlar sahifasi tez orada qo'shiladi"),
      ),
    );
  }
}
