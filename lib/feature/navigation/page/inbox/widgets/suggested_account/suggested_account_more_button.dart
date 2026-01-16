import 'package:flutter/material.dart';

import '../../../../../../core/constants/dark_color.dart';

class SuggestedAccountMoreButtonWidget extends StatelessWidget {
  const SuggestedAccountMoreButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon:  Icon(Icons.more_horiz, color: AppDarkColors.PRIMARY),
      onPressed: () {},
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
    );
  }
}
