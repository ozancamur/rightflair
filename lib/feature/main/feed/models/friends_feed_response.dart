import '../../../../core/base/model/base.dart';
import '../../../post/create_post/model/post.dart';
import '../../profile/model/pagination.dart';
import 'suggested_user.dart';

class FriendsFeedResponseModel extends BaseModel<FriendsFeedResponseModel> {
  List<PostModel>? posts;
  PaginationModel? pagination;
  List<SuggestedUserModel>? suggestedUsers;
  String? feedState; // "no_friends" | "feed_ended" | "has_more"

  FriendsFeedResponseModel({
    this.posts,
    this.pagination,
    this.suggestedUsers,
    this.feedState,
  });

  @override
  FriendsFeedResponseModel copyWith({
    List<PostModel>? posts,
    PaginationModel? pagination,
    List<SuggestedUserModel>? suggestedUsers,
    String? feedState,
  }) {
    return FriendsFeedResponseModel(
      posts: posts ?? this.posts,
      pagination: pagination ?? this.pagination,
      suggestedUsers: suggestedUsers ?? this.suggestedUsers,
      feedState: feedState ?? this.feedState,
    );
  }

  @override
  FriendsFeedResponseModel fromJson(Map<String, dynamic> json) {
    return FriendsFeedResponseModel(
      posts: json['posts'] != null
          ? (json['posts'] as List)
                .map((e) => PostModel().fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
      pagination: json['pagination'] != null
          ? PaginationModel().fromJson(
              json['pagination'] as Map<String, dynamic>,
            )
          : null,
      suggestedUsers: json['suggested_users'] != null
          ? (json['suggested_users'] as List)
                .map(
                  (e) =>
                      SuggestedUserModel().fromJson(e as Map<String, dynamic>),
                )
                .toList()
          : null,
      feedState: json['feed_state'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (posts != null) {
      data['posts'] = posts!.map((e) => e.toJson()).toList();
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    if (suggestedUsers != null) {
      data['suggested_users'] = suggestedUsers!.map((e) => e.toJson()).toList();
    }
    if (feedState != null) {
      data['feed_state'] = feedState;
    }
    return data;
  }
}
