import 'package:flutter/material.dart';

import '../../../core/base/model/response.dart';
import '../../../core/constants/enums/endpoint.dart';
import '../../../core/services/api.dart';
import '../../main/feed/models/comment.dart';
import '../../main/feed/models/request_comment.dart';
import 'comment_repository.dart';

class CommentsRepositoryImpl extends CommentsRepository {
  final ApiService _api;
  CommentsRepositoryImpl({ApiService? api}) : _api = api ?? ApiService();

  @override
  Future<List<CommentModel>?> fetchPostComments({required String pId}) async {
    try {
      final request = await _api.post(
        Endpoint.GET_POST_COMMENTS,
        data: {"post_id": pId},
      );
      if(request == null) return null;
      final ResponseModel response = ResponseModel().fromJson(
        request.data as Map<String, dynamic>,
      );
      if(request.data == null) return null;
      final List<CommentModel> data =
          ((response.data as Map<String, dynamic>)['comments'] as List<dynamic>)
              .map((e) => CommentModel().fromJson(e as Map<String, dynamic>))
              .toList();
      return data;
    } catch (e) {
      debugPrint("CommentsRepositoryImpl ERROR in getPostComments :> $e");
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
      debugPrint("CommentsRepositoryImpl ERROR in sendCommentToPost :> $e");
      return null;
    }
  }
}
