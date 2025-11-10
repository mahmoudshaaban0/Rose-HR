import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rose_hr/common/constants/app_assets.dart';
import 'package:rose_hr/common/helpers/auth_helper.dart';
import 'package:rose_hr/common/routing/app_routes.dart';
import 'package:rose_hr/common/widgets/vector.dart';
import 'package:rose_hr/theme/app_sizes.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/app_textfield.dart';
import 'package:rose_hr/theme/primary_text_button.dart';
import 'package:rose_hr/theme/theme_ext.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.end,
          spacing: AppSpacing.md.h,
          children: [
            Expanded(child: Image.asset(Assets.rastersLoginBackgrooundImage)),
            Container(
              padding: EdgeInsets.all(AppSpacing.md.h),
              decoration: BoxDecoration(
                color: context.colors.containerBackground,
                borderRadius: BorderRadius.circular(AppSpacing.xxxl.r),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: AppSpacing.lg.h,
                    children: [
                      Text(context.localizations.login, style: context.typography.bold22),
                      AppTextField(
                        prefixIcon: const AppVectorGraphic(path: Assets.vectorsEmailIcon),
                        validator: (value) => AuthHelper.validateEmail(context, value),
                        title: context.localizations.email,
                        hintTextLabel: context.localizations.pleaseEnterYourEmail,
                        required: true,
                        controller: _emailController,
                      ),
                      AppTextField(
                        prefixIcon: const AppVectorGraphic(path: Assets.vectorsPasswordIcon),
                        validator: (value) => AuthHelper.validatePassword(context, value),
                        title: context.localizations.password,
                        hintTextLabel: context.localizations.pleaseEnterYourPassword,
                        required: true,
                        suffixIcon: const AppVectorGraphic(path: Assets.vectorsPasswordVisible),
                        obscureText: true,
                        controller: _passwordController,
                      ),
                      InkWell(
                        onTap: () {
                          context.goNamed(AppRoutes.forgetPassword.name);
                        },
                        child: Text(
                          context.localizations.forgetPassword,
                          style: context.typography.medium16,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      PrimaryTextButton(
                        appButtonSize: AppButtonSize.xxLarge,
                        label: context.localizations.login,
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            //
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
