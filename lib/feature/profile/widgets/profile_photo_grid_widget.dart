import 'package:flutter/material.dart';
import 'package:rightflair/core/extensions/context.dart';

import 'profile_photo_grid_item.dart';

class ProfilePhotoGridWidget extends StatelessWidget {
  final List<String> photos;
  const ProfilePhotoGridWidget({super.key, required this.photos});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: context.width * 0.02,
        mainAxisSpacing: context.width * 0.02,
        childAspectRatio: 0.75,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) =>
          ProfilePhotoGridItemWidget(photo: photos[index]),
    );
  }
}
