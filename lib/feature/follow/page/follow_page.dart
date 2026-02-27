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
  const FollowPage({
    super.key,
    required this.username,
    this.userId,
    required this.listType,
  });

  @override
  State<FollowPage> createState() => _FollowPageState();
}

class _FollowPageState extends State<FollowPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.listType == FollowListType.following ? 0 : 1,
    );
    _tabController.addListener(_onTabChanged);

    context.read<FollowCubit>().init(
      listType: widget.listType,
      userId: widget.userId,
    );
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    final listType = _tabController.index == 0
        ? FollowListType.following
        : FollowListType.followers;
    context.read<FollowCubit>().init(listType: listType, userId: widget.userId);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<FollowCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FollowCubit, FollowState>(
      builder: (context, state) {
        return BaseScaffold(
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
                Container(
                  height: context.height * 0.001,
                  color: context.colors.primaryFixedDim,
                ),
                _buildTabBar(context),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.width * 0.04,
                    vertical: context.height * 0.015,
                  ),
                  child: FollowListSearchField(
                    onChanged: (value) {
                      context.read<FollowCubit>().search(value);
                    },
                  ),
                ),
                Expanded(
                  child: state.isLoading
                      ? const Center(child: LoadingComponent())
                      : _buildUserList(context, state),
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
      labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      unselectedLabelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      tabs: [
        Tab(text: AppStrings.PROFILE_FOLLOWING.tr()),
        Tab(text: AppStrings.PROFILE_FOLLOWER.tr()),
      ],
    );
  }

  Widget _buildUserList(BuildContext context, FollowState state) {
    if (state.users.isEmpty) {
      return Center(
        child: TextComponent(
          text: AppStrings.FOLLOW_LIST_EMPTY,
          size: FontSizeConstants.NORMAL,
          color: context.colors.primaryContainer,
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(horizontal: context.width * 0.04),
      itemCount: state.users.length + (state.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == state.users.length) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: context.height * 0.02),
            child: const Center(child: LoadingComponent()),
          );
        }
        final user = state.users[index];
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
