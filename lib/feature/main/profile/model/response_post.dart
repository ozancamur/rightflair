import '../../../../core/base/model/base.dart';
import '../../../post/create_post/model/post.dart';
import 'pagination.dart';

class ResponsePostModel extends BaseModel<ResponsePostModel> {
  List<PostModel>? posts;
  PaginationModel? pagination;

  ResponsePostModel({this.posts, this.pagination});

  @override
  ResponsePostModel copyWith({
    List<PostModel>? posts,
    PaginationModel? pagination,
  }) {
    return ResponsePostModel(
      posts: posts ?? this.posts,
      pagination: pagination ?? this.pagination,
    );
  }

  @override
  ResponsePostModel fromJson(Map<String, dynamic> json) {
    return ResponsePostModel(
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
