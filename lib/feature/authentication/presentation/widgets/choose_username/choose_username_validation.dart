import 'package:flutter/material.dart';
import 'package:rightflair/core/constants/string.dart';

import '../../../../../core/extensions/context.dart';
import 'choose_username_validation_item.dart';

class ChooseUsernameValidationWidget extends StatelessWidget {
  final bool isUnique;
  final bool isCaseInsensitive;

  const ChooseUsernameValidationWidget({
    super.key,
    required this.isUnique,
    required this.isCaseInsensitive,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.width * .03,
        vertical: context.height * .02,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: context.height * .015,
        children: [
          ChooseUsernameValidationItem(
            label: AppStrings.CHOOSE_USERNAME_UNIQUE,
            isValid: isUnique,
          ),
          ChooseUsernameValidationItem(
            label: AppStrings.CHOOSE_USERNAME_CASE_INSENSITIVE,
            isValid: isCaseInsensitive,
          ),
        ],
      ),
    );
  }
}
