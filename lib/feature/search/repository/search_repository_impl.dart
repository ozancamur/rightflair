import 'package:flutter/material.dart';
import 'package:rightflair/core/services/api.dart';
import 'package:rightflair/feature/search/repository/search_repository.dart';

import '../../../core/base/model/response.dart';
import '../../../core/constants/enums/endpoint.dart';
import '../../main/profile/model/pagination.dart';
import '../../share/model/search_response.dart';

class SearchRepositoryImpl extends SearchRepository {
  final ApiService _api;
  SearchRepositoryImpl({ApiService? api}) : _api = api ?? ApiService();

  @override
  Future<SearchReponseModel?> searchUsers({
    required String query,
    required PaginationModel pagination,
  }) async {
    try {
      final request = await _api.post(
        Endpoint.SEARCH_USER,
        data: {
          'query': query,
          'page': pagination.page,
          'limit': pagination.limit,
        },
      );
      if (request?.data == null) return null;
      final ResponseModel response = ResponseModel().fromJson(
        request!.data as Map<String, dynamic>,
      );
      if (response.data == null) return null;
      final SearchReponseModel data = SearchReponseModel().fromJson(
        response.data as Map<String, dynamic>,
      );
      return data;
    } catch (e) {
      debugPrint("SearchRepositoryImpl ERROR in searchUsers: $e");
      return null;
    }
  }
}
