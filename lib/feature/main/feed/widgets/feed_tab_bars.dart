import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:rightflair/core/constants/font/font_family.dart';
import 'package:rightflair/core/constants/icons.dart';
import 'package:rightflair/core/constants/route.dart';

import '../../../../core/constants/string.dart';
import '../../../../core/extensions/context.dart';
import '../bloc/feed_bloc.dart';

class FeedTabBars extends StatefulWidget {
  const FeedTabBars({super.key});

  @override
  State<FeedTabBars> createState() => _FeedTabBarsState();
}

class _FeedTabBarsState extends State<FeedTabBars>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _tabController = DefaultTabController.of(context);
      _tabController?.addListener(_onTabChanged);
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _tabController?.removeListener(_onTabChanged);
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController != null && !_tabController!.indexIsChanging) {
      context.read<FeedBloc>().add(ChangeTabEvent(_tabController!.index));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.height * .075,
      width: context.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          Expanded(
            flex: 6,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: context.colors.primary,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 1,
              indicatorPadding: EdgeInsets.only(
                left: context.width * .03,
                right: context.width * .03,
                top: 0,
              ),
              labelPadding: EdgeInsets.symmetric(
                horizontal: context.width * .025,
              ),
              labelStyle: TextStyle(
                color: context.colors.primary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: FontFamilyConstants.POPPINS,
              ),
              unselectedLabelStyle: TextStyle(
                color: context.colors.primaryContainer,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: FontFamilyConstants.POPPINS,
              ),
              tabs: [
                Tab(text: AppStrings.FEED_DISCOVER.tr()),
                Tab(text: AppStrings.FEED_FOLLOWING.tr()),
                Tab(text: AppStrings.FEED_FRIENDS.tr()),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: context.height * .015),
              child: GestureDetector(
                onTap: () => context.push(RouteConstants.SEARCH),
                child: SvgPicture.asset(
                  AppIcons.SEARCH_FILLED,
                  color: context.colors.primary,
                  height: context.height * .0225,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
