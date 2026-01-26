import 'package:flutter/material.dart';

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
}
