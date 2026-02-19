import 'package:rightflair/feature/share/model/share.dart';

import '../../../core/base/model/base.dart';
import '../../main/profile/model/pagination.dart';

class SearchReponseModel extends BaseModel<SearchReponseModel> {
  List<SearchUserModel>? users;
  PaginationModel? pagination;

  SearchReponseModel({this.users, this.pagination});

  @override
  SearchReponseModel copyWith({
    List<SearchUserModel>? users,
    PaginationModel? pagination,
  }) {
    return SearchReponseModel(
      users: users ?? this.users,
      pagination: pagination ?? this.pagination,
    );
  }

  @override
  SearchReponseModel fromJson(Map<String, dynamic> json) {
    return SearchReponseModel(
      users: (json['users'] as List<dynamic>?)
          ?.map((e) => SearchUserModel().fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: json['pagination'] != null
          ? PaginationModel().fromJson(
              json['pagination'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'users': users?.map((e) => e.toJson()).toList(),
      'pagination': pagination?.toJson(),
    };
  }
}
