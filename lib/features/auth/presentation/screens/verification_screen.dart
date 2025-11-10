import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:rose_hr/theme/app_shadows.dart';
import 'package:rose_hr/theme/app_sizes.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/primary_text_button.dart';
import 'package:rose_hr/theme/theme_ext.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  late Timer? _timer;
  int _secondsRemaining = 60;

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.all(AppSpacing.md.h),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    boxShadow: AppShadow.lg,
                    color: context.colors.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: AppSpacing.xs.h,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              context.pop();
                            },
                            icon: const Icon(Icons.arrow_back),
                          ),
                          Text(context.localizations.enterOTP, style: context.typography.bold18),
                        ],
                      ),
                      Text(context.localizations.enterOTPHint, style: context.typography.regular14),
                      Pinput(
                        defaultPinTheme: PinTheme(
                          width: 56,
                          height: 56,
                          constraints: const BoxConstraints(
                            minWidth: 100,
                            minHeight: 70,
                          ),

                          decoration: BoxDecoration(
                            color: context.colors.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: context.colors.outlineVariant),
                          ),
                          textStyle: context.typography.medium22,
                        ),
                        onChanged: (value) {},
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(context.localizations.didNotReceiveOTP, style: context.typography.regular16),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(text: context.localizations.tryAgainAfter, style: context.typography.regular16),
                                TextSpan(text: ' $_secondsRemaining ث', style: context.typography.semiBold16),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSpacing.md.h),
                      PrimaryTextButton(
                        label: context.localizations.continueAction,
                        appButtonSize: AppButtonSize.xxLarge,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
