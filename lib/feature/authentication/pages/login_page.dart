import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rightflair/core/components/appbar.dart';
import 'package:rightflair/core/components/back_button.dart';
import 'package:rightflair/core/constants/string.dart';

import '../../../core/base/page/base_scaffold.dart';
import '../../../core/constants/route.dart';
import '../../../core/extensions/context.dart';
import '../../../core/utils/dialog.dart';
import '../bloc/authentication_bloc.dart';
import '../widgets/authentication_text.dart';
import '../widgets/login/login_button.dart';
import '../widgets/login/login_forgot_password.dart';
import '../widgets/login/login_inputs.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final GlobalKey<FormState> keyLogin = GlobalKey<FormState>();
  final TextEditingController ctrlEmail = TextEditingController();
  final TextEditingController ctrlPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationSuccess) {
          context.replace(RouteConstants.NAVIGATION);
        }
        if (state is AuthenticationError) {
          DialogUtils.showErrorDialog(
            context,
            message: AppStrings.ERROR_LOGIN_PAGE,
          );
        }
      },
      builder: (context, state) {
        return BaseScaffold(
          appBar: AppBarComponent(
            leading: BackButtonComponent(),
            title: AppStrings.LOGIN,
          ),
          body: SizedBox(
            height: context.height,
            width: context.width,
            child: _body(context, (state is AuthenticationLoading)),
          ),
        );
      },
    );
  }

  Widget _body(BuildContext context, bool isLoading) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.width * .05),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: context.height * .005,
        children: [
          const AuthenticationTextWidget(
            title: AppStrings.LOGIN_TITLE,
            subtitle: AppStrings.LOGIN_SUBTITLE,
          ),
          LoginInputsWidget(
            formKey: keyLogin,
            ctrlEmail: ctrlEmail,
            ctrlPassword: ctrlPassword,
          ),
          SizedBox(height: context.height * .025),
          _button(context, isLoading),
          const LoginForgotPasswordWidget(),
        ],
      ),
    );
  }

  LoginButtonWidget _button(BuildContext context, bool isLoading) {
    return LoginButtonWidget(
      isLoading: isLoading,
      onTap: () {
        if (isLoading) return;
        if (keyLogin.currentState?.validate() ?? false) {
          context.read<AuthenticationBloc>().add(
            AuthenticationLoginEvent(
              email: ctrlEmail.text.trim(),
              password: ctrlPassword.text.trim(),
            ),
          );
        }
      },
    );
  }
}
