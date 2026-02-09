import '../../../core/base/model/base.dart';
import '../../create_post/model/post.dart';

class ResponseSearchModel extends BaseModel<ResponseSearchModel> {
  List<PostModel>? posts;
  int? totalCount;
  int? currentPage;
  bool? hasMore;

  ResponseSearchModel({
    this.posts,
    this.totalCount,
    this.currentPage,
    this.hasMore,
  });

  @override
  ResponseSearchModel copyWith({
    List<PostModel>? posts,
    int? totalCount,
    int? currentPage,
    bool? hasMore,
  }) {
    return ResponseSearchModel(
      posts: posts ?? this.posts,
      totalCount: totalCount ?? this.totalCount,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  ResponseSearchModel fromJson(Map<String, dynamic> json) {
    return ResponseSearchModel(
      posts: (json['posts'] as List?)
          ?.map((e) => PostModel().fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: json['total_count'] as int?,
      currentPage: json['current_page'] as int?,
      hasMore: json['has_more'] as bool?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'posts': posts?.map((e) => e.toJson()).toList(),
      'total_count': totalCount,
      'current_page': currentPage,
      'has_more': hasMore,
    };
  }
}
