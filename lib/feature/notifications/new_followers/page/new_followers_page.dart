import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/core/components/loading.dart';
import 'package:rightflair/core/extensions/context.dart';

import '../../../../core/base/page/base_scaffold.dart';
import '../../../../core/components/appbar.dart';
import '../../../../core/components/button/back_button.dart';
import '../../../../core/components/button/settings_button.dart';
import '../../../../core/components/text/appbar_title.dart';
import '../../../../core/constants/string.dart';
import '../cubit/new_followers_cubit.dart';
import '../widgets/followers_list.dart';
import '../widgets/suggested_list.dart';

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
          body: state.isLoading
              ? SizedBox(
                  height: context.height,
                  width: context.width,
                  child: LoadingComponent(),
                )
              : _body(context, state),
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
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<NewFollowersCubit>().refresh();
      },
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.width * .05),
          child: Column(
            children: [
              NewFollowersListWidget(
                notifications: state.notifications ?? [],
                isLoadingMore: state.isLoadingMoreFollowers,
                hasNext: state.pagination?.hasNext,
              ),
              NewFollowersSuggestedListWidget(
                users: state.suggestedUsers ?? [],
                isLoadingMore: state.isLoadingMoreSuggested,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
