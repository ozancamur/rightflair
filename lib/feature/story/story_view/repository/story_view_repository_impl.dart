import 'package:flutter/material.dart';

import '../../../../core/constants/enums/endpoint.dart';
import '../../../../core/services/api.dart';
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
}
