import 'package:flutter/material.dart';

import '../../../../../core/constants/image.dart';
import '../../../../../core/extensions/context.dart';

class WelcomeLogoWidget extends StatelessWidget {
  const WelcomeLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.height * .35,
      width: context.width,
      child: Image.asset(AppImages.logo, fit: BoxFit.cover),
    );
  }
}
