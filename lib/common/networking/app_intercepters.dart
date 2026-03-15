import 'package:dio/dio.dart';
import 'package:rose_hr/common/constants/app_strings.dart';
import 'package:rose_hr/common/helpers/app_manager.dart';

class AppIntercepters extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers[AppStrings.accept] = AppStrings.applicationJson;
    options.headers[AppStrings.contentType] = AppStrings.applicationJson;
    options.headers[AppStrings.authorization] = 'Bearer ${AppManager.instance.getString(AppStrings.apiKey)}';

    // Language header: "lang" can be "en_US" or "ar_001"
    final storedLang = AppManager.instance.getString(AppStrings.lang);

    // Map stored value (or missing) to a valid backend value
    final langHeader = switch (storedLang) {
      'en_US' => 'en_US',
      'ar_001' => 'ar_001',
      // Common fallbacks from simple language codes
      AppStrings.english => 'en_US',
      AppStrings.arabic => 'ar_001',
      // Default if nothing is stored yet
      _ => 'ar_001',
    };

    options.headers[AppStrings.langHeader] = langHeader;

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
