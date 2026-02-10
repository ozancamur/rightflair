import 'package:flutter/material.dart';
import 'package:rightflair/core/components/text/text.dart';
import 'package:rightflair/core/constants/font/font_size.dart';
import 'package:rightflair/core/extensions/context.dart';

class PostDetailUserInfoWidget extends StatelessWidget {
  final String userName;
  final String userProfileImage;

  const PostDetailUserInfoWidget({
    super.key,
    required this.userName,
    required this.userProfileImage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: context.width * 0.03,
      children: [_profileImage(context), _userName(context)],
    );
  }

  CircleAvatar _profileImage(BuildContext context) {
    return CircleAvatar(
      radius: context.width * 0.06,
      backgroundImage: NetworkImage(userProfileImage),
    );
  }

  TextComponent _userName(BuildContext context) {
    return TextComponent(
      text: userName,
      size: FontSizeConstants.LARGE,
      weight: FontWeight.w600,
      tr: false,
    );
  }
}
