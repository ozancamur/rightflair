import 'package:flutter/material.dart';
import 'package:rightflair/core/base/model/response.dart';
import 'package:rightflair/core/constants/endpoint.dart';
import 'package:rightflair/feature/navigation/page/feed/models/request_comment.dart';

import 'package:rightflair/feature/navigation/page/profile/model/request_post.dart';

import '../../../../../core/services/api.dart';
import '../../profile/model/response_post.dart';
import '../models/comment.dart';
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
      final ResponseModel response = ResponseModel().fromJson(
        request.data as Map<String, dynamic>,
      );
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
      final ResponseModel response = ResponseModel().fromJson(
        request.data as Map<String, dynamic>,
      );
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
      final ResponseModel response = ResponseModel().fromJson(
        request.data as Map<String, dynamic>,
      );
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
  Future<void> likePost({required String pId}) async {
    try {
      final request = await _api.post(
        Endpoint.POST_LIKE,
        data: {'post_id': pId},
      );
      final ResponseModel response = ResponseModel().fromJson(
        request.data as Map<String, dynamic>,
      );
      print("Like Post Response :> ${response.toJson()}");
    } catch (e) {
      debugPrint("FeedRepositoryImpl ERROR in dislikePost :> $e");
    }
  }

  @override
  Future<void> dislikePost({required String pId}) async {
    try {
      final request = await _api.post(
        Endpoint.POST_DISLIKE,
        data: {'post_id': pId},
      );
      final ResponseModel response = ResponseModel().fromJson(
        request.data as Map<String, dynamic>,
      );
      print("Like Post Response :> ${response.toJson()}");
    } catch (e) {
      debugPrint("FeedRepositoryImpl ERROR in dislikePost :> $e");
    }
  }

  @override
  Future<List<CommentModel>?> fetchPostComments({required String pId}) async {
    try {
      final request = await _api.post(
        Endpoint.GET_POST_COMMENTS,
        data: {"post_id": pId},
      );
      final ResponseModel response = ResponseModel().fromJson(
        request.data as Map<String, dynamic>,
      );
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
      final ResponseModel response = ResponseModel().fromJson(
        request.data as Map<String, dynamic>,
      );
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
}
