import 'package:flutter/material.dart';

import '../../text/profile_tag.dart';
import '../../../../../../core/extensions/context.dart';

class ProfileHeaderTagsComponent extends StatelessWidget {
  final List<String>? tags;
  const ProfileHeaderTagsComponent({super.key, required this.tags});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width,
      child: (tags == null || tags?.length == 0)
          ? null
          : Wrap(
              spacing: context.width * 0.025,
              runSpacing: context.height * 0.01,
              alignment: WrapAlignment.start,
              children: tags!
                  .map((tag) => ProfileTagComponent(text: tag))
                  .toList(),
            ),
    );
  }
}
