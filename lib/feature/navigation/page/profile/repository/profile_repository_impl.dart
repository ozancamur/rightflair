import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:rightflair/core/constants/endpoint.dart';
import 'package:rightflair/core/services/api.dart';
import 'package:rightflair/feature/authentication/model/user.dart';
import 'package:rightflair/feature/navigation/page/profile/model/style_tags.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/base/model/response.dart';
import '../model/request_post.dart';
import '../model/response_post.dart';
import 'profile_repository.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  final ApiService _api;
  final SupabaseClient _supabase;

  ProfileRepositoryImpl({ApiService? api})
    : _api = api ?? ApiService(),
      _supabase = Supabase.instance.client;

  @override
  Future<UserModel?> getUser() async {
    try {
      final request = await _api.get(Endpoint.GET_USER);
      final ResponseModel response = ResponseModel().fromJson(
        request.data as Map<String, dynamic>,
      );
      if (response.data == null) return null;
      final UserModel data = UserModel().fromJson(
        response.data as Map<String, dynamic>,
      );
      return data;
    } catch (e) {
      debugPrint("ProfileRepositoryImpl ERROR in getUser :> $e");
      return null;
    }
  }

  @override
  Future<StyleTagsModel?> getUserStyleTags() async {
    try {
      final request = await _api.get(Endpoint.GET_USER_STYLE_TAGS);
      final ResponseModel response = ResponseModel().fromJson(
        request.data as Map<String, dynamic>,
      );
      final StyleTagsModel data = StyleTagsModel().fromJson(
        response.data as Map<String, dynamic>,
      );
      return data;
    } catch (e) {
      debugPrint("ProfileRepositoryImpl ERROR in getUserStyleTags :> $e");
      return null;
    }
  }

  @override
  Future<void> updateUser({String? profilePhotoUrl}) async {
    try {
      final Map<String, dynamic> data = {};
      if (profilePhotoUrl != null) data['profilePhotoUrl'] = profilePhotoUrl;

      if (data.isNotEmpty) {
        await _api.post(Endpoint.UPDATE_USER, data: data);
      }
    } catch (e) {
      debugPrint("ProfileRepositoryImpl ERROR in updateUser :> $e");
    }
  }

  @override
  Future<String?> uploadProfilePhoto({
    required String userId,
    required File imageFile,
  }) async {
    try {
      final String fileExtension = imageFile.path.split('.').last;
      final String fileName =
          'profile_${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
      final String storagePath = '$userId/profile-photos/$fileName';

      await _supabase.storage
          .from('profile-photos')
          .upload(
            storagePath,
            imageFile,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
          );

      final String publicUrl = _supabase.storage
          .from('profile-photos')
          .getPublicUrl(storagePath);

      return publicUrl;
    } catch (e) {
      debugPrint("ProfileRepositoryImpl ERROR in uploadProfilePhoto :> $e");
      return null;
    }
  }

  @override
  Future<ResponsePostModel?> getUserPosts({
    required RequestPostModel parameters,
  }) async {
    try {
      final request = await _api.get(
        Endpoint.GET_USER_POSTS,
        parameters: parameters.toJson(),
      );
      // ResponseModel wrapper'ı kaldırdık çünkü API direkt olarak posts ve pagination dönüyor
      final ResponsePostModel data = ResponsePostModel().fromJson(
        request.data as Map<String, dynamic>,
      );
      return data;
    } catch (e) {
      debugPrint("ProfileRepositoryImpl ERROR in getUserPosts :> $e");
      return null;
    }
  }

  @override
  Future<ResponsePostModel?> getUserSavedPosts({
    required RequestPostModel parameters,
  }) async {
    try {
      final request = await _api.post(
        Endpoint.GET_USER_SAVED_POSTS,
        parameters: parameters.toJson(),
      );

      final ResponsePostModel data = ResponsePostModel().fromJson(
        request.data as Map<String, dynamic>,
      );
      return data;
    } catch (e) {
      debugPrint("ProfileRepositoryImpl ERROR in getUserSavedPosts :> $e");
      return null;
    }
  }

  @override
  Future<ResponsePostModel?> getUserDrafts({
    required RequestPostModel parameters,
  }) async {
    try {
      final request = await _api.get(
        Endpoint.GET_USER_DRAFTS,
        parameters: parameters.toJson(),
      );

      final ResponsePostModel data = ResponsePostModel().fromJson(
        request.data as Map<String, dynamic>,
      );
      return data;
    } catch (e) {
      debugPrint("ProfileRepositoryImpl ERROR in getUserDrafts :> $e");
      return null;
    }
  }
}
