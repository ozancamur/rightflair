import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rightflair/core/constants/font_family.dart';
import 'package:rightflair/core/constants/font_size.dart';
import 'package:rightflair/core/extensions/context.dart';

import 'text.dart';

class ButtonTextWithIconComponent extends StatelessWidget {
  final String icon;
  final String text;
  final Color foregroundColor;
  const ButtonTextWithIconComponent({
    super.key,
    required this.icon,
    required this.text,
    required this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: context.width * 0.02,
      children: [
        SvgPicture.asset(
          icon,
          height: context.height * 0.0225,
          color: foregroundColor,
        ),
        TextComponent(
          text: text,
          color: foregroundColor,
          family: FontFamilyConstants.POPPINS,
          size: FontSizeConstants.SMALL,
        ),
      ],
    );
  }
}
