import 'package:flutter/material.dart';
import 'package:nasiya_pro/app/theme/app_colors.dart';
import 'package:nasiya_pro/app/theme/app_spacing.dart';

/// BuildContext extensionlari — UI convenience methods
extension BuildContextExtension on BuildContext {
  // ─── Theme ───
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;
  bool get isDark => theme.brightness == Brightness.dark;

  // ─── Screen ───
  Size get screenSize => MediaQuery.sizeOf(this);
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
  EdgeInsets get padding => MediaQuery.paddingOf(this);
  double get bottomPadding => padding.bottom;

  // ─── Responsive ───
  bool get isMobile => screenWidth < 600;
  bool get isTablet => screenWidth >= 600 && screenWidth < 1024;
  bool get isDesktop => screenWidth >= 1024;

  // ─── Snackbar ───
  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(AppSpacing.lg),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(AppSpacing.lg),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void showWarningSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning_amber, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.warning,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(AppSpacing.lg),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

/// String extensionlar
extension StringExtension on String {
  /// "alisher karimov" → "AK"
  String get initials {
    final parts = trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  /// Birinchi harfni katta qilish
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Status nomini o'zbek tiliga tarjima qilish
  String get statusLabel {
    return switch (this) {
      'active' => 'Faol',
      'overdue' => 'Muddati o\'tgan',
      'partial' => 'Qisman to\'langan',
      'paid' => 'To\'langan',
      'written_off' => 'Hisobdan chiqarilgan',
      _ => capitalize,
    };
  }

  /// Payment method nomini tarjima
  String get paymentMethodLabel {
    return switch (this) {
      'cash' => 'Naqd',
      'card' => 'Karta',
      'transfer' => 'O\'tkazma',
      _ => capitalize,
    };
  }

  /// Role nomini tarjima
  String get roleLabel {
    return switch (this) {
      'owner' => 'Egasi',
      'manager' => 'Menejer',
      'seller' => 'Sotuvchi',
      'accountant' => 'Buxgalter',
      'super_admin' => 'Super Admin',
      _ => capitalize,
    };
  }
}
