import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rose_hr/common/constants/app_assets.dart';
import 'package:rose_hr/common/dependency_injection/injection_container.dart';
import 'package:rose_hr/common/helpers/auth_helper.dart';
import 'package:rose_hr/common/helpers/snackbar_service.dart';
import 'package:rose_hr/common/widgets/vector.dart';
import 'package:rose_hr/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:rose_hr/theme/app_sizes.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/app_textfield.dart';
import 'package:rose_hr/theme/primary_text_button.dart';
import 'package:rose_hr/theme/theme_ext.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<ForgetPasswordScreen> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _emailController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthBloc>(),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.resetPasswordLoading) {
            showDialog<void>(
              barrierDismissible: false,
              context: context,
              builder: (context) => const Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state.status == AuthStatus.resetPasswordSuccess) {
            SnackbarService.showSuccess(context, context.localizations.passwordResetSentToEmail);
            Navigator.popUntil(context, (route) => route.isFirst);
            // context.goNamed(AppRoutes.login.name);
          } else if (state.status == AuthStatus.resetPasswordError) {
            Navigator.pop(context);
            showDialog<void>(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(state.resetPasswordErrorMessage ?? ''),
                content: Text(state.resetPasswordErrorMessage ?? ''),
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                spacing: AppSpacing.md.h,
                children: [
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
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    context.pop();
                                  },
                                  icon: const Icon(Icons.arrow_back),
                                ),
                                Text(context.localizations.forgetPassword, style: context.typography.bold22),
                              ],
                            ),
                            AppTextField(
                              prefixIcon: const AppVectorGraphic(path: Assets.vectorsEmailIcon),
                              validator: (value) => AuthHelper.validateEmail(context, value),
                              title: context.localizations.email,
                              hintTextLabel: context.localizations.pleaseEnterYourEmail,
                              required: true,
                              controller: _emailController,
                            ),
                            PrimaryTextButton(
                              appButtonSize: AppButtonSize.xxLarge,
                              label: context.localizations.sendForgetPasswordCode,
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<AuthBloc>().add(
                                    ResetPasswordEvent(
                                      email: _emailController.text,
                                    ),
                                  );
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
        },
      ),
    );
  }
}
