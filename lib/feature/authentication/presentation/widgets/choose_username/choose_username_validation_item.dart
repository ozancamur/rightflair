import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/components/text.dart';
import '../../../../../core/constants/dark_color.dart';
import '../../../../../core/constants/font_size.dart';
import '../../../../../core/constants/icons.dart';
import '../../../../../core/extensions/context.dart';

class ChooseUsernameValidationItem extends StatelessWidget {
  final bool isValid;
  final String label;
  const ChooseUsernameValidationItem({
    super.key,
    required this.isValid,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: context.width * .03,
      children: [
        AnimatedContainer(
          height: context.height * .03,
          width: context.height * .03,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isValid ? AppDarkColors.GREEN : AppDarkColors.INACTIVE,
          ),
          duration: const Duration(milliseconds: 300),
          child: SvgPicture.asset(
            isValid ? AppIcons.CHECK : AppIcons.CLOSE,
            height: context.height * .013,
          ),
        ),
        TextComponent(
          text: label,
          color: Colors.white,
          weight: FontWeight.w400,
          size: FontSizeConstants.X_SMALL,
        ),
      ],
    );
  }
}
