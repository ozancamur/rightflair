import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rightflair/core/components/appbar.dart';
import 'package:rightflair/core/constants/string.dart';

import '../../../core/base/page/base_scaffold.dart';
import '../../../core/components/button/back_button.dart';
import '../../../core/components/text/appbar_title.dart';
import '../../../core/extensions/context.dart';
import '../cubit/choose_username_cubit.dart';
import '../../authentication/widgets/authentication_text.dart';
import '../widget/choose_username_button.dart';
import '../widget/choose_username_textfield.dart';
import '../widget/choose_username_validation.dart';
import '../widget/choose_username_suggestions.dart';

class ChooseUsernamePage extends StatelessWidget {
  final String? username;
  final bool canPop;
  const ChooseUsernamePage({
    super.key,
    required this.username,
    required this.canPop,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChooseUsernameCubit, ChooseUsernameState>(
      builder: (context, state) {
        return BaseScaffold(
          appBar: AppBarComponent(
            leading: canPop
                ? BackButtonComponent(onBack: () => context.pop())
                : null,
            title: AppbarTitleComponent(title: AppStrings.CHOOSE_USERNAME_APPBAR),
          ),
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
        spacing: context.height * .01,
        children: [
          const AuthenticationTextWidget(
            title: AppStrings.CHOOSE_USERNAME_TITLE,
            subtitle: AppStrings.CHOOSE_USERNAME_SUBTITLE,
          ),
          ChooseUsernameTextField(
            isValid: state.isUnique,
            hintText: username ?? AppStrings.CHOOSE_USERNAME_USERNAME,
            isLoading: state.isLoading,
          ),
          if (state.suggestions != null && state.suggestions!.isNotEmpty)
            ChooseUsernameSuggestions(suggestions: state.suggestions!),
          ChooseUsernameValidationWidget(
            isUnique: state.isUnique,
            textLength: context.read<ChooseUsernameCubit>().controller.text.length,
          ),
          SizedBox(height: context.height * .01),
          ChooseUsernameButtonWidget(
            isLoading: state.isLoading,
            isUnique: state.isUnique,
            canPop: canPop,
          ),
        ],
      ),
    );
  }
}
