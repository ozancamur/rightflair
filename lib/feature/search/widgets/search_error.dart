import 'package:flutter/material.dart';

import '../../../core/components/text/text.dart';
import '../../../core/constants/font/font_size.dart';
import '../../../core/constants/string.dart';
import '../../../core/extensions/context.dart';

class SearchErrorWidget extends StatelessWidget {
  const SearchErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.no_accounts, size: 64, color: context.colors.error),
          SizedBox(height: context.height * 0.02),
          TextComponent(
            text: AppStrings.GENERAL_USER_NOT_FOUND,
            color: context.colors.error,
            size: FontSizeConstants.NORMAL,
            align: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
