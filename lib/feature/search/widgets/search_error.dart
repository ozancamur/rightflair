import 'package:flutter/material.dart';

import '../../../core/components/text/text.dart';
import '../../../core/constants/font/font_size.dart';
import '../../../core/extensions/context.dart';

class SearchErrorWidget extends StatelessWidget {
  final String message;
  const SearchErrorWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: context.colors.error),
          SizedBox(height: context.height * 0.02),
          TextComponent(
            text: message,
            color: context.colors.error,
            size: FontSizeConstants.NORMAL,
            align: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
