import 'package:flutter/material.dart';
import 'package:rightflair/core/constants/string.dart';

import '../../text/profile_tag.dart';
import '../../../../../../core/extensions/context.dart';
import '../../../constants/font/font_size.dart';
import '../../text/text.dart';

class ProfileHeaderTagsComponent extends StatelessWidget {
  final List<String> tags;
  const ProfileHeaderTagsComponent({super.key, required this.tags});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: context.height * 0.0075,
        children: [
          TextComponent(
            text: AppStrings.PROFILE_EDIT_MY_STYLES,
            color: context.colors.primary,
            weight: FontWeight.w600,
            size: FontSizeConstants.LARGE,
          ),
          Wrap(
            spacing: context.width * 0.025,
            runSpacing: context.height * 0.01,
            alignment: WrapAlignment.start,
            children: tags
                .map((tag) => ProfileTagComponent(text: tag))
                .toList(),
          ),
        ],
      ),
    );
  }
}
