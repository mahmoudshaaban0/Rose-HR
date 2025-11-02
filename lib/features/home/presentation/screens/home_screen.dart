import 'package:flutter/material.dart';
import 'package:rose_hr/common/helpers/adapt.dart';
import 'package:rose_hr/features/home/presentation/widgets/header_shift_section.dart';
import 'package:rose_hr/features/home/presentation/widgets/holidays_section.dart';
import 'package:rose_hr/features/home/presentation/widgets/new_request_section.dart';
import 'package:rose_hr/theme/app_spacing.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            spacing: AppSpacing.md.h(context),
            children: const [
              HeaderAndShiftSection(),
              NewRequestSection(),
              HolidaysSection(),
            ],
          ),
        ),
      ),
    );
  }
}
