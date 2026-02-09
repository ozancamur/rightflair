import 'dart:ui';

enum LocaleEnum {
  en(Locale('en'));

  final Locale locale;
  const LocaleEnum(this.locale);
}
