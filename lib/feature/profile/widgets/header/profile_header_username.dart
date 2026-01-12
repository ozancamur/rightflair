import 'package:flutter/material.dart';

import '../../../../../../core/components/text.dart';
import '../../../../../../core/constants/dark_color.dart';
import '../../../../../../core/constants/font_size.dart';

class ProfileHeaderUsernameWidget extends StatelessWidget {
  final String name;
  final String username;
  const ProfileHeaderUsernameWidget({
    super.key,
    required this.name,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextComponent(
          text: name,
          size: FontSizeConstants.XXXX_LARGE,
          weight: FontWeight.w700,
          color: AppDarkColors.PRIMARY,
          tr: false,
        ),
        TextComponent(
          text: username,
          size: FontSizeConstants.NORMAL,
          weight: FontWeight.w500,
          color: AppDarkColors.WHITE60,
          tr: false,
        ),
      ],
    );
  }
}
