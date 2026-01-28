import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/core/components/loading.dart';
import 'package:rightflair/core/extensions/context.dart';
import 'package:rightflair/core/components/profile/profile_header.dart';

import '../../../../../core/base/page/base_scaffold.dart';
import '../widgets/profile_appbar.dart';
import '../cubit/profile_cubit.dart';
import '../widgets/profile_tab_bars.dart';
import '../widgets/profile_tab_views.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (_tabController.index == 0) {
        context.read<ProfileCubit>().loadMorePosts();
      } else if (_tabController.index == 1) {
        context.read<ProfileCubit>().loadMoreSaves();
      } else if (_tabController.index == 2) {
        context.read<ProfileCubit>().loadMoreDrafts();
      }
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return BaseScaffold(
          appBar: const ProfileAppbarWidget(),
          body: _body(context, state),
        );
      },
    );
  }

  RefreshIndicator _body(BuildContext context, ProfileState state) {
    return RefreshIndicator(
      onRefresh: () async => context.read<ProfileCubit>().refresh(),
      child: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: context.width * 0.05),
            child: state.isLoading ? _loading(context) : _user(context, state),
          ),
        ),
      ),
    );
  }

  Column _user(BuildContext context, ProfileState state) {
    return Column(
      spacing: context.height * .01,
      children: [
        ProfileHeaderComponent(
          isCanEdit: true,
          user: state.user,
          tags: state.tags?.styleTags ?? [],
          onEditPhoto: () => context.read<ProfileCubit>().changePhotoDialog(
            context,
            userId: state.user.id,
          ),
        ),
        ProfileTabBarsWidget(tabController: _tabController),
        ProfileTabViewsWidget(
          tabController: _tabController,
          posts: state.posts,
          saves: state.saves,
          drafts: state.drafts,
          isPostsLoading: state.isPostsLoading,
          isSavesLoading: state.isSavesLoading,
          isDraftsLoading: state.isDraftsLoading,
        ),
        if ((_tabController.index == 0 && state.isLoadingMorePosts) ||
            (_tabController.index == 1 && state.isLoadingMoreSaves) ||
            (_tabController.index == 2 && state.isLoadingMoreDrafts))
          Padding(
            padding: EdgeInsets.symmetric(vertical: context.height * 0.02),
            child: const LoadingComponent(),
          ),
      ],
    );
  }

  SizedBox _loading(BuildContext context) {
    return SizedBox(
      height: context.height * .7,
      width: context.width,
      child: const LoadingComponent(),
    );
  }
}
