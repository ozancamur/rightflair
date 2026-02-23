import '../model/story_viewers_response.dart';

abstract class StoryViewRepository {
  Future<void> viewStory({required String sId});
  Future<bool> deleteStory({required String storyId});
  Future<StoryViewersResponse?> getStoryViewers({
    required String storyId,
    int page = 1,
    int limit = 20,
  });
}
