import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../../core/components/text/text.dart';
import '../../../../core/constants/color/color.dart';
import '../../../../core/extensions/context.dart';

class GalleryMediaGridItem extends StatelessWidget {
  final AssetEntity asset;
  final VoidCallback onTap;

  const GalleryMediaGridItem({
    super.key,
    required this.asset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildThumbnail(context),
          if (asset.type == AssetType.video) _buildVideoDuration(context),
        ],
      ),
    );
  }

  Widget _buildThumbnail(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: asset.thumbnailDataWithSize(const ThumbnailSize.square(300)),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return Image.memory(snapshot.data!, fit: BoxFit.cover);
        }
        return Container(color: context.colors.surfaceContainerHighest);
      },
    );
  }

  Widget _buildVideoDuration(BuildContext context) {
    return Positioned(
      bottom: context.height * .005,
      right: context.width * .01,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.width * .015,
          vertical: context.height * .003,
        ),
        decoration: BoxDecoration(
          color: AppColors.BLACK_70,
          borderRadius: BorderRadius.circular(context.width * .01),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.play_arrow,
              color: AppColors.WHITE,
              size: context.width * .03,
            ),
            SizedBox(width: context.width * .005),
            TextComponent(
              text: _formatDuration(asset.duration),
              tr: false,
              size: const [10],
              color: AppColors.WHITE,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    final minutes = duration.inMinutes;
    final secs = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(1, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}
