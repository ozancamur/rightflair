import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:rightflair/core/constants/route.dart';
import 'package:rightflair/feature/create_post/cubit/create_post_cubit.dart';

import '../../../core/constants/dark_color.dart';
import '../../../core/constants/icons.dart';
import '../../../core/constants/string.dart';
import '../../../core/extensions/context.dart';
import '../cubit/navigation_cubit.dart';

class NavigationBottomBar extends StatelessWidget {
  final int currentIndex;
  const NavigationBottomBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.width * .05,
        vertical: context.height * .02,
      ),
      child: Container(
        height: context.height * .08,
        padding: EdgeInsets.symmetric(horizontal: context.width * .04),
        decoration: BoxDecoration(
          color: AppDarkColors.DARK_BUTTON,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _item(context, 0, AppIcons.HOME, AppStrings.NAVIGATION_HOME),
            _item(
              context,
              1,
              AppIcons.ANALYTICS,
              AppStrings.NAVIGATION_ANALYTICS,
            ),
            _add(context),
            _item(context, 2, AppIcons.INBOX, AppStrings.NAVIGATION_INBOX),
            _item(context, 3, AppIcons.PROFILE, AppStrings.NAVIGATION_PROFILE),
          ],
        ),
      ),
    );
  }

  Widget _add(BuildContext context) {
    return InkWell(
      onTap: () async {
        await context.read<CreatePostCubit>().pickImageFromCamera();
        if (context.mounted) {
          context.push(RouteConstants.CREATE_POST);
        }
      },
      borderRadius: BorderRadius.circular(100),
      child: Container(
        height: context.width * .09,
        width: context.width * .15,
        margin: EdgeInsets.only(bottom: context.height * .005),
        padding: EdgeInsets.all(context.width * .024),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: AppDarkColors.BUTTON),
          borderRadius: BorderRadius.circular(100),
        ),
        child: SvgPicture.asset(AppIcons.ADD, color: AppDarkColors.PRIMARY),
      ),
    );
  }

  Widget _item(BuildContext context, int index, String icon, String label) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => context.read<NavigationCubit>().route(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            icon,
            height: context.height * (isSelected ? 0.0275 : 0.025),
            color: isSelected ? AppDarkColors.PRIMARY : AppDarkColors.GREY,
          ),
          SizedBox(height: context.height * 0.005),
          Text(
            label.tr(),
            style: TextStyle(
              fontSize: context.width * (isSelected ? 0.0275 : 0.025),
              color: isSelected ? AppDarkColors.PRIMARY : AppDarkColors.GREY,
            ),
          ),
        ],
      ),
    );
  }
}
