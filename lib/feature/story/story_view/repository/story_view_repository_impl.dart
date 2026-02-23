import 'package:flutter/material.dart';

import '../../../../core/constants/enums/endpoint.dart';
import '../../../../core/services/api.dart';
import '../model/story_viewers_response.dart';
import 'story_view_repository.dart';

class StoryViewRepositoryImpl extends StoryViewRepository {
  final ApiService _api;
  StoryViewRepositoryImpl({ApiService? api}) : _api = api ?? ApiService();
  @override
  Future<void> viewStory({required String sId}) async {
    try {
      await _api.post(Endpoint.VIEW_STORY, data: {'story_id': sId});
    } catch (e) {
      debugPrint("FeedRepositoryImpl ERROR in viewStory :> $e");
    }
  }

  @override
  Future<bool> deleteStory({required String storyId}) async {
    try {
      final response = await _api.post(
        Endpoint.DELETE_STORY,
        data: {'story_id': storyId},
      );
      if (response == null) return false;
      final data = response.data as Map<String, dynamic>?;
      return data?['success'] == true;
    } catch (e) {
      debugPrint("StoryViewRepositoryImpl ERROR in deleteStory :> $e");
      return false;
    }
  }

  @override
  Future<StoryViewersResponse?> getStoryViewers({
    required String storyId,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _api.post(
        Endpoint.GET_STORY_VIEWERS,
        data: {'story_id': storyId, 'page': page, 'limit': limit},
      );
      if (response == null) return null;
      final data = response.data as Map<String, dynamic>?;
      if (data == null || data['success'] != true) return null;
      return StoryViewersResponse.fromJson(
        data['data'] as Map<String, dynamic>,
      );
    } catch (e) {
      debugPrint("StoryViewRepositoryImpl ERROR in getStoryViewers :> $e");
      return null;
    }
  }
}
