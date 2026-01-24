import '../../../../../core/base/model/base.dart';

class RequestPostModel extends BaseModel<RequestPostModel> {
  int? page;
  int? limit;
  String? sortBy;
  String? sortOrder;

  RequestPostModel({this.page, this.limit, this.sortBy, this.sortOrder});

  @override
  RequestPostModel copyWith({
    int? page,
    int? limit,
    String? sortBy,
    String? sortOrder,
  }) {
    return RequestPostModel(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  RequestPostModel fromJson(Map<String, dynamic> json) {
    return RequestPostModel(
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
}
