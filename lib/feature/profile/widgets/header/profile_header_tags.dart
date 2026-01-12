import 'package:flutter/material.dart';

import '../../../../../../core/components/profile_tag.dart';
import '../../../../../../core/extensions/context.dart';

class ProfileHeaderTagsWidget extends StatelessWidget {
  final List<String> tags;
  const ProfileHeaderTagsWidget({super.key, required this.tags});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: context.width * 0.02,
      runSpacing: context.height * 0.01,
      alignment: WrapAlignment.center,
      children: tags.map((tag) => ProfileTagComponent(text: tag)).toList(),
    );
  }
}
