import 'package:dio/dio.dart';
import 'package:shared_advisor_interface/main.dart';

class LoggerInterceptor extends Interceptor {
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    final options = err.requestOptions;
    final requestPath = '${options.baseUrl}${options.path}';
    logger.e('${options.method} request => $requestPath');
    logger.d('Error: ${err.error}, Message: ${err.message}\n'
        'Response: ${err.response}');
    return super.onError(err, handler);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final requestPath = '${options.baseUrl}${options.path}';
    logger.i('${options.method} request => $requestPath');
    logger.d('HEADERS => ${options.headers}');
    logger.d('Request data => ${options.data}');
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final requestPath = '${response.realUri}';
    logger.i('Response => $requestPath');
    logger.d(
        'StatusCode: ${response.statusCode}, Data: ${response.data}'); // Debug log
    return super.onResponse(response, handler);
  }
}
