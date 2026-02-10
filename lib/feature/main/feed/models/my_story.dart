import 'package:rightflair/feature/main/feed/models/my_story_item.dart';

import '../../../../core/base/model/base.dart';
import 'story_user.dart';

class MyStoryModel extends BaseModel<MyStoryModel> {
  
  StoryUserModel? user;
  List<MyStoryItemModel>? stories;

  MyStoryModel({this.user, this.stories});

  @override
  MyStoryModel copyWith({
    StoryUserModel? user,
    List<MyStoryItemModel>? stories,
  }) {
    return MyStoryModel(
      user: user ?? this.user,
      stories: stories ?? this.stories,
    );
  }

  @override
  MyStoryModel fromJson(Map<String, dynamic> json) {
    return MyStoryModel(
      user: json['user'] != null
          ? StoryUserModel().fromJson(json['user'] as Map<String, dynamic>)
          : null,
      stories: json['stories'] != null
          ? List<MyStoryItemModel>.from(
              (json['stories'] as List).map(
                (x) => MyStoryItemModel().fromJson(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'user': user?.toJson(),
      'stories': stories?.map((story) => story.toJson()).toList(),
    };
  }
}
