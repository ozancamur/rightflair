import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rightflair/core/components/loading.dart';
import 'package:rightflair/core/extensions/context.dart';

import '../../../core/base/page/base_scaffold.dart';
import '../../../core/constants/route.dart';
import '../../../core/constants/string.dart';
import '../../../core/utils/dialogs/error.dart';
import '../bloc/authentication_bloc.dart';
import '../widgets/welcome/welcome_buttons.dart';
import '../widgets/authentication_have_account.dart';
import '../widgets/welcome/welcome_logo.dart';
import '../widgets/welcome/welcome_title.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationSetUsername) {
          context.push(RouteConstants.NAVIGATION);
        }
        if (state is AuthenticationSuccess) {
          context.replace(RouteConstants.NAVIGATION);
        }
        if (state is AuthenticationError) {
          dialogError(context, message: AppStrings.ERROR_WELCOME_PAGE.tr());
        }
      },
      builder: (context, state) {
        return BaseScaffold(
          body: SizedBox(
            height: context.height,
            width: context.width,
            child: Stack(
              children: [
                _body(context),
                if (state is AuthenticationLoading) _loading(context),
              ],
            ),
          ),
        );
      },
    );
  }

  _body(BuildContext context) {
    return Positioned.fill(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: context.height * .015,
          children: [
            SizedBox(height: context.height * .005),
            const WelcomeLogoWidget(),
            const WelcomeTitleWidget(),
            WelcomeButtonsWidget(),
            Spacer(),
            AuthenticationHaveAccountWidget(),
          ],
        ),
      ),
    );
  }

  _loading(BuildContext context) {
    return Container(
      height: context.height,
      width: context.width,
      color: Colors.black.withOpacity(.75),
      child: Center(child: LoadingComponent()),
    );
  }
}
