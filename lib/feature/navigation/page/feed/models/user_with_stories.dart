import '../../../../../core/base/model/base.dart';
import 'story.dart';
import 'story_user.dart';

class UserWithStoriesModel extends BaseModel<UserWithStoriesModel> {
  StoryUserModel? user;
  bool? hasUnseenStories;
  int? storiesCount;
  DateTime? latestStoryAt;
  List<StoryModel>? stories;

  UserWithStoriesModel({
    this.user,
    this.hasUnseenStories,
    this.storiesCount,
    this.latestStoryAt,
    this.stories,
  });

  @override
  UserWithStoriesModel copyWith({
    StoryUserModel? user,
    bool? hasUnseenStories,
    int? storiesCount,
    DateTime? latestStoryAt,
    List<StoryModel>? stories,
  }) {
    return UserWithStoriesModel(
      user: user ?? this.user,
      hasUnseenStories: hasUnseenStories ?? this.hasUnseenStories,
      storiesCount: storiesCount ?? this.storiesCount,
      latestStoryAt: latestStoryAt ?? this.latestStoryAt,
      stories: stories ?? this.stories,
    );
  }

  @override
  UserWithStoriesModel fromJson(Map<String, dynamic> json) {
    return UserWithStoriesModel(
      user: json['user'] != null
          ? StoryUserModel().fromJson(json['user'] as Map<String, dynamic>)
          : null,
      hasUnseenStories: json['has_unseen_stories'] as bool?,
      storiesCount: json['stories_count'] as int?,
      latestStoryAt: json['latest_story_at'] != null
          ? DateTime.parse(json['latest_story_at'] as String)
          : null,
      stories: json['stories'] != null
          ? (json['stories'] as List)
                .map((e) => StoryModel().fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'user': user?.toJson(),
      'has_unseen_stories': hasUnseenStories,
      'stories_count': storiesCount,
      'latest_story_at': latestStoryAt?.toIso8601String(),
      'stories': stories?.map((e) => e.toJson()).toList(),
    };
  }
}
