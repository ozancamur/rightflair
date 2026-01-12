import 'package:flutter/material.dart';

import '../../../../../../core/extensions/context.dart';

class ProfileHeaderImageWidget extends StatelessWidget {
  final String url;
  const ProfileHeaderImageWidget({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.height * 0.12,
      width: context.height * 0.12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: NetworkImage(url),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
