import '../../../../../core/base/model/base.dart';

class RequestUserPostsModel extends BaseModel<RequestUserPostsModel> {
  int? page;
  int? limit;
  String? sortBy;
  String? sortOrder;

  RequestUserPostsModel({this.page, this.limit, this.sortBy, this.sortOrder});

  @override
  RequestUserPostsModel copyWith({
    int? page,
    int? limit,
    String? sortBy,
    String? sortOrder,
  }) {
    return RequestUserPostsModel(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  RequestUserPostsModel fromJson(Map<String, dynamic> json) {
    return RequestUserPostsModel(
      page: json['page'] as int?,
      limit: json['limit'] as int?,
      sortBy: json['sort_by'] as String?,
      sortOrder: json['sort_order'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'limit': limit,
      'sort_by': sortBy,
      'sort_order': sortOrder,
    };
  }

  RequestUserPostsModel requestSortByDateOrderDesc({required int page}) {
    return RequestUserPostsModel(
      page: page,
      limit: 6,
      sortBy: 'created_at',
      sortOrder: 'desc',
    );
  }
}
