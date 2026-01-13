import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/icons.dart';
import 'icon_button.dart';

class BackButtonComponent extends StatelessWidget {
  final VoidCallback? onBack;
  const BackButtonComponent({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    return IconButtonComponent(
      icon: AppIcons.BACK,
      onTap: onBack ?? () => context.pop(),
    );
  }
}
