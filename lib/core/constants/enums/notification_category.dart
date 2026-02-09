enum NotificationCategory {
  SOCIAL('social'),
  ANALYSIS('analysis'),
  FOLLOWER_INFO('follower_info'),
  SYSTEM('system');

  final String value;
  const NotificationCategory(this.value);

  static NotificationCategory find({required String value}) {
    return NotificationCategory.values.firstWhere(
      (type) => type.value == value,
      orElse: () => NotificationCategory.SYSTEM,
    );
  }
}
