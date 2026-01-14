import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/core/components/appbar.dart';
import 'package:rightflair/core/constants/string.dart';

import '../../../core/base/base_scaffold.dart';
import '../../../core/extensions/context.dart';
import '../bloc/choose_username_bloc.dart';
import '../../authentication/widgets/authentication_text.dart';
import '../widget/choose_username_button.dart';
import '../widget/choose_username_textfield.dart';
import '../widget/choose_username_validation.dart';

class ChooseUsernamePage extends StatefulWidget {
  const ChooseUsernamePage({super.key});

  @override
  State<ChooseUsernamePage> createState() => _ChooseUsernamePageState();
}

class _ChooseUsernamePageState extends State<ChooseUsernamePage> {
  final TextEditingController ctrlUsername = TextEditingController();

  @override
  void initState() {
    super.initState();
    ctrlUsername.addListener(() {
      context.read<ChooseUsernameBloc>().add(
        ChooseUsernameCheckEvent(username: ctrlUsername.text),
      );
    });
  }

  @override
  void dispose() {
    ctrlUsername.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChooseUsernameBloc, ChooseUsernameState>(
      builder: (context, state) {
        return BaseScaffold(
          appBar: AppBarComponent(title: AppStrings.CHOOSE_USERNAME_APPBAR),
          body: SizedBox(
            height: context.height,
            width: context.width,
            child: _body(context),
          ),
        );
      },
    );
  }

  Widget _body(BuildContext context) {
    return BlocBuilder<ChooseUsernameBloc, ChooseUsernameState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: context.width * .05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: context.height * .005,
            children: [
              const AuthenticationTextWidget(
                title: AppStrings.CHOOSE_USERNAME_TITLE,
                subtitle: AppStrings.CHOOSE_USERNAME_SUBTITLE,
              ),
              ChooseUsernameTextField(
                isValid: state.isUnique,
                controller: ctrlUsername,
              ),
              ChooseUsernameValidationWidget(isUnique: state.isUnique),
              SizedBox(height: context.height * .025),
              ChooseUsernameButtonWidget(
                isEnabled: state.isUnique,
                username: ctrlUsername.text,
              ),
            ],
          ),
        );
      },
    );
  }
}
