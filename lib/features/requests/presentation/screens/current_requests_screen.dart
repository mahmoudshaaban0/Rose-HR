import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rose_hr/features/requests/presentation/widgets/current_request_item.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/theme_ext.dart';

class CurrentRequests extends StatelessWidget {
  const CurrentRequests({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: RefreshIndicator.adaptive(
        color: context.colors.onSurface,
        onRefresh: () async {
          return Future.delayed(const Duration(seconds: 1));
        },
        child: ListView.builder(
          itemCount: 3,
          shrinkWrap: true,
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.sm.w),
            child: CurrentRequestItem(
              requestType: 'طلب تصحيح بصمة',
              requestDate: '5 مارس 2025 | 4:49 مساءً',
              requestNumber: '23985',
              requestStatus: 'قيد المراجعة',
              requestColor: context.colors.error,
              requestResponse: 'مرفوض بسبب مناير خالد صالح السعيد',
            ),
          ),
        ),
      ),
    );
  }
}
