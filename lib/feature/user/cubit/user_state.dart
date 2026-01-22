import 'package:equatable/equatable.dart';
import 'package:rightflair/feature/navigation/page/profile/model/photo.dart'
    show PhotoModel;

import '../../authentication/model/user.dart';
import '../../navigation/page/profile/model/style_tags.dart';

class UserState extends Equatable {
  final bool isLoading;
  final UserModel user;
  final StyleTagsModel? tags;
  final List<PhotoModel> photos;
  final bool isPhotosLoading;
  const UserState({
    this.isLoading = false,
    required this.user,
    this.tags,
    this.photos = const [],
    this.isPhotosLoading = false,
  });

  UserState copyWith({
    bool? isLoading,
    UserModel? user,
    StyleTagsModel? tags,
    List<PhotoModel>? photos,
    bool? isPhotosLoading,
  }) {
    return UserState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      tags: tags ?? this.tags,
      photos: photos ?? this.photos,
      isPhotosLoading: isPhotosLoading ?? this.isPhotosLoading,
    );
  }

  @override
  List<Object> get props => [
    isLoading,
    user,
    tags ?? StyleTagsModel(),
    photos,
    isPhotosLoading,
  ];
}
