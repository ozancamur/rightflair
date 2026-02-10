import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:rightflair/core/constants/color/color.dart';
import 'package:rightflair/core/constants/route.dart';
import 'package:rightflair/feature/post/create_post/cubit/create_post_cubit.dart';

import '../../../core/constants/icons.dart';
import '../../../core/constants/string.dart';
import '../../../core/extensions/context.dart';
import '../cubit/navigation_cubit.dart';

class NavigationBottomBar extends StatelessWidget {
  final int currentIndex;
  const NavigationBottomBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.height * .07,
      padding: EdgeInsets.symmetric(horizontal: context.width * .04),
      margin: EdgeInsets.only(
        right: context.width * .05,
        left: context.width * .05,
        bottom: context.height * .02,
      ),
      decoration: BoxDecoration(
        color: AppColors.NAVIGATION,
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
          gradient: LinearGradient(
            colors: [context.colors.surface, context.colors.scrim],
          ),
          borderRadius: BorderRadius.circular(100),
        ),
        child: SvgPicture.asset(AppIcons.ADD, color: Colors.white),
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
        spacing: context.height * 0.0035,
        children: [
          SvgPicture.asset(
            icon,
            height: context.height * (isSelected ? 0.0225 : 0.02),
            color: isSelected ? Colors.white : context.colors.tertiary,
          ),

          Text(
            label.tr(),
            style: TextStyle(
              fontSize: context.width * (isSelected ? 0.0275 : 0.025),
              color: isSelected ? Colors.white : context.colors.tertiary,
            ),
          ),
        ],
      ),
    );
  }
}
