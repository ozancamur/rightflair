import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rightflair/core/base/model/response.dart';
import 'package:rightflair/core/constants/enums/endpoint.dart';
import 'package:rightflair/core/constants/string.dart';
import 'package:rightflair/core/services/api.dart';
import 'package:rightflair/feature/main/feed/models/comment.dart';
import 'package:rightflair/feature/main/feed/models/request_comment.dart';
import 'package:rightflair/feature/search/model/request_search.dart';
import 'package:rightflair/feature/search/model/response_search.dart';
import 'package:rightflair/feature/search/repository/search_repository.dart';

class SearchRepositoryImpl extends SearchRepository {
  final ApiService _api;
  SearchRepositoryImpl({ApiService? api}) : _api = api ?? ApiService();

  @override
  Future<ResponseSearchModel?> searchPosts({
    required RequestSearchModel body,
  }) async {
    try {
      final request = await _api.post(
        Endpoint.SEARCH_POSTS,
        data: body.toJson(),
      );

      if (request == null) return null;

      final ResponseModel response = ResponseModel().fromJson(
        request.data as Map<String, dynamic>,
      );

      if (response.data == null) return null;

      final ResponseSearchModel data = ResponseSearchModel().fromJson(
        response.data as Map<String, dynamic>,
      );

      return data;
    } on DioException catch (e) {
      debugPrint("SearchRepositoryImpl ERROR in searchPosts :> $e");

      // Extract error message from response
      if (e.response != null && e.response!.data != null) {
        final data = e.response!.data;
        if (data is Map<String, dynamic>) {
          final errorMessage =
              data['error'] as String? ?? data['message'] as String?;
          if (errorMessage != null) {
            throw Exception(errorMessage);
          }
        }
      }
      throw Exception(AppStrings.SEARCH_FAILED.tr());
    } catch (e) {
      debugPrint("SearchRepositoryImpl ERROR in searchPosts :> $e");
      throw Exception(
        AppStrings.SEARCH_UNEXPECTED_ERROR.tr(args: [e.toString()]),
      );
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
      return response.success ?? false;
    } catch (e) {
      debugPrint("SearchRepositoryImpl ERROR in likePost :> $e");
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
      return response.success ?? false;
    } catch (e) {
      debugPrint("SearchRepositoryImpl ERROR in dislikePost :> $e");
      return false;
    }
  }

  @override
  Future<void> savePost({required String pId}) async {
    try {
      await _api.post(Endpoint.SAVE_POST, data: {'post_id': pId});
    } catch (e) {
      debugPrint("SearchRepositoryImpl ERROR in savePost :> $e");
    }
  }

  @override
  Future<List<CommentModel>?> fetchPostComments({required String pId}) async {
    try {
      final request = await _api.post(
        Endpoint.GET_POST_COMMENTS,
        data: {'post_id': pId},
      );
      if (request == null) return null;
      final ResponseModel response = ResponseModel().fromJson(
        request.data as Map<String, dynamic>,
      );
      if (response.data == null) return null;
      final List<CommentModel> data =
          ((response.data as Map<String, dynamic>)['comments'] as List<dynamic>)
              .map((e) => CommentModel().fromJson(e as Map<String, dynamic>))
              .toList();
      return data;
    } catch (e) {
      debugPrint("SearchRepositoryImpl ERROR in fetchPostComments :> $e");
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
      if (response.data == null) return null;
      final CommentModel data = CommentModel().fromJson(
        response.data as Map<String, dynamic>,
      );
      return data;
    } catch (e) {
      debugPrint("SearchRepositoryImpl ERROR in sendCommentToPost :> $e");
      return null;
    }
  }
}
