enum NotificationType {
  LIKE('like'),
  COMMENT('comment'),
  MENTION('mention'),
  SHARE('share'),
  
  TRENDING_POST('trending_post'),
  MILESTONE_LIKES('milestone_likes'),
  MILESTONE_VIEWS('milestone_views'),
  MILESTONE_SAVES('milestone_saves'),
  MILESTONE_SHARES('milestone_shares'),
  NEW_FOLLOWER('new_follower'),

  RECOMMENDED_USER('recommended_user'),
  ACCOUNT_ALERT('account_alert'),
  SYSTEM_UPDATE('system_update'),
  NEW_POST('new_post');

  final String value;
  const NotificationType(this.value);

  static NotificationType find({required String value}) {
    return NotificationType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => NotificationType.SYSTEM_UPDATE,
    );
  }
}
