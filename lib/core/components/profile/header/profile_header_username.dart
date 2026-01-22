import 'package:flutter/material.dart';

import '../../../../../../core/components/text.dart';
import '../../../constants/font/font_size.dart';
import '../../../extensions/context.dart';

class ProfileHeaderUsernameWidget extends StatelessWidget {
  final String? name;
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
          text: name ?? 'Rightflair User',
          size: FontSizeConstants.XXXX_LARGE,
          weight: FontWeight.w700,
          color: context.colors.primary,
          tr: false,
        ),
        TextComponent(
          text: username,
          size: FontSizeConstants.NORMAL,
          weight: FontWeight.w500,
          color: context.colors.onPrimary,
          tr: false,
        ),
      ],
    );
  }
}
