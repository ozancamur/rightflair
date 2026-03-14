import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rightflair/core/components/appbar.dart';
import 'package:rightflair/core/components/button/back_button.dart';

import '../../../core/base/page/base_scaffold.dart';
import '../../../core/components/loading.dart';
import '../../../core/components/text/text.dart';
import '../../../core/constants/enums/follow_list_type.dart';
import '../../../core/constants/font/font_size.dart';
import '../../../core/constants/route.dart';
import '../../../core/constants/string.dart';
import '../../../core/extensions/context.dart';
import '../cubit/follow_cubit.dart';
import '../cubit/follow_state.dart';
import '../widgets/follow_list_search_field.dart';
import '../widgets/follow_list_user_item.dart';

class FollowPage extends StatefulWidget {
  final String username;
  final String? userId;
  final FollowListType listType;
  final int followers;
  final int following;
  const FollowPage({
    super.key,
    required this.username,
    this.userId,
    required this.listType,
    required this.followers,
    required this.following,
  });

  @override
  State<FollowPage> createState() => _FollowPageState();
}

class _FollowPageState extends State<FollowPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _followingScrollController;
  late ScrollController _followersScrollController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.listType == FollowListType.followers ? 0 : 1,
    );
    _tabController.addListener(_onTabChanged);

    context.read<FollowCubit>().init(
      listType: widget.listType,
      userId: widget.userId,
    );
    _followingScrollController = ScrollController();
    _followingScrollController.addListener(_onFollowingScroll);
    _followersScrollController = ScrollController();
    _followersScrollController.addListener(_onFollowersScroll);
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    final listType = _tabController.index == 0
        ? FollowListType.followers
        : FollowListType.following;
    context.read<FollowCubit>().switchTab(listType);
  }

  void _onFollowingScroll() {
    if (_followingScrollController.position.pixels >=
        _followingScrollController.position.maxScrollExtent - 200) {
      final cubit = context.read<FollowCubit>();
      if (cubit.state.activeTab == FollowListType.following) {
        cubit.loadMore();
      }
    }
  }

  void _onFollowersScroll() {
    if (_followersScrollController.position.pixels >=
        _followersScrollController.position.maxScrollExtent - 200) {
      final cubit = context.read<FollowCubit>();
      if (cubit.state.activeTab == FollowListType.followers) {
        cubit.loadMore();
      }
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _followingScrollController.removeListener(_onFollowingScroll);
    _followingScrollController.dispose();
    _followersScrollController.removeListener(_onFollowersScroll);
    _followersScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FollowCubit, FollowState>(
      builder: (context, state) {
        return BaseScaffold(
          canPop: true,
          appBar: AppBarComponent(
            leading: BackButtonComponent(),
            title: TextComponent(text: widget.username),
          ),
          body: Container(
            height: context.height * 0.85,
            decoration: BoxDecoration(
              color: context.colors.secondary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(context.width * 0.05),
                topRight: Radius.circular(context.width * 0.05),
              ),
            ),
            child: Column(
              children: [
                _buildTabBar(context),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildTabContent(
                        context,
                        state.followersData,
                        _followersScrollController,
                      ),
                      _buildTabContent(
                        context,
                        state.followingData,
                        _followingScrollController,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return TabBar(
      controller: _tabController,
      labelColor: context.colors.primary,
      unselectedLabelColor: context.colors.primaryContainer,
      indicatorColor: context.colors.primary,
      indicatorSize: TabBarIndicatorSize.tab,
      labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      unselectedLabelStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      tabs: [
        Tab(text: "${AppStrings.PROFILE_FOLLOWER.tr()}  ${widget.followers}"),
        Tab(text: "${AppStrings.PROFILE_FOLLOWING.tr()}  ${widget.following}"),
      ],
    );
  }

  Widget _buildTabContent(
    BuildContext context,
    FollowTabData data,
    ScrollController scrollController,
  ) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.width * 0.065,
            vertical: context.height * 0.015,
          ),
          child: FollowListSearchField(
            onChanged: (value) {
              context.read<FollowCubit>().search(value);
            },
          ),
        ),
        Expanded(
          child: data.isLoading
              ? const Center(child: LoadingComponent())
              : _buildUserList(context, data, scrollController),
        ),
      ],
    );
  }

  Widget _buildUserList(
    BuildContext context,
    FollowTabData data,
    ScrollController scrollController,
  ) {
    if (data.users.isEmpty) {
      return Center(
        child: TextComponent(
          text: AppStrings.FOLLOW_LIST_EMPTY,
          size: FontSizeConstants.NORMAL,
          color: context.colors.primaryContainer,
        ),
      );
    }

    return ListView.builder(
      controller: scrollController,
      padding: EdgeInsets.symmetric(horizontal: context.width * 0.04),
      itemCount: data.users.length + (data.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == data.users.length) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: context.height * 0.02),
            child: const Center(child: LoadingComponent()),
          );
        }
        final user = data.users[index];
        return FollowListUserItem(
          user: user,
          onTap: () {
            context.pop(context);
            context.push(RouteConstants.USER, extra: user.id);
          },
        );
      },
    );
  }
}
