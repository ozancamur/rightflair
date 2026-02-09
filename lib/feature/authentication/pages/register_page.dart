import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/core/components/appbar.dart';
import 'package:rightflair/core/components/button/back_button.dart';
import 'package:rightflair/core/constants/string.dart';
import 'package:rightflair/feature/authentication/bloc/authentication_bloc.dart';

import '../../../core/base/page/base_scaffold.dart';
import '../../../core/components/text/appbar_title.dart';
import '../../../core/extensions/context.dart';
import '../../../core/utils/dialogs/error.dart';
import '../widgets/authentication_have_account.dart';
import '../widgets/authentication_text.dart';
import '../widgets/register/register_button.dart';
import '../widgets/register/register_inputs.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> keyRegister = GlobalKey<FormState>();
  late TextEditingController ctrlEmail;
  late TextEditingController ctrlPassword;
  late TextEditingController ctrlConfirmPassword;

  @override
  void initState() {
    super.initState();
    ctrlEmail = TextEditingController();
    ctrlPassword = TextEditingController();
    ctrlConfirmPassword = TextEditingController();
  }

  @override
  void dispose() {
    ctrlEmail.dispose();
    ctrlPassword.dispose();
    ctrlConfirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationError) {
          dialogError(context, message: state.message);
        }
      },
      builder: (BuildContext context, AuthenticationState state) {
        return BaseScaffold(
          appBar: AppBarComponent(
            leading: BackButtonComponent(),
            title: AppbarTitleComponent(title: AppStrings.REGISTER_APPBAR),
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
          _button(isLoading, context),
          const AuthenticationHaveAccountWidget(),
        ],
      ),
    );
  }

  RegisterButtonWidget _button(bool isLoading, BuildContext context) {
    return RegisterButtonWidget(
      isLoading: isLoading,
      onRegister: () {
        if (isLoading) return;
        if (keyRegister.currentState?.validate() ?? false) {
          context.read<AuthenticationBloc>().add(
            AuthenticationRegisterEvent(
              email: ctrlEmail.text.trim(),
              password: ctrlPassword.text.trim(),
            ),
          );
        }
      },
    );
  }
}
