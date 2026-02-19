import 'package:easy_localization/easy_localization.dart';
import 'package:rightflair/core/constants/string.dart';

enum ReportReason {
  spam('spam', AppStrings.REPORT_REASON_SPAM),
  inappropriateContent(
    'inappropriate_content',
    AppStrings.REPORT_REASON_INAPPROPRIATE_CONTENT,
  ),
  harassment('harassment', AppStrings.REPORT_REASON_HARASSMENT),
  hateSpeech('hate_speech', AppStrings.REPORT_REASON_HATE_SPEECH),
  violence('violence', AppStrings.REPORT_REASON_VIOLENCE),
  nudity('nudity', AppStrings.REPORT_REASON_NUDITY),
  misinformation('misinformation', AppStrings.REPORT_REASON_MISINFORMATION),
  other('other', AppStrings.REPORT_REASON_OTHER);

  final String value;
  final String _localizationKey;
  const ReportReason(this.value, this._localizationKey);

  String get label => _localizationKey.tr();
}
