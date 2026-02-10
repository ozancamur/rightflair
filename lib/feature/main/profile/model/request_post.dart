import '../../../../core/base/model/base.dart';

class RequestPostModel extends BaseModel<RequestPostModel> {
  int? page;
  int? limit;
  String? sortBy;
  String? sortOrder;
  String? userId;

  RequestPostModel({this.page, this.limit, this.sortBy, this.sortOrder, this.userId});

  @override
  RequestPostModel copyWith({
    int? page,
    int? limit,
    String? sortBy,
    String? sortOrder,
    String? userId,
  }) {
    return RequestPostModel(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
      userId: userId ?? this.userId,
    );
  }

  @override
  RequestPostModel fromJson(Map<String, dynamic> json) {
    return RequestPostModel(
      page: json['page'] as int?,
      limit: json['limit'] as int?,
      sortBy: json['sort_by'] as String?,
      sortOrder: json['sort_order'] as String?,
      userId: json['user_id'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'limit': limit,
      'sort_by': sortBy,
      'sort_order': sortOrder,
      'user_id': userId,
    };
  }

  RequestPostModel requestSortByDateOrderDesc({
    required int page,
    int limit = 6,
  }) {
    return RequestPostModel(
      page: page,
      limit: limit,
      sortBy: 'created_at',
      sortOrder: 'desc',
    );
  }

    RequestPostModel requestWithUserId({
    required int page,
    int limit = 6,
    required String userId,
  }) {
    return RequestPostModel(
      page: page,
      limit: limit,
      sortBy: 'created_at',
      sortOrder: 'desc',
      userId: userId,
    );
  }
}
