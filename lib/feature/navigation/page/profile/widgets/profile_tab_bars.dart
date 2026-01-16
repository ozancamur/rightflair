import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rightflair/core/constants/string.dart';

import '../../../../../core/constants/dark_color.dart';
import '../../../../../core/constants/font_size.dart';
import '../../../../../core/extensions/context.dart';

class ProfileTabBarsWidget extends StatelessWidget {
  const ProfileTabBarsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TabBar(
        isScrollable: true,
        indicatorColor: AppDarkColors.PRIMARY,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorWeight: 1.5,
        indicatorPadding: EdgeInsets.only(
          left: context.width * .03,
          right: context.width * .03,
          top: 0,
          bottom: context.height * .005,
        ),
        labelPadding: EdgeInsets.symmetric(horizontal: context.width * .025),
        labelStyle: TextStyle(
          fontSize: FontSizeConstants.LARGE.first,
          fontWeight: FontWeight.w600,
          color: AppDarkColors.PRIMARY,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: FontSizeConstants.LARGE.first,
          fontWeight: FontWeight.w500,
          color: AppDarkColors.WHITE75,
        ),
        tabs: [
          _item(AppStrings.PROFILE_PHOTOS),
          _item(AppStrings.PROFILE_SAVES),
          _item(AppStrings.PROFILE_DRAFTS),
        ],
      ),
    );
  }

  Tab _item(String text) {
    return Tab(text: text.tr());
  }
}
