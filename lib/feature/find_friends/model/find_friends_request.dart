import '../../../core/base/model/base.dart';

class FindFriendsRequestModel extends BaseModel<FindFriendsRequestModel> {
  final int page;
  final int limit;
  final String? search;

  FindFriendsRequestModel({this.page = 1, this.limit = 20, this.search});

  @override
  FindFriendsRequestModel copyWith({int? page, int? limit, String? search}) {
    return FindFriendsRequestModel(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      search: search ?? this.search,
    );
  }

  @override
  FindFriendsRequestModel fromJson(Map<String, dynamic> json) {
    return FindFriendsRequestModel(
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 20,
      search: json['search'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {'page': page, 'limit': limit};
    if (search != null && search!.isNotEmpty) data['search'] = search;
    return data;
  }
}
