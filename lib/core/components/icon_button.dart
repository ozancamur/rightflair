import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rightflair/core/components/text.dart';
import 'package:rightflair/core/constants/font_size.dart';

import '../constants/dark_color.dart';
import '../extensions/context.dart';

class IconButtonComponent extends StatelessWidget {
  final String icon;
  final Function() onTap;
  final int? value;
  final double? size;
  const IconButtonComponent({
    super.key,
    required this.onTap,
    required this.icon,
    this.value,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final double _size = size ?? context.height * .05;

    return value == null ? _icon(_size, context) : _value(context, _size);
  }

  Column _value(BuildContext context, double size) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: context.height * .005,
      children: [
        _icon(size, context),
        TextComponent(
          text: value.toString(),
          size: FontSizeConstants.XXX_SMALL,
          weight: FontWeight.w500,
        ),
      ],
    );
  }

  InkWell _icon(double _size, BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        height: _size,
        width: _size,
        padding: EdgeInsets.all(context.width * .025),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppDarkColors.WHITE16,
          border: Border.all(color: AppDarkColors.WHITE32, width: 1),
        ),
        child: SvgPicture.asset(icon, color: AppDarkColors.PRIMARY),
      ),
    );
  }
}
