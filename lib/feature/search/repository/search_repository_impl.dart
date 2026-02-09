import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rightflair/core/base/model/response.dart';
import 'package:rightflair/core/constants/enums/endpoint.dart';
import 'package:rightflair/core/services/api.dart';
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
      throw Exception('Search failed. Please try again.');
    } catch (e) {
      debugPrint("SearchRepositoryImpl ERROR in searchPosts :> $e");
      throw Exception('An unexpected error occurred.');
    }
  }
}
