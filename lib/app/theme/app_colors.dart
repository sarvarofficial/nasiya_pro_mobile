import 'package:flutter/material.dart';

/// Nasiya Pro color palette
/// Spec bo'yicha — status, role, va UI ranglar
class AppColors {
  AppColors._();

  // ─── Brand ───
  static const primary = Color(0xFF1D9E75);
  static const primaryLight = Color(0xFF2BC48F);
  static const primaryDark = Color(0xFF157A5A);
  static const secondary = Color(0xFF378ADD);
  static const accent = Color(0xFF7F77DD);

  // ─── Status Colors ───
  static const active = Color(0xFF1D9E75);
  static const overdue = Color(0xFFE24B4A);
  static const partial = Color(0xFFEF9F27);
  static const paid = Color(0xFF639922);
  static const writtenOff = Color(0xFF8E8E93);

  // ─── Role Colors (avatar background) ───
  static const owner = Color(0xFF1D9E75);
  static const manager = Color(0xFF378ADD);
  static const seller = Color(0xFF7F77DD);
  static const accountant = Color(0xFFD85A30);

  // ─── Severity Colors ───
  static const info = Color(0xFF378ADD);
  static const warning = Color(0xFFEF9F27);
  static const critical = Color(0xFFE24B4A);

  // ─── Neutral (Light Theme) ───
  static const background = Color(0xFFF5F6FA);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceVariant = Color(0xFFF0F1F5);
  static const border = Color(0xFFE2E4EA);
  static const divider = Color(0xFFEEEFF3);

  // ─── Neutral (Dark Theme) ───
  static const darkBackground = Color(0xFF0F1117);
  static const darkSurface = Color(0xFF1A1D27);
  static const darkSurfaceVariant = Color(0xFF242735);
  static const darkBorder = Color(0xFF2E3142);
  static const darkDivider = Color(0xFF2E3142);

  // ─── Text ───
  static const textPrimary = Color(0xFF1A1D27);
  static const textSecondary = Color(0xFF6B7080);
  static const textTertiary = Color(0xFF9DA3B0);
  static const textOnPrimary = Color(0xFFFFFFFF);
  static const textOnDark = Color(0xFFF0F1F5);

  // ─── Misc ───
  static const error = Color(0xFFE24B4A);
  static const success = Color(0xFF1D9E75);
  static const shadow = Color(0x0F1A1D27);
  static const shimmerBase = Color(0xFFE2E4EA);
  static const shimmerHighlight = Color(0xFFF0F1F5);

  /// Status rangini qaytaradi
  static Color statusColor(String status) {
    return switch (status) {
      'active' => active,
      'overdue' => overdue,
      'partial' => partial,
      'paid' => paid,
      'written_off' => writtenOff,
      _ => textSecondary,
    };
  }

  /// Role rangini qaytaradi
  static Color roleColor(String role) {
    return switch (role) {
      'owner' => owner,
      'manager' => manager,
      'seller' => seller,
      'accountant' => accountant,
      _ => textSecondary,
    };
  }
}
