import 'package:flutter/material.dart';

import '../../../../core/extensions/context.dart';
import 'buttons/tag_button.dart';

class CreatePostDescribeButtonsWidget extends StatelessWidget {
  const CreatePostDescribeButtonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: context.width * 0.02,
      children: [
        CreateTagButtonWidget(onTap: () {}, label: '#'),
        CreateTagButtonWidget(onTap: () {}, label: '@'),
      ],
    );
  }
}
