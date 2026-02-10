import '../../../core/base/model/base.dart';
import '../../authentication/model/user.dart';
import '../../main/profile/model/pagination.dart';

class FollowListResponseModel extends BaseModel<FollowListResponseModel> {
  final List<UserModel>? users;
  final PaginationModel? pagination;

  FollowListResponseModel({this.users, this.pagination});

  @override
  FollowListResponseModel copyWith({
    List<UserModel>? users,
    PaginationModel? pagination,
  }) {
    return FollowListResponseModel(
      users: users ?? this.users,
      pagination: pagination ?? this.pagination,
    );
  }

  @override
  FollowListResponseModel fromJson(Map<String, dynamic> json) {
    // API returns 'followers' or 'following' key depending on the endpoint
    final usersList = json['users'] ?? json['followers'] ?? json['following'];

    return FollowListResponseModel(
      users: usersList != null
          ? (usersList as List<dynamic>)
                .map((e) => UserModel().fromJson(e as Map<String, dynamic>))
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
