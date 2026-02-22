import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../text/text.dart';
import '../../../constants/string.dart';
import '../../../constants/font/font_size.dart';
import '../../../extensions/context.dart';

class ProfileHeaderUsernameComponent extends StatelessWidget {
  final String? name;
  final String username;
  const ProfileHeaderUsernameComponent({
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
          text: name ?? AppStrings.DEFAULT_RIGHTFLAIR_USER.tr(),
          size: FontSizeConstants.XXXX_LARGE,
          weight: FontWeight.w700,
          color: context.colors.primary,
          tr: false,
        ),
        TextComponent(
          text: "@$username",
          size: FontSizeConstants.NORMAL,
          weight: FontWeight.w500,
          color: context.colors.onPrimary,
          tr: false,
        ),
      ],
    );
  }
}
