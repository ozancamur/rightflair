class StorageConstants {
  const StorageConstants._();


  // PROFILE PHOTO STORAGE
  static String PROFILE_FILE_NAME(String fileExtension) =>
      "profile_${DateTime.now().millisecondsSinceEpoch}.$fileExtension";

  static String PROFILE_STORAGE_PATH(String userId, String fileName) =>
      '$userId/profile-photos/$fileName';

  static const String PROFILE_STORAGE_ID = "profile-photos";

  // STORY STORAGE
  static String STORY_FILE_NAME(String fileExtension) =>
      "story_${DateTime.now().millisecondsSinceEpoch}.$fileExtension";

  static String STORY_STORAGE_PATH(String userId, String fileName) =>
      '$userId/stories/$fileName';

  static const String STORY_STORAGE_ID = "stories";
}
