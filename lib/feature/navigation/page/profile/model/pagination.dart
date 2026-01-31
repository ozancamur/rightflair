import '../../../../../core/base/model/base.dart';

class PaginationModel extends BaseModel<PaginationModel> {
  int? page;
  int? limit;
  int? totalCount;
  int? totalPages;
  bool? hasNext;
  bool? hasPrev;

  PaginationModel({
    this.page,
    this.limit,
    this.totalCount,
    this.totalPages,
    this.hasNext,
    this.hasPrev,
  });

  @override
  PaginationModel copyWith({
    int? page,
    int? limit,
    int? totalCount,
    int? totalPages,
    bool? hasNext,
    bool? hasPrev,
  }) {
    return PaginationModel(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      totalCount: totalCount ?? this.totalCount,
      totalPages: totalPages ?? this.totalPages,
      hasNext: hasNext ?? this.hasNext,
      hasPrev: hasPrev ?? this.hasPrev,
    );
  }

  @override
  PaginationModel fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      page: json['page'] as int?,
      limit: json['limit'] as int?,
      totalCount: json['total_count'] as int?,
      totalPages: json['total_pages'] as int?,
      hasNext: json['has_next'] as bool?,
      hasPrev: json['has_prev'] as bool?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'limit': limit,
      'total_count': totalCount,
      'total_pages': totalPages,
      'has_next': hasNext,
      'has_prev': hasPrev,
    };
  }

  PaginationModel reset() {
    return PaginationModel(
      page: 1,
      limit: 6,
      totalCount: totalCount,
      totalPages: totalPages,
      hasNext: hasNext,
      hasPrev: hasPrev,
    );
  }

  PaginationModel forConversations({required int page}) {
    return PaginationModel(
      page: 1,
      limit: 10,
      totalCount: totalCount,
      totalPages: totalPages,
      hasNext: hasNext,
      hasPrev: hasPrev,
    );
  }
}
