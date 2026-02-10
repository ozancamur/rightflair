import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rightflair/core/constants/enums/endpoint.dart';
import 'package:rightflair/core/services/api.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/constants/storage.dart';
import 'profile_edit_repository.dart';

class ProfileEditRepositoryImpl extends ProfileEditRepository {
  final ApiService _api;
  final SupabaseClient _supabase;

  ProfileEditRepositoryImpl({ApiService? api})
    : _api = api ?? ApiService(),
      _supabase = Supabase.instance.client;

  @override
  Future<void> updateUser({
    String? fullName,
    String? bio,
    String? profilePhotoUrl,
  }) async {
    try {
      final Map<String, dynamic> data = {};
      if (fullName != null) data['fullName'] = fullName;
      if (bio != null) data['bio'] = bio;
      if (profilePhotoUrl != null) data['profilePhotoUrl'] = profilePhotoUrl;

      if (data.isNotEmpty) {
        await _api.post(Endpoint.UPDATE_USER, data: data);
      }
    } catch (e) {
      debugPrint("ProfileEditRepositoryImpl ERROR in updateUser :> $e");
    }
  }

  @override
  Future<String?> uploadProfilePhoto({
    required String userId,
    required File imageFile,
  }) async {
    try {
      final String fileExtension = imageFile.path.split('.').last;
      final String fileName = StorageConstants.FILE_NAME(fileExtension);
      final String storagePath = StorageConstants.PROFILE_PHOTO_PATH(
        userId,
        fileName,
      );

      await _supabase.storage
          .from(StorageConstants.STORAGE_ID)
          .upload(
            storagePath,
            imageFile,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
          );

      final String publicUrl = _supabase.storage
          .from(StorageConstants.STORAGE_ID)
          .getPublicUrl(storagePath);

      return publicUrl;
    } catch (e) {
      debugPrint("ProfileEditRepositoryImpl ERROR in uploadProfilePhoto :> $e");
      return null;
    }
  }

  @override
  Future<void> updateUserStyleTags({required List<String> tags}) async {
    try {
      await _api.post(
        Endpoint.UPDATE_USER_STYLE_TAGS,
        data: {'style_tags': tags},
      );
    } catch (e) {
      debugPrint(
        "ProfileEditRepositoryImpl ERROR in updateUserStyleTags :> $e",
      );
    }
  }
}
