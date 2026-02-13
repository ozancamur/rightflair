class StorageConstants {
  const StorageConstants._();

  // PROFILE PHOTO STORAGE
  static String FILE_NAME(String fileExtension) =>
      "profile_${DateTime.now().millisecondsSinceEpoch}.$fileExtension";

  static String PROFILE_PHOTO_PATH(String userId, String fileName) =>
      '$userId/profile-photos/$fileName';

  static String STORY_PHOTO_PATH(String userId, String fileName) =>
      '$userId/stories/$fileName';

  static String POST_PHOTO_PATH(String userId, String fileName) =>
      '$userId/posts/$fileName';

  static const String STORAGE_ID = "profile-photos";
}
