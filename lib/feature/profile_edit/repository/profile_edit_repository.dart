import 'dart:io';

abstract class ProfileEditRepository {
  Future<void> updateUser({
    String? fullName,
    String? bio,
    String? profilePhotoUrl,
  });

  Future<String?> uploadProfilePhoto({
    required String userId,
    required File imageFile,
  });

  Future<void> updateUserStyleTags({required List<String> tags});
}
