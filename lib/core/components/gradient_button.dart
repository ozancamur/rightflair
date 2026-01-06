/*import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants/color.dart';
import '../../utils/extensions/context.dart';

class GradientButtonComponent extends StatelessWidget {
  final Function()? onPressed;
  final Widget child;
  final Color? borderColor;
  final List<Color>? colors;
  final double? borderWidth;
  final double? height;
  final double? width;
  final double? radius;
  final double elevation;
  const GradientButtonComponent({
    super.key,
    required this.child,
    required this.onPressed,
    this.height,
    this.width,
    this.borderColor,
    this.borderWidth,
    this.radius,
    this.colors,
    this.elevation = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? context.height * .07,
      width: width ?? context.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors ?? ColorConstants.BUTTON_GRADIENT,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        borderRadius: BorderRadius.circular(radius ?? 100),
        border: Border.all(
          width: borderWidth ?? 0,
          color: borderColor ?? Colors.transparent,
        ),
        boxShadow: elevation > 0
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: elevation,
                  offset: Offset(0, elevation / 2),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed != null
              ? () {
                  HapticFeedback.lightImpact();
                  onPressed!();
                }
              : null,
          borderRadius: BorderRadius.circular(radius ?? 6),
          child: Container(alignment: Alignment.center, child: child),
        ),
      ),
    );
  }
}
*/