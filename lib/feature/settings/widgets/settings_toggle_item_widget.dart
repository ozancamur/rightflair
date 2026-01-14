import 'package:flutter/material.dart';
import '../../../../core/components/settings_toggle_component.dart';
import '../../../../core/components/text.dart';
import '../../../../core/extensions/context.dart';
import '../../../core/constants/font_size.dart';

class SettingsToggleItemWidget extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingsToggleItemWidget({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.width * 0.04,
        vertical: context.height * 0.018,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextComponent(
            text: title,
            size: FontSizeConstants.LARGE,
            color: Colors.white,
            weight: FontWeight.w500,
          ),
          SettingsToggleComponent(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
