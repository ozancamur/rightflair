import '../../../../core/base/model/base.dart';

class UpdatePostModel extends BaseModel<UpdatePostModel> {
  String? postId;
  String? postImageUrl;
  String? description;
  String? location;
  bool? isAnonymous;
  bool? allowComments;
  List<String>? styleTags;
  List<String>? mentionedUserIds;
  String? musicTitle;
  String? musicArtist;
  String? musicAudioUrl;
  String? status;

  UpdatePostModel({
    this.postId,
    this.postImageUrl,
    this.description,
    this.location,
    this.isAnonymous,
    this.allowComments,
    this.styleTags,
    this.mentionedUserIds,
    this.musicTitle,
    this.musicArtist,
    this.musicAudioUrl,
    this.status,
  });

  @override
  UpdatePostModel copyWith({
    String? postId,
    String? postImageUrl,
    String? description,
    String? location,
    bool? isAnonymous,
    bool? allowComments,
    List<String>? styleTags,
    List<String>? mentionedUserIds,
    String? musicTitle,
    String? musicArtist,
    String? musicAudioUrl,
    String? status,
  }) {
    return UpdatePostModel(
      postId: postId ?? this.postId,
      postImageUrl: postImageUrl ?? this.postImageUrl,
      description: description ?? this.description,
      location: location ?? this.location,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      allowComments: allowComments ?? this.allowComments,
      styleTags: styleTags ?? this.styleTags,
      mentionedUserIds: mentionedUserIds ?? this.mentionedUserIds,
      musicTitle: musicTitle ?? this.musicTitle,
      musicArtist: musicArtist ?? this.musicArtist,
      musicAudioUrl: musicAudioUrl ?? this.musicAudioUrl,
      status: status ?? this.status,
    );
  }

  @override
  UpdatePostModel fromJson(Map<String, dynamic> json) {
    return UpdatePostModel(
      postId: json['post_id'] as String?,
      postImageUrl: json['post_image_url'] as String?,
      description: json['description'] as String?,
      location: json['location'] as String?,
      isAnonymous: json['is_anonymous'] as bool?,
      allowComments: json['allow_comments'] as bool?,
      styleTags: (json['style_tags'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      mentionedUserIds: (json['mentioned_user_ids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      musicTitle: json['music_title'] as String?,
      musicArtist: json['music_artist'] as String?,
      musicAudioUrl: json['music_audio_url'] as String?,
      status: json['status'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'post_id': postId,
      if (postImageUrl != null) 'post_image_url': postImageUrl,
      if (description != null) 'description': description,
      if (location != null) 'location': location,
      if (isAnonymous != null) 'is_anonymous': isAnonymous,
      if (allowComments != null) 'allow_comments': allowComments,
      if (styleTags != null) 'style_tags': styleTags,
      if (mentionedUserIds != null) 'mentioned_user_ids': mentionedUserIds,
      if (musicTitle != null) 'music_title': musicTitle,
      if (musicArtist != null) 'music_artist': musicArtist,
      if (musicAudioUrl != null) 'music_audio_url': musicAudioUrl,
      if (status != null) 'status': status,
    };
  }
}
