import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:tt_jig_ms/core/network/exception/api_exception.dart';
import 'package:tt_jig_ms/l10n/app_localizations.dart';

class ErrorInterceptor extends Interceptor {
  AppLocalizations get localize => AppLocalizations.of(Get.context!)!;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final response = err.response;

    String message =
        response?.data?['message'] ?? err.message ?? 'Unknown network error';

    switch (err.type) {
      case .connectionError:
        message = localize.connectionError;
        break;
      case .receiveTimeout:
        message = localize.receiveTimeout;
        break;
      case .sendTimeout:
        message = localize.sendTimeout;
        break;
      case .connectionTimeout:
        message = localize.connectionTimeout;
        break;
      default:
        break;
    }

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: ApiException(message, statusCode: response?.statusCode),
      ),
    );
  }
}
