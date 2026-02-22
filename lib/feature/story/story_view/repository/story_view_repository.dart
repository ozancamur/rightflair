abstract class StoryViewRepository {
  Future<void> viewStory({required String sId});
  Future<bool> deleteStory({required String storyId});
}
