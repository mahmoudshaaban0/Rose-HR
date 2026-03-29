import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rose_hr/common/routing/app_routes.dart';
import 'package:rose_hr/l10n/app_localizations.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/theme_ext.dart';

/// Full-screen animated overlay before [GoRouter.go] to splash after a language change.
class LanguageChangeTransition {
  LanguageChangeTransition._();

  /// Shows a fade + scale dialog, holds briefly, then closes and navigates to splash.
  static Future<void> showThenNavigateToSplash(GoRouter router) async {
    final root = router.routerDelegate.navigatorKey.currentContext;
    if (root == null || !root.mounted) {
      router.go(AppRoutes.splash.path);
      return;
    }

    await showGeneralDialog<void>(
      context: root,
      barrierColor: Colors.black.withValues(alpha: 0.88),
      transitionDuration: const Duration(milliseconds: 380),
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.88, end: 1).animate(curved),
            child: _LanguageChangeOverlayBody(
              message: AppLocalizations.of(dialogContext).languageChangeApplying,
            ),
          ),
        );
      },
    );

    router.go(AppRoutes.splash.path);
  }
}

class _LanguageChangeOverlayBody extends StatefulWidget {
  const _LanguageChangeOverlayBody({required this.message});

  final String message;

  @override
  State<_LanguageChangeOverlayBody> createState() => _LanguageChangeOverlayBodyState();
}

class _LanguageChangeOverlayBodyState extends State<_LanguageChangeOverlayBody> {
  static const _visibleDuration = Duration(milliseconds: 1000);

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(_visibleDuration, () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxl.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator.adaptive(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(context.colors.white),
                ),
              ),
              SizedBox(height: AppSpacing.xl.h),
              Text(
                widget.message,
                textAlign: TextAlign.center,
                style: context.typography.semiBold16.copyWith(
                  color: context.colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
