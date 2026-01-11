import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/components/text_field.dart';
import '../../../core/constants/string.dart';

class LocationInputWidget extends StatelessWidget {
  final TextEditingController controller;
  const LocationInputWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFieldComponent(
      controller: controller,
      hintText: AppStrings.CREATE_POST_SEARCH_LOCATION.tr(),
      regExp: RegExp(r'.*'),
      errorText: '',
      onTap: () {},
    );
  }
}
