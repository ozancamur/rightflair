import 'package:flutter/material.dart';

import '../../../core/constants/endpoint.dart';
import '../../../core/services/api.dart';
import 'story_repository.dart';

class StoryRepositoryImpl extends StoryRepository {
  final ApiService _api;
  StoryRepositoryImpl({ApiService? api}) : _api = api ?? ApiService();
  @override
  Future<void> viewStory({required String sId}) async {
    try {
      await _api.post(Endpoint.VIEW_STORY, data: {'story_id': sId});
    } catch (e) {
      debugPrint("FeedRepositoryImpl ERROR in viewStory :> $e");
    }
  }
}
