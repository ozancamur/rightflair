import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rightflair/core/components/text/text.dart';
import 'package:rightflair/core/constants/font/font_size.dart';
import 'package:rightflair/core/extensions/context.dart';
import 'package:rightflair/feature/main/inbox/model/notification_sender.dart';

import '../../../../core/base/page/base_scaffold.dart';
import '../../../../core/components/appbar.dart';
import '../../../../core/components/button/back_button.dart';
import '../../../../core/components/button/settings_button.dart';
import '../../../../core/components/text/appbar_title.dart';
import '../../../../core/constants/icons.dart';
import '../../../../core/constants/string.dart';
import '../widgets/follower/follower_item.dart';
import '../widgets/suggested_account/suggested_account_item.dart';
import '../cubit/new_followers_cubit.dart';
import '../model/new_follower.dart';

class NewFollowersPage extends StatefulWidget {
  const NewFollowersPage({super.key});

  @override
  State<NewFollowersPage> createState() => _NewFollowersPageState();
}

class _NewFollowersPageState extends State<NewFollowersPage> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      final cubit = context.read<NewFollowersCubit>();
      cubit.loadMoreSuggestedUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewFollowersCubit, NewFollowersState>(
      builder: (context, state) {
        return BaseScaffold(
          appBar: _appbar(context),
          body: _body(context, state),
        );
      },
    );
  }

  AppBarComponent _appbar(BuildContext context) {
    return AppBarComponent(
      leading: BackButtonComponent(),
      title: AppbarTitleComponent(title: AppStrings.INBOX_NEW_FOLLOWERS_TITLE),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: context.width * .04),
          child: SettingsButtonComponent(),
        ),
      ],
    );
  }

  Widget _body(BuildContext context, NewFollowersState state) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.width * .05),
        child: Column(
          children: [
            _request(context, state.notifications ?? [], state),
            _suggested(context, state.suggestedUsers ?? [], state),
          ],
        ),
      ),
    );
  }

  Widget _request(
    BuildContext context,
    List<NewFollowerModel> notifications,
    NewFollowersState state,
  ) {
    return Column(
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(top: context.height * .015),
          itemCount: notifications.length,
          separatorBuilder: (context, index) =>
              SizedBox(height: context.height * .015),
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return FollowerItemWidget(follower: notification);
          },
        ),
        if (state.pagination?.hasNext == true)
          Center(
            child: TextButton(
              onPressed: () {
                context.read<NewFollowersCubit>().loadMoreFollowers();
              },
              child: state.isLoadingMoreFollowers
                  ? SizedBox(
                      height: context.height * .02,
                      width: context.height * .02,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: context.colors.primary,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: context.width * .02,
                      children: [
                        TextComponent(
                          text: AppStrings.INBOX_NEW_FOLLOWERS_VIEW_MORE,
                          size: FontSizeConstants.X_SMALL,
                          color: context.colors.primary,
                        ),
                        SvgPicture.asset(
                          AppIcons.ARROW_DOWN,
                          color: context.colors.primary,
                          height: context.height * .0125,
                        ),
                      ],
                    ),
            ),
          )
        else
          SizedBox(height: context.height * .02),
      ],
    );
  }

  Widget _suggested(
    BuildContext context,
    List<NotificationSenderModel> users,
    NewFollowersState state,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextComponent(
          text: AppStrings.INBOX_NEW_FOLLOWERS_SUGGESTED_ACCOUNTS,
          size: FontSizeConstants.LARGE,
          weight: FontWeight.w600,
          color: context.colors.primary,
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(
            bottom: context.height * .025,
            top: context.height * .01,
          ),
          itemCount: users.length,
          separatorBuilder: (context, index) =>
              SizedBox(height: context.height * .015),
          itemBuilder: (context, index) {
            final user = users[index];
            return SuggestedAccountItemWidget(user: user);
          },
        ),
        if (state.isLoadingMoreSuggested)
          Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: context.height * .02),
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: context.colors.primary,
              ),
            ),
          ),
      ],
    );
  }
}
