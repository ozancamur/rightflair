import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rightflair/core/components/text.dart';
import 'package:rightflair/core/constants/font_size.dart';
import 'package:rightflair/core/constants/light_color.dart';
import 'package:rightflair/core/constants/route.dart';
import 'package:rightflair/core/constants/string.dart';

class AuthenticationHaveAccountWidget extends StatelessWidget {
  const AuthenticationHaveAccountWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextComponent(
          text: AppStrings.HAVE_ACCOUNT,
          color: AppLightColors.WHITE75,
          size: FontSizeConstants.SMALL,
          weight: FontWeight.w500,
        ),
        TextButton(
          onPressed: () => context.push(RouteConstants.LOGIN),
          child: TextComponent(
            text: AppStrings.LOGIN,
            color: Colors.white,
            size: FontSizeConstants.SMALL,
            weight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
