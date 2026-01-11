import 'package:flutter/material.dart';

import '../../../core/constants/dark_color.dart';
import '../model/location_model.dart';
import 'location_card.dart';

class LocationListWidget extends StatelessWidget {
  final List<LocationModel> list;
  const LocationListWidget({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: list.length,
      separatorBuilder: (context, index) =>
          Divider(color: AppDarkColors.WHITE16),
      itemBuilder: (context, index) =>
          LocationCardWidget(location: list[index]),
    );
  }
}
