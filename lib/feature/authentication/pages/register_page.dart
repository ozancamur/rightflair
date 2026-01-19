import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rightflair/core/components/appbar.dart';
import 'package:rightflair/core/constants/route.dart';
import 'package:rightflair/core/constants/string.dart';
import 'package:rightflair/core/utils/dialog.dart';
import 'package:rightflair/feature/authentication/bloc/authentication_bloc.dart';

import '../../../core/base/page/base_scaffold.dart';
import '../../../core/components/loading.dart';
import '../../../core/extensions/context.dart';
import '../widgets/authentication_have_account.dart';
import '../widgets/authentication_text.dart';
import '../widgets/register/register_button.dart';
import '../widgets/register/register_inputs.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final GlobalKey<FormState> keyRegister = GlobalKey<FormState>();
  final TextEditingController ctrlEmail = TextEditingController();
  final TextEditingController ctrlPassword = TextEditingController();
  final TextEditingController ctrlConfirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationSetUsername) {
          context.push(RouteConstants.CHOOSE_USERNAME);
        }
        if (state is AuthenticationError) {
          DialogUtils.showErrorDialog(
            context,
            message: AppStrings.AUTHENTICATION_REGISTER_ERROR.tr(),
          );
        }
      },
      builder: (BuildContext context, AuthenticationState state) {
        return BaseScaffold(
          appBar: AppBarComponent(title: AppStrings.REGISTER_APPBAR),
          body: SizedBox(
            height: context.height,
            width: context.width,
            child: (state is AuthenticationLoading)
                ? LoadingComponent()
                : _body(context),
          ),
        );
      },
    );
  }

  Widget _body(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.width * .05),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: context.height * .005,
        children: [
          const AuthenticationTextWidget(
            title: AppStrings.REGISTER_TITLE,
            subtitle: AppStrings.REGISTER_SUBTITLE,
          ),
          RegisterInputsWidget(
            formKey: keyRegister,
            ctrlEmail: ctrlEmail,
            ctrlPassword: ctrlPassword,
            ctrlConfirmPassword: ctrlConfirmPassword,
          ),
          SizedBox(height: context.height * .025),
          RegisterButtonWidget(
            onRegister: () {
              if (keyRegister.currentState?.validate() ?? false) {
                context.read<AuthenticationBloc>().add(
                  AuthenticationRegisterEvent(
                    email: ctrlEmail.text.trim(),
                    password: ctrlPassword.text.trim(),
                  ),
                );
              }
            },
          ),
          const AuthenticationHaveAccountWidget(),
        ],
      ),
    );
  }
}
