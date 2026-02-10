import 'package:flutter/material.dart';

import '../../../../../core/extensions/context.dart';

class SuggestedAccountMoreButtonWidget extends StatelessWidget {
  const SuggestedAccountMoreButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon:  Icon(Icons.more_horiz, color: context.colors.primary),
      onPressed: () {},
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
    );
  }
}
