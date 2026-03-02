import 'package:flutter/material.dart';
import '../../../core/components/text/text.dart';
import '../../../../core/extensions/context.dart';

class SettingsButtonWidget extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Color textColor;
  final VoidCallback onTap;

  const SettingsButtonWidget({
    super.key,
    required this.title,
    this.icon,
    this.textColor = Colors.white,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: context.height * 0.0115),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, color: textColor, size: context.width * 0.04),
                SizedBox(width: context.width * 0.02),
              ],
              TextComponent(
                text: title,
                size: [context.width * 0.035],
                color: textColor,
                weight: FontWeight.w500,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
