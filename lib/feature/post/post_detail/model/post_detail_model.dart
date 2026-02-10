class PostDetailModel {
  final String id;
  final String imageUrl;
  final String userName;
  final String userProfileImage;
  final int commentsCount;
  final int bookmarkedCount;
  final int sharesCount;

  const PostDetailModel({
    required this.id,
    required this.imageUrl,
    required this.userName,
    required this.userProfileImage,
    required this.commentsCount,
    required this.bookmarkedCount,
    required this.sharesCount,
  });

  PostDetailModel copyWith({
    String? id,
    String? imageUrl,
    String? userName,
    String? userProfileImage,
    int? commentsCount,
    int? bookmarkedCount,
    int? sharesCount,
  }) {
    return PostDetailModel(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      userName: userName ?? this.userName,
      userProfileImage: userProfileImage ?? this.userProfileImage,
      commentsCount: commentsCount ?? this.commentsCount,
      bookmarkedCount: bookmarkedCount ?? this.bookmarkedCount,
      sharesCount: sharesCount ?? this.sharesCount,
    );
  }
}
