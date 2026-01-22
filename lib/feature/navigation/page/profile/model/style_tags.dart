import '../../../../../core/base/model/base.dart';

class StyleTagsModel extends BaseModel<StyleTagsModel> {
  String? userId;
  List<String>? styleTags;
  List<String>? availableTags;
  bool? isOwnProfile;

  StyleTagsModel({
    this.userId,
    this.styleTags,
    this.availableTags,
    this.isOwnProfile,
  });


  @override
  StyleTagsModel copyWith({
    String? userId,
    List<String>? styleTags,
    List<String>? availableTags,
    bool? isOwnProfile,
  }) {
    return StyleTagsModel(
      userId: userId ?? this.userId,
      styleTags: styleTags ?? this.styleTags,
      availableTags: availableTags ?? this.availableTags,
      isOwnProfile: isOwnProfile ?? this.isOwnProfile,
    );
  }

  @override
  StyleTagsModel fromJson(Map<String, dynamic> json) {
    return StyleTagsModel(
      userId: json['user_id'] as String?,
      styleTags: (json['style_tags'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      availableTags: (json['available_tags'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      isOwnProfile: json['is_own_profile'] as bool?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'style_tags': styleTags,
      'available_tags': availableTags,
      'is_own_profile': isOwnProfile,
    };
  }
}
