import 'package:flutter/material.dart';
import 'package:rightflair/core/base/model/response.dart';
import 'package:rightflair/core/constants/endpoint.dart';
import 'package:rightflair/feature/navigation/page/feed/models/request_comment.dart';
import 'package:rightflair/feature/navigation/page/profile/model/pagination.dart';

import 'package:rightflair/feature/navigation/page/profile/model/request_post.dart';

import '../../../../../core/services/api.dart';
import '../../profile/model/response_post.dart';
import '../models/comment.dart';
import '../models/my_story.dart';
import '../models/story_response.dart';
import 'feed_repository.dart';

class FeedRepositoryImpl extends FeedRepository {
  final ApiService _api;
  FeedRepositoryImpl({ApiService? api}) : _api = api ?? ApiService();

  @override
  Future<ResponsePostModel?> fetchDiscoverFeed({
    required RequestPostModel body,
  }) async {
    try {
      final request = await _api.post(
        Endpoint.GET_DISCOVER_FEED,
        data: body.toJson(),
      );
      if (request == null) return null;
      final ResponseModel response = ResponseModel().fromJson(
        request.data as Map<String, dynamic>,
      );
      if (request.data == null) return null;
      final ResponsePostModel data = ResponsePostModel().fromJson(
        response.data as Map<String, dynamic>,
      );
      return data;
    } catch (e) {
      debugPrint("FeedRepositoryImpl ERROR in fetchDiscoverFeed :> $e");
      return null;
    }
  }

  @override
  Future<ResponsePostModel?> fetchFollowingFeed({
    required RequestPostModel body,
  }) async {
    try {
      final request = await _api.post(
        Endpoint.GET_FOLLOWING_FEED,
        data: body.toJson(),
      );
      if (request == null) return null;
      final ResponseModel response = ResponseModel().fromJson(
        request.data as Map<String, dynamic>,
      );
      if (request.data == null) return null;
      final ResponsePostModel data = ResponsePostModel().fromJson(
        response.data as Map<String, dynamic>,
      );
      return data;
    } catch (e) {
      debugPrint("FeedRepositoryImpl ERROR in fetchDiscoverFeed :> $e");
      return null;
    }
  }

  @override
  Future<ResponsePostModel?> fetchFriendFeed({
    required RequestPostModel body,
  }) async {
    try {
      final request = await _api.post(
        Endpoint.GET_FRIENDS_FEED,
        data: body.toJson(),
      );
      if (request == null) return null;
      final ResponseModel response = ResponseModel().fromJson(
        request.data as Map<String, dynamic>,
      );
      if (request.data == null) return null;
      final ResponsePostModel data = ResponsePostModel().fromJson(
        response.data as Map<String, dynamic>,
      );
      return data;
    } catch (e) {
      debugPrint("FeedRepositoryImpl ERROR in fetchDiscoverFeed :> $e");
      return null;
    }
  }

  @override
  Future<bool> likePost({required String pId}) async {
    try {
      final request = await _api.post(
        Endpoint.POST_LIKE,
        data: {'post_id': pId},
      );
      if (request == null) return false;
      final ResponseModel response = ResponseModel().fromJson(
        request.data as Map<String, dynamic>,
      );
      if (request.data == null) return false;
      return response.success ?? false;
    } catch (e) {
      debugPrint("FeedRepositoryImpl ERROR in dislikePost :> $e");
      return false;
    }
  }

  @override
  Future<bool> dislikePost({required String pId}) async {
    try {
      final request = await _api.post(
        Endpoint.POST_DISLIKE,
        data: {'post_id': pId},
      );
      if (request == null) return false;
      final ResponseModel response = ResponseModel().fromJson(
        request.data as Map<String, dynamic>,
      );
      if (request.data == null) return false;
      return response.success ?? false;
    } catch (e) {
      debugPrint("FeedRepositoryImpl ERROR in dislikePost :> $e");
      return false;
    }
  }

  @override
  Future<List<CommentModel>?> fetchPostComments({required String pId}) async {
    try {
      final request = await _api.post(
        Endpoint.GET_POST_COMMENTS,
        data: {"post_id": pId},
      );
      if (request == null) return null;
      final ResponseModel response = ResponseModel().fromJson(
        request.data as Map<String, dynamic>,
      );
      if (request.data == null) return null;
      final List<CommentModel> data =
          ((response.data as Map<String, dynamic>)['comments'] as List<dynamic>)
              .map((e) => CommentModel().fromJson(e as Map<String, dynamic>))
              .toList();
      return data;
    } catch (e) {
      debugPrint("FeedRepositoryImpl ERROR in getPostComments :> $e");
      return null;
    }
  }

  @override
  Future<CommentModel?> sendCommentToPost({
    required RequestCommentModel body,
  }) async {
    try {
      final request = await _api.post(
        Endpoint.CREATE_COMMENT,
        data: body.toJson(),
      );
      if (request == null) return null;
      final ResponseModel response = ResponseModel().fromJson(
        request.data as Map<String, dynamic>,
      );
      if (request.data == null) return null;
      final CommentModel data = CommentModel().fromJson(
        response.data as Map<String, dynamic>,
      );
      return data;
    } catch (e) {
      debugPrint("FeedRepositoryImpl ERROR in sendCommentToPost :> $e");
      return null;
    }
  }

  @override
  Future<void> savePost({required String pId}) async {
    try {
      await _api.post(Endpoint.SAVE_POST, data: {'post_id': pId});
    } catch (e) {
      debugPrint("FeedRepositoryImpl ERROR in sendCommentToPost :> $e");
    }
  }

  @override
  Future<StoryResponseModel?> fetchStories({
    required PaginationModel pagination,
  }) async {
    try {
      final request = await _api.post(
        Endpoint.GET_STORIES,
        data: pagination.toJson(),
      );
      if (request == null) return null;
      final ResponseModel response = ResponseModel().fromJson(
        request.data as Map<String, dynamic>,
      );
      if (response.data == null) return null;
      final StoryResponseModel data = StoryResponseModel().fromJson(
        response.data as Map<String, dynamic>,
      );
      return data;
    } catch (e) {
      debugPrint("FeedRepositoryImpl ERROR in fetchStories :> $e");
      return null;
    }
  }

  @override
  Future<MyStoryModel?> fetchMyStories() async {
    try {
      final request = await _api.get(Endpoint.GET_MY_STORIES);
      if (request == null || request.data == null) return null;
      final ResponseModel response = ResponseModel().fromJson(
        request.data as Map<String, dynamic>,
      );
      if (response.data == null) return null;
      final MyStoryModel data = MyStoryModel().fromJson(
        response.data as Map<String, dynamic>,
      );
      return data;
    } catch (e) {
      debugPrint("FeedRepositoryImpl ERROR in fetchMyStories :> $e");
      return null;
    }
  }


}
