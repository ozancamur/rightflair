import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';


class TextComponent extends StatelessWidget {
  final String text;
  final bool tr;
  final List<double>? size;
  final Color color;
  final int? maxLine;
  final FontWeight? weight;
  final TextAlign? align;
  final TextDecoration decoration;
  final TextOverflow? overflow;
  final double? height;
  final double spacing;
  final String? family;
  const TextComponent({
    super.key,
    required this.text,
    this.size,
    this.maxLine,
    this.color = Colors.white,
    this.weight = FontWeight.w400,
    this.align,
    this.decoration = TextDecoration.none,
    this.overflow,
    this.tr = true,
    this.height,
    this.spacing = 0,
    this.family,
  });

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      tr ? text.tr() : text,
      presetFontSizes: size,
      maxLines: maxLine,
      textAlign: align,
      style: TextStyle(
        decoration: decoration,
        color: color,
        fontWeight: weight,
        overflow: overflow,
        height: height,
        letterSpacing: spacing,
        fontFamily: family,
      ),
    );
  }
}
