import '../../../core/base/model/base.dart';

class RequestSearchModel extends BaseModel<RequestSearchModel> {
  String? query;
  int? page;
  int? limit;

  RequestSearchModel({this.query, this.page, this.limit});

  @override
  RequestSearchModel copyWith({String? query, int? page, int? limit}) {
    return RequestSearchModel(
      query: query ?? this.query,
      page: page ?? this.page,
      limit: limit ?? this.limit,
    );
  }

  @override
  RequestSearchModel fromJson(Map<String, dynamic> json) {
    return RequestSearchModel(
      query: json['query'] as String?,
      page: json['page'] as int?,
      limit: json['limit'] as int?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {'query': query, 'page': page, 'limit': limit};
  }
}
