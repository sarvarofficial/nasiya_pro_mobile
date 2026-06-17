/// Form validatorlar
/// 
/// Spec: Har bir input uchun validatsiya bo'lishi shart
class AppValidators {
  AppValidators._();

  /// Telefon raqam validatsiyasi (+998 XX XXX XX XX)
  static String? phone(String? value) {
    if (value == null || value.isEmpty) return 'Telefon raqamni kiriting';
    final cleaned = value.replaceAll(RegExp(r'[^\d]'), '');
    if (cleaned.length != 12 || !cleaned.startsWith('998')) {
      return 'To\'g\'ri telefon raqam kiriting';
    }
    return null;
  }

  /// Parolni tekshirish (min 6 belgi)
  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Parolni kiriting';
    if (value.length < 6) return 'Kamida 6 ta belgi bo\'lishi kerak';
    return null;
  }

  /// PIN tekshirish (4 raqam)
  static String? pin(String? value) {
    if (value == null || value.isEmpty) return 'PIN kodni kiriting';
    if (value.length != 4 || !RegExp(r'^\d{4}$').hasMatch(value)) {
      return '4 raqamli PIN kiriting';
    }
    return null;
  }

  /// Bo'sh emas tekshirish
  static String? required(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'Bu maydon'}ni kiriting';
    }
    return null;
  }

  /// Pul miqdori tekshirish
  static String? amount(String? value) {
    if (value == null || value.isEmpty) return 'Miqdorni kiriting';
    final cleaned = value.replaceAll(RegExp(r'[^\d.]'), '');
    final amount = double.tryParse(cleaned);
    if (amount == null || amount <= 0) return 'To\'g\'ri miqdor kiriting';
    return null;
  }

  /// Sana tekshirish (kelajakda bo'lishi kerak)
  static String? futureDate(DateTime? value) {
    if (value == null) return 'Sanani tanlang';
    if (value.isBefore(DateTime.now())) {
      return 'Sana kelajakda bo\'lishi kerak';
    }
    return null;
  }

  /// Ism tekshirish (min 2 belgi)
  static String? fullName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Ismni kiriting';
    if (value.trim().length < 2) return 'Kamida 2 ta belgi';
    return null;
  }

  /// Email (optional — majburiy emas)
  static String? email(String? value) {
    if (value == null || value.isEmpty) return null; // optional
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(value)) return 'To\'g\'ri email kiriting';
    return null;
  }
}
