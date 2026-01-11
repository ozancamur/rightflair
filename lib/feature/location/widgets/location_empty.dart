import 'package:flutter/material.dart';

import '../../../core/components/text.dart';
import '../../../core/constants/dark_color.dart';

class LocationEmptyWidget extends StatelessWidget {
  const LocationEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextComponent(
        text: "No results found", // Should be in String constants ideally
        color: AppDarkColors.WHITE60,
      ),
    );
  }
}