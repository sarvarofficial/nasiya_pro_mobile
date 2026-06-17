import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';

class OverdueDebtsPage extends StatelessWidget {
  const OverdueDebtsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Muddati o'tgan qarzlar"),
        backgroundColor: AppColors.error,
        foregroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: const Center(
        child: Text("Muddati o'tgan qarzlar ro'yxati tez orada qo'shiladi"),
      ),
    );
  }
}
