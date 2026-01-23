import '../../../core/base/model/base.dart';

class NotificationsModel extends BaseModel<NotificationsModel> {
  bool? enableLikes;
  bool? enableSaves;
  bool? enableMilestones;
  bool? enableTrending;
  bool? enableFollow;

  NotificationsModel({
    this.enableLikes,
    this.enableSaves,
    this.enableMilestones,
    this.enableTrending,
    this.enableFollow,
  });

  @override
  NotificationsModel copyWith({
    bool? enableLikes,
    bool? enableSaves,
    bool? enableMilestones,
    bool? enableTrending,
    bool? enableFollow,
  }) {
    return NotificationsModel(
      enableLikes: enableLikes ?? this.enableLikes,
      enableSaves: enableSaves ?? this.enableSaves,
      enableMilestones: enableMilestones ?? this.enableMilestones,
      enableTrending: enableTrending ?? this.enableTrending,
      enableFollow: enableFollow ?? this.enableFollow,
    );
  }

  @override
  NotificationsModel fromJson(Map<String, dynamic> json) {
    return NotificationsModel(
      enableLikes: json['allow_likes_notify'] as bool?,
      enableSaves: json['allow_saves_notify'] as bool?,
      enableMilestones: json['allow_milestones_notify'] as bool?,
      enableTrending: json['allow_trending_notify'] as bool?,
      enableFollow: json['allow_follow_notify'] as bool?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'allow_likes_notify': enableLikes,
      'allow_saves_notify': enableSaves,
      'allow_milestones_notify': enableMilestones,
      'allow_trending_notify': enableTrending,
      'allow_follow_notify': enableFollow,
    };
  }
}
