/// API natija wrapper — exception o'rniga sealed class
/// 
/// Har bir API call shuni qaytaradi:
/// ```dart
/// final result = await repository.getDebts();
/// result.when(
///   success: (data) => emit(Loaded(data)),
///   failure: (error) => emit(Error(error.message)),
/// );
/// ```
sealed class ApiResult<T> {
  const ApiResult();

  const factory ApiResult.success(T data) = ApiSuccess<T>;
  const factory ApiResult.failure(AppError error) = ApiFailure<T>;

  /// Pattern matching helper
  R when<R>({
    required R Function(T data) success,
    required R Function(AppError error) failure,
  }) {
    return switch (this) {
      ApiSuccess<T>(data: final data) => success(data),
      ApiFailure<T>(error: final error) => failure(error),
    };
  }

  /// Map success value
  ApiResult<R> map<R>(R Function(T data) transform) {
    return switch (this) {
      ApiSuccess<T>(data: final data) => ApiResult.success(transform(data)),
      ApiFailure<T>(error: final error) => ApiResult.failure(error),
    };
  }

  bool get isSuccess => this is ApiSuccess<T>;
  bool get isFailure => this is ApiFailure<T>;

  T? get dataOrNull => switch (this) {
    ApiSuccess<T>(data: final data) => data,
    _ => null,
  };
}

class ApiSuccess<T> extends ApiResult<T> {
  final T data;
  const ApiSuccess(this.data);
}

class ApiFailure<T> extends ApiResult<T> {
  final AppError error;
  const ApiFailure(this.error);
}

/// App xatolik turlari
class AppError {
  final AppErrorType type;
  final String message;
  final int? statusCode;
  final dynamic originalError;

  const AppError({
    required this.type,
    required this.message,
    this.statusCode,
    this.originalError,
  });

  factory AppError.network([String? message]) => AppError(
    type: AppErrorType.network,
    message: message ?? 'Internet aloqasi yo\'q',
  );

  factory AppError.unauthorized([String? message]) => AppError(
    type: AppErrorType.unauthorized,
    message: message ?? 'Sessiya muddati tugagan',
    statusCode: 401,
  );

  factory AppError.forbidden([String? message]) => AppError(
    type: AppErrorType.forbidden,
    message: message ?? 'Ruxsat yo\'q',
    statusCode: 403,
  );

  factory AppError.notFound([String? message]) => AppError(
    type: AppErrorType.notFound,
    message: message ?? 'Ma\'lumot topilmadi',
    statusCode: 404,
  );

  factory AppError.server([String? message]) => AppError(
    type: AppErrorType.server,
    message: message ?? 'Server xatosi',
    statusCode: 500,
  );

  factory AppError.unknown([String? message]) => AppError(
    type: AppErrorType.unknown,
    message: message ?? 'Noma\'lum xatolik',
  );

  factory AppError.validation(String message) => AppError(
    type: AppErrorType.validation,
    message: message,
    statusCode: 422,
  );
}

enum AppErrorType {
  network,
  unauthorized,
  forbidden,
  notFound,
  server,
  validation,
  unknown,
}
