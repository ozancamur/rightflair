import '../../../core/base/model/base.dart';

class FollowListRequestModel extends BaseModel<FollowListRequestModel> {
  final String? userId;
  final int page;
  final int limit;
  final String? search;

  FollowListRequestModel({
    this.userId,
    this.page = 1,
    this.limit = 20,
    this.search,
  });

  @override
  FollowListRequestModel copyWith({
    String? userId,
    int? page,
    int? limit,
    String? search,
  }) {
    return FollowListRequestModel(
      userId: userId ?? this.userId,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      search: search ?? this.search,
    );
  }

  @override
  FollowListRequestModel fromJson(Map<String, dynamic> json) {
    return FollowListRequestModel(
      userId: json['user_id'] as String?,
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 20,
      search: json['search'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {'page': page, 'limit': limit};
    if (userId != null) data['user_id'] = userId;
    if (search != null && search!.isNotEmpty) data['search'] = search;
    return data;
  }
}
