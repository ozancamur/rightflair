import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/icons.dart';
import '../extensions/context.dart';
import 'icon_button.dart';

class BackButtonComponent extends StatelessWidget {
  final VoidCallback? onBack;
  const BackButtonComponent({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: context.width * .035),
      child: IconButtonComponent(
        icon: AppIcons.BACK,
        onTap: onBack ?? () => context.pop(),
      ),
    );
  }
}
