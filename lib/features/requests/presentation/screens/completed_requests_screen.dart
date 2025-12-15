import 'package:flutter/material.dart';
import 'package:rose_hr/features/requests/presentation/widgets/no_requests_widget.dart';
import 'package:rose_hr/theme/theme_ext.dart';

class CompletedRequests extends StatelessWidget {
  const CompletedRequests({super.key});

  @override
  Widget build(BuildContext context) {
    return NoRequestsWidget(
      title: context.localizations.noCompletedRequestsUntilNow,
    );
  }
}
