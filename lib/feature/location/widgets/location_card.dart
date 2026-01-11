import 'package:flutter/material.dart';
import 'package:rightflair/core/constants/font_size.dart';

import '../../../core/components/text.dart';
import '../model/location_model.dart';

class LocationCardWidget extends StatelessWidget {
  final LocationModel location;
  const LocationCardWidget({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: TextComponent(
        text: location.fullDisplayName,
        size: FontSizeConstants.LARGE,
      ),
      onTap: () => Navigator.pop(context, location.fullDisplayName),
    );
  }
}
