import 'package:rightflair/feature/navigation/page/feed/models/user_with_stories.dart';

import '../../../../../core/base/model/base.dart';
import '../../profile/model/pagination.dart';

class StoryResponseModel extends BaseModel<StoryResponseModel> {
  List<UserWithStoriesModel>? usersWithStories;
  PaginationModel? pagination;

  StoryResponseModel({this.usersWithStories, this.pagination});
  @override
  StoryResponseModel copyWith({
    List<UserWithStoriesModel>? usersWithStories,
    PaginationModel? pagination,
  }) {
    return StoryResponseModel(
      usersWithStories: usersWithStories ?? this.usersWithStories,
      pagination: pagination ?? this.pagination,
    );
  }

  @override
  StoryResponseModel fromJson(Map<String, dynamic> json) {
    return StoryResponseModel(
      usersWithStories: json['users_with_stories'] != null
          ? (json['users_with_stories'] as List)
                .map(
                  (e) => UserWithStoriesModel().fromJson(
                    e as Map<String, dynamic>,
                  ),
                )
                .toList()
          : null,
      pagination: json['pagination'] != null
          ? PaginationModel().fromJson(
              json['pagination'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'users_with_stories': usersWithStories?.map((e) => e.toJson()).toList(),
      'pagination': pagination?.toJson(),
    };
  }
}
