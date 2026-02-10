import 'dart:io';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/enums/endpoint.dart';
import '../../../../core/constants/storage.dart';
import '../../../../core/services/api.dart';
import '../model/create_story.dart';
import 'create_story_repository.dart';

class CreateStoryRepositoryImpl extends CreateStoryRepository {
  final ApiService _api;
  final SupabaseClient _supabase;

  CreateStoryRepositoryImpl({ApiService? api})
    : _api = api ?? ApiService(),
      _supabase = Supabase.instance.client;

  @override
  Future<void> createStory({required CreateStoryModel data}) async {
    try {
      await _api.post(Endpoint.CREATE_STORY, data: data.toJson());
    } catch (e) {
      debugPrint("CreateStoryRepositoryImpl ERROR in createStory :> $e");
    }
  }

  @override
  Future<String?> uploadStoryImage({
    required String userId,
    required File file,
  }) async {
    try {
      final String extension = file.path.split('.').last;
      final String name = StorageConstants.STORY_FILE_NAME(extension);
      final String path = StorageConstants.STORY_STORAGE_PATH(userId, name);

      await _supabase.storage
          .from(StorageConstants.STORY_STORAGE_ID)
          .upload(
            path,
            file,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
          );

      final String publicUrl = _supabase.storage
          .from(StorageConstants.STORY_STORAGE_ID)
          .getPublicUrl(path);

      return publicUrl;
    } catch (e) {
      debugPrint("ProfileRepositoryImpl ERROR in uploadStoryImage :> $e");
      return null;
    }
  }
}
