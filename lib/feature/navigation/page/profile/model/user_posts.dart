import '../../../../../core/base/model/base.dart';
import '../../../../create_post/model/post.dart';
import 'pagination.dart';

class UserPostsModel extends BaseModel<UserPostsModel> {
  List<PostModel>? posts;
  PaginationModel? pagination;

  UserPostsModel({this.posts, this.pagination});

  @override
  UserPostsModel copyWith({
    List<PostModel>? posts,
    PaginationModel? pagination,
  }) {
    return UserPostsModel(
      posts: posts ?? this.posts,
      pagination: pagination ?? this.pagination,
    );
  }

  @override
  UserPostsModel fromJson(Map<String, dynamic> json) {
    return UserPostsModel(
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
    return data;
  }
}
