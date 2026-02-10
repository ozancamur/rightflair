import 'package:flutter/material.dart';

import '../../../../core/extensions/context.dart';
import 'buttons/tag_button.dart';

class CreatePostDescribeButtonsWidget extends StatelessWidget {
  final VoidCallback onHashtagTap;
  final VoidCallback onMentionTap;

  const CreatePostDescribeButtonsWidget({
    super.key,
    required this.onHashtagTap,
    required this.onMentionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: context.width * 0.02,
      children: [
        CreateTagButtonWidget(onTap: onHashtagTap, label: '#'),
        CreateTagButtonWidget(onTap: onMentionTap, label: '@'),
      ],
    );
  }
}
