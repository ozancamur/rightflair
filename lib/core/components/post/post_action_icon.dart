import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rightflair/core/components/text/text.dart';
import 'package:rightflair/core/constants/font/font_size.dart';

import '../../constants/color/color.dart';
import '../../extensions/context.dart';

class PostIconButtonWidget extends StatelessWidget {
  final String icon;
  final Function() onTap;
  final int? value;
  final bool? isActive;
  const PostIconButtonWidget({
    super.key,
    required this.onTap,
    required this.icon,
    this.value,
    this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final double _size = context.height * .05;

    return _value(context, _size);
  }

  Column _value(BuildContext context, double size) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: context.height * .005,
      children: [
        isActive == true ? _active(size, context) : _negative(size, context),
        TextComponent(
          text: value.toString(),
          size: FontSizeConstants.XXX_SMALL,
          weight: FontWeight.w500,
          color: isActive == true
              ? context.colors.scrim
              : context.colors.primary,
          tr: false,
        ),
      ],
    );
  }

  InkWell _active(double _size, BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100),
      child: ShaderMask(
        shaderCallback: (bounds) => LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.YELLOW, AppColors.ORANGE],
        ).createShader(bounds),
        child: Container(
          height: _size,
          width: _size,
          padding: EdgeInsets.all(context.width * .025),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(.16),
            border: Border.all(color: Colors.white.withOpacity(.32), width: 1),
          ),
          child: SvgPicture.asset(icon, color: Colors.white),
        ),
      ),
    );
  }

  InkWell _negative(double _size, BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        height: _size,
        width: _size,
        padding: EdgeInsets.all(context.width * .025),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(.16),
          border: Border.all(color: Colors.white.withOpacity(.32), width: 1),
        ),
        child: SvgPicture.asset(icon, color: Colors.white),
      ),
    );
  }
}
