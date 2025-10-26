import 'package:dio/dio.dart';
import 'package:rose_hr/common/constants/app_strings.dart';

class AppIntercepters extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers[AppStrings.accept] = AppStrings.applicationJson;
    options.headers[AppStrings.contentType] = AppStrings.applicationJson;
    super.onRequest(options, handler);
  }

  @override
  dynamic onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    super.onResponse(response, handler);
  }
}
