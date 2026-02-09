import '../../../../../core/base/model/base.dart';

class PaginationNotificationModel
    extends BaseModel<PaginationNotificationModel> {
  int? page;
  int? limit;
  bool? hasNext;

  PaginationNotificationModel({this.page, this.limit, this.hasNext});

  @override
  PaginationNotificationModel copyWith({int? page, int? limit, bool? hasNext}) {
    return PaginationNotificationModel(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      hasNext: hasNext ?? this.hasNext,
    );
  }

  @override
  PaginationNotificationModel fromJson(Map<String, dynamic> json) {
    return PaginationNotificationModel(
      page: json['page'] as int?,
      limit: json['limit'] as int?,
      hasNext: json['has_next'] as bool?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {'page': page, 'limit': limit, 'has_next': hasNext};
  }
}
