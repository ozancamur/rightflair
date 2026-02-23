import '../../../core/base/model/base.dart';
import '../../main/profile/model/pagination.dart';
import 'suggested_user.dart';

class FindFriendsResponseModel extends BaseModel<FindFriendsResponseModel> {
  final List<SuggestedUserModel>? users;
  final PaginationModel? pagination;

  FindFriendsResponseModel({this.users, this.pagination});

  @override
  FindFriendsResponseModel copyWith({
    List<SuggestedUserModel>? users,
    PaginationModel? pagination,
  }) {
    return FindFriendsResponseModel(
      users: users ?? this.users,
      pagination: pagination ?? this.pagination,
    );
  }

  @override
  FindFriendsResponseModel fromJson(Map<String, dynamic> json) {
    final usersList = json['users'] ?? json['suggested_users'];

    return FindFriendsResponseModel(
      users: usersList != null
          ? (usersList as List<dynamic>)
                .map(
                  (e) =>
                      SuggestedUserModel().fromJson(e as Map<String, dynamic>),
                )
                .toList()
          : null,
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
