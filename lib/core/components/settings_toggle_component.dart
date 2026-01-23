import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rightflair/core/constants/color/color.dart';
import '../extensions/context.dart';

class SettingsToggleComponent extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingsToggleComponent({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: context.width * 0.0022,
      child: CupertinoSwitch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.GREEN,
        trackColor: context.colors.tertiary,
      ),
    );
  }
}
