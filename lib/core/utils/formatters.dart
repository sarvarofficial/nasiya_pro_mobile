import 'package:intl/intl.dart';

/// Currency va sana formatlash
/// 
/// Spec rule: Har doim shu formatterlar ishlatiladi
class AppFormatters {
  AppFormatters._();

  static final _amountFormat = NumberFormat('#,##0', 'uz');
  static final _dateFormat = DateFormat('dd.MM.yyyy');
  static final _dateTimeFormat = DateFormat('dd.MM.yyyy HH:mm');
  static final _timeFormat = DateFormat('HH:mm');

  // ─── Amount ───

  /// Pul miqdorini formatlash: 1250000 → "1,250,000 UZS"
  static String formatAmount(int amountInTiyin) {
    final amount = amountInTiyin / 100;
    return '${_amountFormat.format(amount)} UZS';
  }

  /// Qisqartirilgan pul: 1250000 → "1.25M"
  static String formatAmountShort(int amountInTiyin) {
    final amount = amountInTiyin / 100;
    if (amount >= 1000000000) {
      return '${(amount / 1000000000).toStringAsFixed(1)}B';
    } else if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return _amountFormat.format(amount);
  }

  /// Faqat raqam: 1250000 → "1,250,000"
  static String formatNumber(num number) {
    return _amountFormat.format(number);
  }

  // ─── Date ───

  /// Sana: 23.04.2026
  static String formatDate(DateTime date) {
    return _dateFormat.format(date);
  }

  /// Sana + vaqt: 23.04.2026 14:30
  static String formatDateTime(DateTime dt) {
    return _dateTimeFormat.format(dt);
  }

  /// Faqat vaqt: 14:30
  static String formatTime(DateTime dt) {
    return _timeFormat.format(dt);
  }

  /// Nisbiy sana: "Bugun", "Ertaga", "3 kun qoldi", "2 kun oldin"
  static String formatRelative(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final diff = target.difference(today).inDays;

    if (diff == 0) return 'Bugun';
    if (diff == 1) return 'Ertaga';
    if (diff == -1) return 'Kecha';
    if (diff < -1) return '${diff.abs()} kun oldin';
    return '$diff kun qoldi';
  }

  /// Nisbiy sana rangini qaytaradi (overdue=red, today=amber, coming=green)
  static String formatDueStatus(DateTime dueDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(dueDate.year, dueDate.month, dueDate.day);
    final diff = target.difference(today).inDays;

    if (diff < 0) return 'overdue';
    if (diff == 0) return 'today';
    if (diff <= 3) return 'soon';
    return 'normal';
  }

  // ─── Phone ───

  /// Telefon raqamini formatlash: +998901234567
  static String formatPhone(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'[^\d+]'), '');
    if (cleaned.length == 12 && cleaned.startsWith('998')) {
      return '+${cleaned.substring(0, 3)} ${cleaned.substring(3, 5)} ${cleaned.substring(5, 8)} ${cleaned.substring(8, 10)} ${cleaned.substring(10)}';
    }
    if (cleaned.length == 13 && cleaned.startsWith('+998')) {
      return '${cleaned.substring(0, 4)} ${cleaned.substring(4, 6)} ${cleaned.substring(6, 9)} ${cleaned.substring(9, 11)} ${cleaned.substring(11)}';
    }
    return phone;
  }

  // ─── Debt Number ───

  /// Qarz raqamini formatlash: #DBT-2025-00412
  static String formatDebtNumber(String number) {
    return '#$number';
  }

  // ─── Percentage ───

  /// Foiz: 0.75 → "75%"
  static String formatPercent(double ratio) {
    return '${(ratio * 100).toStringAsFixed(0)}%';
  }
}
