import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rightflair/core/constants/route.dart';

import '../../../../core/components/button_text_with_icon.dart';
import '../../../../core/components/elevated_button.dart';
import '../../../../core/constants/dark_color.dart';
import '../../../../core/constants/icons.dart';
import '../../../../core/constants/string.dart';
import '../../../../core/extensions/context.dart';
import '../../bloc/authentication_bloc.dart';
import 'welcome_or.dart';

class WelcomeButtonsWidget extends StatelessWidget {
  const WelcomeButtonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.width * .05),
      child: Column(
        spacing: context.height * .015,
        children: [
          ElevatedButtonComponent(
            width: context.width * .8,
            color: AppDarkColors.PRIMARY,
            onPressed: () => context.push(RouteConstants.REGISTER),
            child: ButtonTextWithIconComponent(
              icon: AppIcons.MAIL_FILLED,
              text: AppStrings.WITH_MAIL,
              foregroundColor: AppDarkColors.SECONDARY,
            ),
          ),
          const WelcomeOrWidget(),
          ElevatedButtonComponent(
            width: context.width * .8,
            color: AppDarkColors.DARK_BUTTON,
            onPressed: () => context.read<AuthenticationBloc>().add(
              AuthtenticationGoogleEvent(),
            ),
            child: ButtonTextWithIconComponent(
              icon: AppIcons.GOOGLE,
              text: AppStrings.WITH_GOOGLE,
              foregroundColor: AppDarkColors.PRIMARY,
            ),
          ),
          ElevatedButtonComponent(
            width: context.width * .8,
            color: AppDarkColors.DARK_BUTTON,
            onPressed: () => context.read<AuthenticationBloc>().add(
              AuthtenticationAppleEvent(),
            ),
            child: ButtonTextWithIconComponent(
              icon: AppIcons.APPLE,
              text: AppStrings.WITH_APPLE,
              foregroundColor: AppDarkColors.PRIMARY,
            ),
          ),
        ],
      ),
    );
  }
}
