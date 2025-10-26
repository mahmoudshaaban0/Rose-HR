import 'package:flutter/cupertino.dart';
import 'package:rose_hr/theme/theme_ext.dart';

class AppSwitch extends StatelessWidget {
  const AppSwitch({required this.value, required this.onChanged, this.scale = 0.8, super.key});
  final bool value;
  final void Function(bool) onChanged;
  final double? scale;
  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale ?? 0.8,
      child: CupertinoSwitch(
        activeTrackColor: context.colors.surfaceContainerLow,
        inactiveTrackColor: context.colors.surfaceContainerLow,
        inactiveThumbColor: context.colors.onSurface,
        thumbColor: context.colors.onSurface,
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
