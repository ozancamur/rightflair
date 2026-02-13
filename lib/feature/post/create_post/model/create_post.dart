import '../../../../core/base/model/base.dart';

class CreatePostModel extends BaseModel<CreatePostModel> {
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

  CreatePostModel({
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
  });

  @override
  CreatePostModel copyWith({
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
  }) {
    return CreatePostModel(
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
    );
  }

  @override
  CreatePostModel fromJson(Map<String, dynamic> json) {
    return CreatePostModel(
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
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'post_image_url': postImageUrl,
      'description': description,
      'location': location,
      'is_anonymous': isAnonymous,
      'allow_comments': allowComments,
      'style_tags': styleTags,
      'mentioned_user_ids': mentionedUserIds,
      'music_title': musicTitle,
      'music_artist': musicArtist,
      'music_audio_url': musicAudioUrl,
    };
  }
}
