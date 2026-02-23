import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:rightflair/core/constants/string.dart';
import 'package:rightflair/feature/main/feed/models/story.dart';

class StoryContent extends StatelessWidget {
  final StoryModel? story;

  const StoryContent({super.key, this.story});

  @override
  Widget build(BuildContext context) {
    if (story == null || story!.mediaUrl == null) {
      return const Center(
        child: Text(
          'Story not available',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    // Check media type (image or video)
    final isVideo = story!.mediaType?.toLowerCase() == 'video';

    if (isVideo) {
      // For video, you might want to use video_player package
      // For now, showing a placeholder
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.play_circle_outline,
              size: 80,
              color: Colors.white,
            ),
            const SizedBox(height: 16),
            Text(
              'Video Story',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      );
    }

    // Image story
    return SizedBox.expand(
      child: Image.network(
        story!.mediaUrl!,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                  : null,
              color: Colors.white,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 60, color: Colors.white),
                const SizedBox(height: 16),
                Text(
                  AppStrings.STORY_FAILED_TO_LOAD.tr(),
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
