import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:rightflair/core/constants/color/color.dart';
import 'package:rightflair/core/constants/route.dart';

import '../../../../core/constants/icons.dart';
import '../../../../core/constants/string.dart';
import '../../../../core/extensions/context.dart';
import '../../../main/feed/bloc/feed_bloc.dart';
import '../cubit/navigation_cubit.dart';

class NavigationBottomBar extends StatelessWidget {
  final int currentIndex;
  const NavigationBottomBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.height * .07,
      width: context.width,
      padding: EdgeInsets.symmetric(horizontal: context.width * .025),
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
    return Expanded(
      flex: 5,
      child: Center(
        child: InkWell(
          onTap: () => context.push(RouteConstants.CAMERA),
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
        ),
      ),
    );
  }

  Widget _item(BuildContext context, int index, String icon, String label) {
    final isSelected = currentIndex == index;
    final isHomeRefreshing =
        index == 0 && context.watch<NavigationCubit>().state.isHomeRefreshing;
    return Expanded(
      flex: 4,
      child: GestureDetector(
        onTap: () {
          if (index == 0 && currentIndex == 0) {
            _refreshHome(context);
          } else {
            context.read<NavigationCubit>().route(index);
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: context.height * 0.024,
              child: Center(
                child: isHomeRefreshing
                    ? SizedBox(
                        height: context.height * 0.020,
                        width: context.height * 0.020,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : SvgPicture.asset(
                        icon,
                        height: context.height * 0.022,
                        color: isSelected
                            ? Colors.white
                            : context.colors.tertiary,
                      ),
              ),
            ),
            SizedBox(height: context.height * 0.0035),
            Text(
              label.tr(),
              style: TextStyle(
                fontSize: context.width * 0.026,
                color: isSelected ? Colors.white : context.colors.tertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _refreshHome(BuildContext context) async {
    final navCubit = context.read<NavigationCubit>();
    final feedBloc = context.read<FeedBloc>();
    final currentTab = feedBloc.state.currentTabIndex;

    navCubit.setHomeRefreshing(true);
    feedBloc.add(RefreshTabEvent(currentTab));

    try {
      await feedBloc.stream
          .firstWhere((state) => !state.isLoadingForTab(currentTab))
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => feedBloc.state,
          );
    } catch (_) {}

    navCubit.setHomeRefreshing(false);
  }
}
