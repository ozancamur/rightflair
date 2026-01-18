import 'package:flutter/material.dart';

import '../../../../../../core/components/profile_tag.dart';
import '../../../../../../core/extensions/context.dart';
import '../../../constants/font/font_size.dart';
import '../../text.dart';

class ProfileHeaderTagsWidget extends StatelessWidget {
  final List<String> tags;
  const ProfileHeaderTagsWidget({super.key, required this.tags});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: context.height * 0.005,
      children: [
        TextComponent(
          text: "My Styles",
          color: context.colors.primary,
          weight: FontWeight.w600,
          size: FontSizeConstants.NORMAL,
        ),
        Wrap(
          spacing: context.width * 0.025,
          runSpacing: context.height * 0.01,
          alignment: WrapAlignment.start,
          children: tags.map((tag) => ProfileTagComponent(text: tag)).toList(),
        ),
      ],
    );
  }
}
