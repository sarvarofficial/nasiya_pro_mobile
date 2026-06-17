import 'dart:io';
import 'package:dio/dio.dart';
import '../api_result.dart';

/// Error interceptor — server xatolarini AppError ga aylantiradi
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // AuthInterceptor allaqachon 401 ni handle qiladi
    // Bu yerda faqat xato ma'lumotini boyitamiz

    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout) {
      handler.next(
        DioException(
          requestOptions: err.requestOptions,
          error: AppError.network('Server javob bermayapti'),
          type: err.type,
          response: err.response,
        ),
      );
      return;
    }

    if (err.error is SocketException || err.type == DioExceptionType.connectionError) {
      handler.next(
        DioException(
          requestOptions: err.requestOptions,
          error: AppError.network(),
          type: err.type,
          response: err.response,
        ),
      );
      return;
    }

    if (err.response != null) {
      final statusCode = err.response!.statusCode ?? 0;
      final serverMessage = _extractServerMessage(err.response!);

      final appError = switch (statusCode) {
        401 => AppError.unauthorized(serverMessage),
        403 => AppError.forbidden(serverMessage),
        404 => AppError.notFound(serverMessage),
        422 => AppError.validation(serverMessage ?? 'Xato ma\'lumot'),
        >= 500 => AppError.server(serverMessage),
        _ => AppError.unknown(serverMessage),
      };

      handler.next(
        DioException(
          requestOptions: err.requestOptions,
          error: appError,
          type: err.type,
          response: err.response,
        ),
      );
      return;
    }

    handler.next(err);
  }

  /// Server javobidan xato xabarini olish
  String? _extractServerMessage(Response response) {
    try {
      final data = response.data;
      if (data is Map) {
        return data['error']?['message'] as String? ??
               data['message'] as String?;
      }
    } catch (_) {}
    return null;
  }
}
