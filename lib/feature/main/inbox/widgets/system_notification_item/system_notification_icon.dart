import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/icons.dart';
import '../../../../../core/extensions/context.dart';

class SystemNotificationIconWidget extends StatelessWidget {
  const SystemNotificationIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.height * .05,
      width: context.height * .05,
      padding: EdgeInsets.all(context.width * 0.012),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: context.colors.secondary,
      ),
      child: SvgPicture.asset(
        AppIcons.ACCOUNT_UPDATE,
        color: context.colors.primary,
      ),
    );
  }
}