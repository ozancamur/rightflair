import 'package:flutter/material.dart';
import 'package:rightflair/core/base/model/response.dart';

import '../../../core/constants/endpoint.dart';
import '../../../core/services/api.dart';
import 'post_detail_repository.dart';

class PostDetailRepositoryImpl extends PostDetailRepository {
  final ApiService _api;
  PostDetailRepositoryImpl({ApiService? api}) : _api = api ?? ApiService();

  @override
  Future<void> savePost({required String pId}) async {
    try {
      await _api.post(Endpoint.SAVE_POST, data: {'post_id': pId});
    } catch (e) {
      debugPrint("PostDetailRepositoryImpl ERROR in savePost :> $e");
    }
  }

  @override
  Future<bool> deletePost({required String pId}) async {
    try {
      final request = await _api.post(
        Endpoint.DELETE_POST,
        data: {'post_id': pId},
      );
      final ResponseModel response = ResponseModel().fromJson(
        request.data as Map<String, dynamic>,
      );
      return response.success ?? false;
    } catch (e) {
      debugPrint("PostDetailRepositoryImpl ERROR in deletePost :> $e");
      return false;
    }
  }
}
