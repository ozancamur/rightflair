import '../../../../core/base/model/base.dart';

class MusicModel extends BaseModel<MusicModel> {
  String? title;
  String? artist;
  String? url;

  MusicModel({this.title, this.artist, this.url});

  @override
  MusicModel copyWith({String? title, String? artist, String? url}) {
    return MusicModel(
      title: title ?? this.title,
      artist: artist ?? this.artist,
      url: url ?? this.url,
    );
  }

  @override
  MusicModel fromJson(Map<String, dynamic> json) {
    return MusicModel(
      title: json['title'] as String?,
      artist: json['artist'] != null ? json['artist']['name'] as String? : null,
      url: json['preview'] as String? ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {'title': title, 'artist': artist, 'preview_url': url};
  }

  String get displayName => '$artist - $title';
}
