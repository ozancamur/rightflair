import '../../../core/base/base_modeld.dart';

class CommentModel extends BaseModel {
  final String userName;
  final String? userAvatar;
  final String text;
  final String timeAgo;
  final int likeCount;
  final bool isLiked;
  final int replyCount;

  CommentModel({
    required this.userName,
    this.userAvatar,
    required this.text,
    required this.timeAgo,
    this.likeCount = 0,
    this.isLiked = false,
    this.replyCount = 0,
  });

  @override
  CommentModel copyWith({
    String? userName,
    String? userAvatar,
    String? text,
    String? timeAgo,
    int? likeCount,
    bool? isLiked,
    int? replyCount,
  }) {
    return CommentModel(
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      text: text ?? this.text,
      timeAgo: timeAgo ?? this.timeAgo,
      likeCount: likeCount ?? this.likeCount,
      isLiked: isLiked ?? this.isLiked,
      replyCount: replyCount ?? this.replyCount,
    );
  }

  @override
  CommentModel fromJson(Map<String, dynamic> json) {
    return CommentModel(
      userName: json['userName'],
      userAvatar: json['userAvatar'],
      text: json['text'],
      timeAgo: json['timeAgo'],
      likeCount: json['likeCount'],
      isLiked: json['isLiked'],
      replyCount: json['replyCount'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'userAvatar': userAvatar,
      'text': text,
      'timeAgo': timeAgo,
      'likeCount': likeCount,
      'isLiked': isLiked,
      'replyCount': replyCount,
    };
  }
}
