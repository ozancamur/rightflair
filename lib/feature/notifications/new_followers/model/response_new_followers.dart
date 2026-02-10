import 'package:rightflair/feature/main/inbox/model/pagination_notification.dart';

import '../../../../core/base/model/base.dart';
import 'new_follower.dart';

class ResponseNewFollowersModel extends BaseModel<ResponseNewFollowersModel> {
  List<NewFollowerModel>? followers;
  PaginationNotificationModel? pagination;

  ResponseNewFollowersModel({this.followers, this.pagination});

  @override
  ResponseNewFollowersModel copyWith({
    List<NewFollowerModel>? followers,
    PaginationNotificationModel? pagination,
  }) {
    return ResponseNewFollowersModel(
      followers: followers ?? this.followers,
      pagination: pagination ?? this.pagination,
    );
  }

  @override
  ResponseNewFollowersModel fromJson(Map<String, dynamic> json) {
    return ResponseNewFollowersModel(
      followers: (json['followers'] as List<dynamic>?)
          ?.map((e) => NewFollowerModel().fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: json['pagination'] != null
          ? PaginationNotificationModel().fromJson(
              json['pagination'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'followers': followers?.map((e) => e.toJson()).toList(),
      'pagination': pagination?.toJson(),
    };
  }
}
