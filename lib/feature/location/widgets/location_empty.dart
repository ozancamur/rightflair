import 'package:flutter/material.dart';
import 'package:rightflair/core/constants/string.dart';
import 'package:rightflair/core/extensions/context.dart';

import '../../../core/components/text.dart';

class LocationEmptyWidget extends StatelessWidget {
  const LocationEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextComponent(
        text: AppStrings.LOCATION_NO_RESULTS,
        color: context.colors.onPrimary,
      ),
    );
  }
}
