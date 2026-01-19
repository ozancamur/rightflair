import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/core/components/appbar.dart';
import 'package:rightflair/core/constants/string.dart';

import '../../../core/base/page/base_scaffold.dart';
import '../../../core/extensions/context.dart';
import '../bloc/choose_username_cubit.dart';
import '../../authentication/widgets/authentication_text.dart';
import '../widget/choose_username_button.dart';
import '../widget/choose_username_textfield.dart';
import '../widget/choose_username_validation.dart';

class ChooseUsernamePage extends StatelessWidget {
  const ChooseUsernamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChooseUsernameCubit, ChooseUsernameState>(
      builder: (context, state) {
        return BaseScaffold(
          appBar: AppBarComponent(title: AppStrings.CHOOSE_USERNAME_APPBAR),
          body: SizedBox(
            height: context.height,
            width: context.width,
            child: _body(context, state),
          ),
        );
      },
    );
  }

  Widget _body(BuildContext context, ChooseUsernameState state) {
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
          ChooseUsernameTextField(isValid: state.isUnique),
          ChooseUsernameValidationWidget(isUnique: state.isUnique),
          SizedBox(height: context.height * .025),
          ChooseUsernameButtonWidget(isLoading: state.isLoading),
        ],
      ),
    );
  }
}
