import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/core/components/text/text.dart';
import 'package:rightflair/core/constants/font/font_size.dart';

import '../../../core/components/text/text_field.dart';
import '../../../core/constants/string.dart';
import '../../../core/extensions/context.dart';
import '../cubit/choose_username_cubit.dart';

class ChooseUsernameTextField extends StatelessWidget {
  final bool isLoading;
  final bool? isValid;
  final String hintText;
  const ChooseUsernameTextField({
    super.key,
    this.isValid,
    required this.hintText,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = context
        .read<ChooseUsernameCubit>()
        .controller;

    final FocusNode focusNode = context.read<ChooseUsernameCubit>().focusNode;
    return controller.text == ""
        ? _field(context, controller, focusNode)
        : isLoading
        ? _field(context, controller, focusNode)
        : _valid(context, controller, focusNode, isValid ?? false);
  }

  TextFieldComponent _field(
    BuildContext context,
    TextEditingController controller,
    FocusNode focusNode,
  ) {
    return TextFieldComponent(
      focusNode: focusNode,
      key: const ValueKey('username_textfield'),
      controller: controller,
      hintText: hintText,
      regExp: RegExp(''),
      errorText: "",
      inputFormatters: [LowerCaseTextFormatter()],
      onChanged: (value) {
        context.read<ChooseUsernameCubit>().onTextChanged();
      },
    );
  }

  Column _valid(
    BuildContext context,
    TextEditingController controller,
    FocusNode focusNode,
    bool isValid,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _field(context, controller, focusNode),
        _text(context, controller.text, isValid),
      ],
    );
  }

  Padding _text(BuildContext context, String username, bool isValid) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.width * .05),
      child: TextComponent(
        text:
            (isValid
                    ? AppStrings.CHOOSE_USERNAME_IS_AVAILABLE
                    : AppStrings.CHOOSE_USERNAME_IS_NOT_AVAILABLE)
                .tr(args: [username]),
        color: isValid ? context.colors.inverseSurface : context.colors.error,
        size: FontSizeConstants.XX_SMALL,
        weight: FontWeight.w400,
      ),
    );
  }
}

class LowerCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toLowerCase(),
      selection: newValue.selection,
    );
  }
}
