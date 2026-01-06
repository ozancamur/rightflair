import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/string.dart';
import '../../../../../core/extensions/context.dart';
import '../../../../../core/helpers/text_color.dart';

class WelcomeTitleWidget extends StatelessWidget {
  const WelcomeTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.width * .15),
      child: AutoSizeText.rich(
        TextSpan(
          children: helperTextStyle(context, AppStrings.WELCOME_TITLE.tr()),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
