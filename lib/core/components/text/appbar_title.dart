import 'package:flutter/widgets.dart';

import '../../constants/font/font_size.dart';
import '../../extensions/context.dart';
import 'text.dart';

class AppbarTitleComponent extends StatelessWidget {
  final String title;
  const AppbarTitleComponent({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return TextComponent(
      text: title,
      size: FontSizeConstants.X_LARGE,
      color: context.colors.primary,
      weight: FontWeight.w600,
    );
  }
}
