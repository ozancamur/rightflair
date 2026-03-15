import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rightflair/core/components/loading.dart';
import 'package:rightflair/core/constants/route.dart';
import 'package:rightflair/core/extensions/context.dart';
import 'package:rightflair/core/components/profile/profile_header.dart';
import '../../../../core/base/page/base_scaffold.dart';
import '../../../story/create_story/page/create_story_dialog.dart';
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
          appBar: ProfileAppbarWidget(userId: state.user.id ?? ''),
          body: _body(context, state),
        );
      },
    );
  }

  RefreshIndicator _body(BuildContext context, ProfileState state) {
    return RefreshIndicator(
      color: context.colors.primary,
      backgroundColor: context.colors.secondary,
      onRefresh: () async => context.read<ProfileCubit>().refresh(),
      child: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: context.width * 0.05),
            child: state.isLoading
                ? _loading(context)
                : _content(context, state),
          ),
        ),
      ),
    );
  }

  Column _content(BuildContext context, ProfileState state) {
    return Column(
      children: [
        _user(state, context),
        SizedBox(height: context.height * 0.005),
        ProfileTabBarsWidget(tabController: _tabController),
        SizedBox(height: context.height * 0.01),
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

  ProfileHeaderComponent _user(ProfileState state, BuildContext context) {
    return ProfileHeaderComponent(
      isCanEdit: true,
      user: state.user,
      tags: state.tags?.styleTags ?? [],
      userStories: state.userStories,
      onStoryTap: () async {
        final stories = state.userStories;
        if (stories != null && (stories.stories?.isNotEmpty ?? false)) {
          await context.push(
            RouteConstants.STORY_VIEWER,
            extra: {
              'isMyStory': true,
              'allStories': [stories],
              'initialUserIndex': 0,
              'onStoryDeleted': context.read<ProfileCubit>().refreshStories(),
            },
          );
          if (context.mounted) {
            await context.read<ProfileCubit>().refreshStories();
            if (context.mounted) {
              context.read<ProfileCubit>().markOwnStoriesAsViewed();
            }
          }
        }
      },
      onEditPhoto: () async {
        await dialogCreateStory(context, uid: state.user.id ?? '');
        if (context.mounted) {
          await context.read<ProfileCubit>().refreshStories();
          if (context.mounted) {
            final stories = context.read<ProfileCubit>().state.userStories;
            if (stories != null && (stories.stories?.isNotEmpty ?? false)) {
              await context.push(
                RouteConstants.STORY_VIEWER,
                extra: {
                  'isMyStory': true,
                  'allStories': [stories],
                  'initialUserIndex': 0,
                  'onStoryDeleted': context.read<ProfileCubit>().refreshStories,
                },
              );
            }
          }
        }
      },
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
