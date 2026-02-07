import 'dart:io';

import '../model/create_story.dart';

abstract class CreateStoryRepository {
  Future<String?> uploadStoryImage({
    required String userId,
    required File file,
  });
  Future<void> createStory({required CreateStoryModel data});
}
