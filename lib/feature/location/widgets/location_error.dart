import 'package:flutter/material.dart';

import '../../../core/components/text.dart';

class LocationErrorWidget extends StatelessWidget {
  final String message;
  const LocationErrorWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(child: TextComponent(text: message));
  }
}
