import 'package:dio/dio.dart';
import 'package:rose_hr/common/constants/app_strings.dart';
import 'package:rose_hr/common/helpers/app_manager.dart';
import 'package:rose_hr/common/networking/status_code.dart';
import 'package:rose_hr/common/routing/app_router.dart';
import 'package:rose_hr/common/routing/app_routes.dart';

class AppIntercepters extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers[AppStrings.accept] = AppStrings.applicationJson;
    options.headers[AppStrings.contentType] = AppStrings.applicationJson;
    options.headers[AppStrings.authorization] =
        'Bearer ${AppManager.instance.getString(AppStrings.apiKey)}';

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
    if (_isUnauthorized(response.data)) {
      _handleSessionExpired();
    }
    super.onResponse(response, handler);
  }

  /// The Odoo-style backend returns HTTP 200 with the real status inside the
  /// `result` envelope, e.g. `{"result": {"status_code": 401, ...}}`.
  /// Detect that case so an expired/invalid API key triggers a re-login.
  bool _isUnauthorized(dynamic data) {
    if (data is! Map<String, dynamic>) return false;

    final result = data['result'];
    if (result is! Map<String, dynamic>) return false;

    return result['status_code'] == StatusCode.unauthorized;
  }

  /// Clears the stored credentials and sends the user back to the login screen.
  void _handleSessionExpired() {
    AppManager.instance.remove(AppStrings.apiKey);

    // Avoid redirect loops if we're already on the login screen.
    final currentLocation =
        AppRouter.router.routerDelegate.currentConfiguration.uri.path;
    if (currentLocation == AppRoutes.login.path) return;

    AppRouter.router.goNamed(AppRoutes.login.name);
  }
}
