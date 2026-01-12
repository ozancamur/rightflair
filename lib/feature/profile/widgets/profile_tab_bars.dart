import 'package:flutter/material.dart';

import '../../../../../core/constants/string.dart';
import '../../../../../core/extensions/context.dart';
import 'profile_tab_item.dart';

class ProfileTabBarsWidget extends StatelessWidget {
  const ProfileTabBarsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: context.width * 0.05,
      children: [
        ProfileTabItemWidget(text: AppStrings.PROFILE_PHOTOS, isActive: true),
        ProfileTabItemWidget(text: AppStrings.PROFILE_SAVES, isActive: false),
        ProfileTabItemWidget(text: AppStrings.PROFILE_DRAFTS, isActive: false),
      ],
    );
  }
}