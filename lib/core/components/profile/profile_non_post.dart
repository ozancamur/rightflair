import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rightflair/core/components/text.dart';
import 'package:rightflair/core/constants/font/font_size.dart';
import 'package:rightflair/core/constants/icons.dart';
import 'package:rightflair/core/constants/string.dart';
import 'package:rightflair/core/extensions/context.dart';

class ProfileNonPostComponent extends StatelessWidget {
  const ProfileNonPostComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.height * .1,
      width: context.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            AppIcons.NON_POST,
            height: context.height * .05,
            color: context.colors.primary,
          ),
          TextComponent(
            text: AppStrings.NON_POST,
            color: context.colors.primary,
            size: FontSizeConstants.NORMAL,
            weight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}
