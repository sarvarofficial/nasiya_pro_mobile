import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';

class AuditLogsPage extends StatelessWidget {
  const AuditLogsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Audit jurnali (Harakatlar tarixi)'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0.5,
      ),
      body: const Center(
        child: Text("Harakatlar tarixi sahifasi tez orada qo'shiladi"),
      ),
    );
  }
}
