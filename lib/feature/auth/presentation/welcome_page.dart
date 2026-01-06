import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rightflair/core/components/button_text_with_icon.dart';
import 'package:rightflair/core/constants/font_size.dart';
import 'package:rightflair/core/constants/icons.dart';
import 'package:rightflair/core/constants/image.dart';
import 'package:rightflair/core/constants/string.dart';
import 'package:rightflair/core/extensions/context.dart';

import '../../../core/components/elevated_button.dart';
import '../../../core/components/text.dart';
import '../../../core/constants/dark_color.dart';
import '../../../core/helpers/text_color.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppDarkColors.SECONDARY,
      body: SizedBox(
        height: context.height,
        width: context.width,
        child: _body(context),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Column(
      children: [
        Image.asset(AppImages.logo, height: context.height * 0.4),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.width * .15),
          child: AutoSizeText.rich(
            TextSpan(
              children: helperTextStyle(context, AppStrings.welcomeTitle.tr()),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.width * .05),
          child: Column(
            spacing: context.height * .015,
            children: [
              ElevatedButtonComponent(
                color: Colors.white,
                onPressed: () {},
                child: ButtonTextWithIconComponent(
                  icon: AppIcons.mailFilled,
                  text: AppStrings.withMail,
                  foregroundColor: AppDarkColors.SECONDARY,
                ),
              ),
              _or(context),
              ElevatedButtonComponent(
                color: AppDarkColors.DARK_BUTTON,
                onPressed: () {},
                child: ButtonTextWithIconComponent(
                  icon: AppIcons.google,
                  text: AppStrings.withGoogle,
                  foregroundColor: Colors.white,
                ),
              ),
              ElevatedButtonComponent(
                color: AppDarkColors.DARK_BUTTON,
                onPressed: () {},
                child: ButtonTextWithIconComponent(
                  icon: AppIcons.apple,
                  text: AppStrings.withApple,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _or(BuildContext context) {
    return SizedBox(
      height: context.height * .05,
      width: context.width,
      child: Row(
        spacing: context.width * 0.05,
        children: [
          Expanded(
            child: Divider(color: AppDarkColors.DARK_GREY, thickness: 1.5),
          ),
          TextComponent(
            text: AppStrings.or,
            size: FontSizeConstants.SMALL,
            color: AppDarkColors.DARK_GREY,
            weight: FontWeight.w500,
          ),
          Expanded(
            child: Divider(color: AppDarkColors.DARK_GREY, thickness: 1.5),
          ),
        ],
      ),
    );
  }
}
