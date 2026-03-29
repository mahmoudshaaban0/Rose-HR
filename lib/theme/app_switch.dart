import 'package:flutter/cupertino.dart';
import 'package:rose_hr/theme/theme_ext.dart';

class AppSwitch extends StatelessWidget {
  const AppSwitch({required this.value, required this.onChanged, this.scale = 0.8, super.key});
  final bool value;
  final void Function(bool) onChanged;
  final double? scale;
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Transform.scale(
      scale: scale ?? 0.8,
      child: CupertinoSwitch(
        applyTheme: false,
        // ON: brand success track, white thumb (clear “enabled” state)
        activeTrackColor: colors.success,
        thumbColor: colors.white,
        // OFF: muted track + white thumb + light outline so it reads as “off”
        inactiveTrackColor: colors.surfaceContainerHigh,
        inactiveThumbColor: colors.white,
        // Outline only when off — avoids a ring on the green “on” track
        trackOutlineColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) return null;
          return colors.outlineVariant;
        }),
        trackOutlineWidth: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) return 0;
          return 1;
        }),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
