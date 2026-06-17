/// App konfiguratsiyasi — environment ga qarab o'zgaradi
class AppConfig {
  final String apiUrl;
  final String apiVersion;
  final bool isDebug;
  final String environment;

  const AppConfig({
    required this.apiUrl,
    required this.apiVersion,
    this.isDebug = false,
    required this.environment,
  });

  /// Development config
  static const dev = AppConfig(
    apiUrl: 'http://localhost:3000',
    apiVersion: 'v1',
    isDebug: true,
    environment: 'development',
  );

  /// Staging config
  static const staging = AppConfig(
    apiUrl: 'https://staging-api.nasiyapro.uz',
    apiVersion: 'v1',
    isDebug: true,
    environment: 'staging',
  );

  /// Production config
  static const prod = AppConfig(
    apiUrl: 'https://api.nasiyapro.uz',
    apiVersion: 'v1',
    isDebug: false,
    environment: 'production',
  );

  /// Full API URL
  String get baseUrl => '$apiUrl/api/$apiVersion';
}
