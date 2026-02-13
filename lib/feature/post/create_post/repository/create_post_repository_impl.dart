import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rightflair/feature/post/create_post/model/mention_user.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/base/model/response.dart';
import '../../../../core/constants/api.dart';
import '../../../../core/constants/enums/endpoint.dart';
import '../../../../core/constants/storage.dart';
import '../../../../core/services/api.dart';
import '../model/create_post.dart';
import '../model/music.dart';
import 'create_post_repository.dart';

class CreatePostRepositoryImpl implements CreatePostRepository {
  final ApiService _api;
  final Dio _dio;
  final SupabaseClient _supabase;
  CreatePostRepositoryImpl({ApiService? api, Dio? dio, SupabaseClient? supabase})
    : _api = api ?? ApiService(),
      _dio = dio ?? Dio(),
      _supabase = Supabase.instance.client;

  @override
  Future<ResponseModel?> createPost({required CreatePostModel post}) async {
    try {
      final request = await _api.post(
        Endpoint.CREATE_POST,
        data: post.toJson(),
      );
      if (request == null) return null;
      final ResponseModel response = ResponseModel().fromJson(
        request.data as Map<String, dynamic>,
      );
      return response;
    } catch (e) {
      debugPrint("CreatePostRepositoryImpl ERROR in createPost :> $e");
      return null;
    }
  }

  @override
  Future<ResponseModel?> createDraft({required CreatePostModel post}) async {
    try {
      final request = await _api.post(
        Endpoint.CREATE_DRAFT,
        data: post.toJson(),
      );
      if (request == null) return null;
      final ResponseModel response = ResponseModel().fromJson(
        request.data as Map<String, dynamic>,
      );
      return response;
    } catch (e) {
      debugPrint("CreatePostRepositoryImpl ERROR in createDraft :> $e");
      return null;
    }
  }

  @override
  Future<List<MentionUserModel>?> searchUsersForMention({
    required String query,
  }) async {
    try {
      final request = await _api.post(
        Endpoint.SEARCH_USER_FOR_MENTION,
        data: {"query": query, 'limit': 20},
      );
      if (request == null) return [];
      final ResponseModel response = ResponseModel().fromJson(
        request.data as Map<String, dynamic>,
      );
      if (response.success == true && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final list = data['users'] as List<dynamic>?;
        if (list != null) {
          final List<MentionUserModel> users = list
              .map(
                (e) => MentionUserModel().fromJson(e as Map<String, dynamic>),
              )
              .toList();
          return users;
        }
        return [];
      } else {
        return [];
      }
    } catch (e) {
      debugPrint(
        "CreatePostRepositoryImpl ERROR in searchUsersForMention :> $e",
      );
      return [];
    }
  }

  @override
  Future<List<MusicModel>?> searchSong({required String query}) async {
    if (query.trim().isEmpty) return [];

    try {
      final response = await _dio.get(ApiConstants.MUSIC(query: query));

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map<String, dynamic> && data['data'] != null) {
          final List<dynamic> tracks = data['data'] as List<dynamic>;
          return tracks.map((track) => MusicModel().fromJson(track)).toList();
        }
      }
      return [];
    } catch (e) {
      debugPrint("CreatePostRepositoryImpl ERROR in searchSong: $e");
      return [];
    }
  }

  @override
  Future<String?> uploadStoryImage({
    required String userId,
    required File file,
  }) async {
  try {
      final String? authenticatedUserId = _supabase.auth.currentUser?.id;

      if (authenticatedUserId == null) {
        debugPrint(
          "CreatePostRepositoryImpl ERROR in uploadStoryImage: User not authenticated",
        );
        return null;
      }

      final String extension = file.path.split('.').last;
      final String name = StorageConstants.FILE_NAME(extension);
      final String path = StorageConstants.POST_PHOTO_PATH(
        authenticatedUserId,
        name,
      );

      await _supabase.storage
          .from(StorageConstants.STORAGE_ID)
          .upload(
            path,
            file,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
          );

      final String publicUrl = _supabase.storage
          .from(StorageConstants.STORAGE_ID)
          .getPublicUrl(path);

      return publicUrl;
    } catch (e) {
      debugPrint("CreateStoryRepositoryImpl ERROR in uploadStoryImage :> $e");
      return null;
    }
  }
}
