import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../extensions/context.dart';

class ElevatedButtonComponent extends StatelessWidget {
  final Function()? onPressed;
  final Widget child;
  final Color? borderColor;
  final Color? color;
  final double? borderWidth;
  final double? height;
  final double? width;
  final double radius;
  final double elevation;
  const ElevatedButtonComponent({
    super.key,
    required this.child,
    required this.onPressed,
    this.height,
    this.width,
    this.borderColor,
    this.borderWidth,
    this.radius = 20.0,
    this.color,
    this.elevation = 0,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        HapticFeedback.mediumImpact();
        onPressed?.call();
      },
      style: ElevatedButton.styleFrom(
        fixedSize: Size(
          width ?? context.width,
          height ?? context.height * .065,
        ),
        elevation: elevation,
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: borderWidth ?? 0,
            color: borderColor ?? Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
      child: child,
    );
  }
}
