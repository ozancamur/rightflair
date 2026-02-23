import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/components/loading.dart';
import '../../../core/components/text/text.dart';
import '../../../core/constants/font/font_size.dart';
import '../../../core/constants/icons.dart';
import '../../../core/constants/route.dart';
import '../../../core/constants/string.dart';
import '../../../core/extensions/context.dart';
import '../cubit/find_friends_cubit.dart';
import '../cubit/find_friends_state.dart';
import '../../main/inbox/model/notification_sender.dart';
import '../widgets/find_friends_action_tile.dart';
import '../widgets/find_friends_appbar.dart';
import '../widgets/find_friends_search.dart';
import '../widgets/suggested_user_card.dart';

class FindFriendsPage extends StatefulWidget {
  const FindFriendsPage({super.key});

  @override
  State<FindFriendsPage> createState() => _FindFriendsPageState();
}

class _FindFriendsPageState extends State<FindFriendsPage> {
  late ScrollController _scrollController;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _searchController = TextEditingController();
    _scrollController.addListener(_onScroll);
    context.read<FindFriendsCubit>().init();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<FindFriendsCubit>().loadMore();
    }
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<FindFriendsCubit>().search('');
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FindFriendsCubit, FindFriendsState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: context.colors.secondary,
          appBar: const FindFriendsAppbarWidget(),
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            behavior: HitTestBehavior.translucent,
            child: _body(context, state),
          ),
        );
      },
    );
  }

  Column _body(BuildContext context, FindFriendsState state) {
    return Column(
      children: [
        // Search field
        FindFriendsSearchWidget(
          controller: _searchController,
          isSearching: state.isSearching,
          onClear: _clearSearch,
        ),
        // Content
        Expanded(
          child: state.isLoading && !state.isLoadingMore
              ? const Center(child: LoadingComponent())
              : state.isSearching
              ? _buildSearchResults(context, state)
              : _buildMainContent(context, state),
        ),
      ],
    );
  }

  Widget _buildMainContent(BuildContext context, FindFriendsState state) {
    return ListView(
      controller: _scrollController,
      children: [
        // Action tiles
        FindFriendsActionTile(
          iconBackgroundColor: const Color(0xFFFFA726),
          iconPath: AppIcons.SHARE,
          title: AppStrings.FIND_FRIENDS_INVITE,
          subtitle: AppStrings.FIND_FRIENDS_INVITE_SUBTITLE,
          onTap: () {
            // TODO: Share profile invite
          },
        ),
        FindFriendsActionTile(
          iconBackgroundColor: const Color(0xFF66BB6A),
          iconPath: AppIcons.CONTACT,
          title: AppStrings.FIND_FRIENDS_CONTACTS,
          subtitle: AppStrings.FIND_FRIENDS_CONTACTS_SUBTITLE,
          onTap: () {
            // TODO: Find contacts
          },
        ),

        // Divider
        Padding(
          padding: EdgeInsets.symmetric(vertical: context.height * 0.01),
          child: Divider(color: context.colors.primaryFixedDim, height: 1),
        ),

        // Suggested accounts header
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.width * 0.04,
            vertical: context.height * 0.008,
          ),
          child: TextComponent(
            text: AppStrings.FIND_FRIENDS_SUGGESTED,
            size: FontSizeConstants.LARGE,
            weight: FontWeight.w700,
            color: context.colors.primary,
          ),
        ),

        // Suggested users list
        ...state.suggestedUsers.map(
          (user) => Column(
            children: [
              Divider(color: context.colors.primaryFixedDim, height: 1),
              SuggestedUserCard(
                user: user,
                onRemove: () {
                  context.read<FindFriendsCubit>().removeUser(user.id!);
                },
                onFollow: () {
                  context.read<FindFriendsCubit>().followUser(user.id!);
                },
                onTap: () {
                  context.push(RouteConstants.USER, extra: user.id);
                },
              ),
            ],
          ),
        ),

        // Loading more indicator
        if (state.isLoadingMore)
          Padding(
            padding: EdgeInsets.all(context.height * 0.02),
            child: const Center(child: LoadingComponent()),
          ),
      ],
    );
  }

  Widget _buildSearchResults(BuildContext context, FindFriendsState state) {
    if (state.searchResults.isEmpty && !state.isLoading) {
      return Center(
        child: TextComponent(
          text: AppStrings.FIND_FRIENDS_NO_RESULTS,
          size: FontSizeConstants.NORMAL,
          weight: FontWeight.w400,
          color: context.colors.primaryContainer,
        ),
      );
    }

    return ListView.separated(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(horizontal: context.width * 0.04),
      itemCount: state.searchResults.length + (state.isLoadingMore ? 1 : 0),
      separatorBuilder: (_, _) =>
          Divider(color: context.colors.primaryFixedDim, height: 1),
      itemBuilder: (context, index) {
        if (index == state.searchResults.length) {
          return Padding(
            padding: EdgeInsets.all(context.height * 0.02),
            child: const Center(child: LoadingComponent()),
          );
        }

        final user = state.searchResults[index];
        return _buildSearchUserItem(context, user);
      },
    );
  }

  Widget _buildSearchUserItem(
    BuildContext context,
    NotificationSenderModel user,
  ) {
    return InkWell(
      onTap: () {
        context.push(RouteConstants.USER, extra: user.id);
      },
      borderRadius: BorderRadius.circular(context.width * 0.02),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: context.height * 0.012),
        child: Row(
          children: [
            _buildSearchAvatar(context, user),
            SizedBox(width: context.width * 0.03),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextComponent(
                    text: user.fullName ?? '',
                    tr: false,
                    size: FontSizeConstants.NORMAL,
                    weight: FontWeight.w600,
                    color: context.colors.primary,
                    maxLine: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: context.height * 0.002),
                  TextComponent(
                    text: '@${user.username ?? ''}',
                    tr: false,
                    size: FontSizeConstants.SMALL,
                    weight: FontWeight.w400,
                    color: context.colors.primaryContainer,
                    maxLine: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: context.colors.primaryContainer,
              size: context.width * 0.05,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAvatar(
    BuildContext context,
    NotificationSenderModel user,
  ) {
    if (user.profilePhotoUrl == null || user.profilePhotoUrl!.isEmpty) {
      return CircleAvatar(
        radius: context.height * 0.028,
        backgroundColor: Colors.grey.shade200,
        child: SvgPicture.asset(
          AppIcons.NON_PROFILE_PHOTO,
          height: context.height * 0.03,
          colorFilter: ColorFilter.mode(Colors.grey.shade500, BlendMode.srcIn),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: user.profilePhotoUrl!,
      imageBuilder: (context, imageProvider) => CircleAvatar(
        radius: context.height * 0.028,
        backgroundImage: imageProvider,
        backgroundColor: Colors.grey.shade200,
      ),
      placeholder: (context, url) => CircleAvatar(
        radius: context.height * 0.028,
        backgroundColor: Colors.grey.shade200,
        child: const LoadingComponent(),
      ),
      errorWidget: (context, url, error) => CircleAvatar(
        radius: context.height * 0.028,
        backgroundColor: Colors.grey.shade200,
        child: SvgPicture.asset(
          AppIcons.NON_PROFILE_PHOTO,
          height: context.height * 0.03,
          colorFilter: ColorFilter.mode(Colors.grey.shade500, BlendMode.srcIn),
        ),
      ),
    );
  }
}
