import 'package:rightflair/core/constants/string.dart';

enum UserStyleTags {
  oversized(AppStrings.OVERSIZED),
  streetwear(AppStrings.STREETWEAR),
  modelling(AppStrings.MODELLING),
  casual(AppStrings.CASUAL),
  formal(AppStrings.FORMAL),
  vintage(AppStrings.VINTAGE),
  sporty(AppStrings.SPORTY),
  bohemian(AppStrings.BOHEMIAN),
  y2k(AppStrings.Y2K),
  goth(AppStrings.GOTH),
  minimalist(AppStrings.MINIMALIST),
  techwear(AppStrings.TECHWEAR),
  skater(AppStrings.SKATER),
  retro(AppStrings.RETRO);

  final String value;
  const UserStyleTags(this.value);
}
