import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/components/drag_handle.dart';
import '../../../core/components/loading.dart';
import '../../../core/components/text/text.dart';
import '../../../core/constants/enums/follow_list_type.dart';
import '../../../core/constants/font/font_size.dart';
import '../../../core/constants/route.dart';
import '../../../core/constants/string.dart';
import '../../../core/extensions/context.dart';
import '../cubit/follow_list_cubit.dart';
import '../cubit/follow_list_state.dart';
import '../widgets/follow_list_search_field.dart';
import '../widgets/follow_list_user_item.dart';

class FollowListDialogPage extends StatefulWidget {
  final FollowListType listType;
  const FollowListDialogPage({super.key, required this.listType});

  @override
  State<FollowListDialogPage> createState() => _FollowListDialogPageState();
}

class _FollowListDialogPageState extends State<FollowListDialogPage> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<FollowListCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FollowListCubit, FollowListState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(top: context.height * 0.15),
          child: Container(
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
                const DragHandleComponent(),
                _buildHeader(context),
                Container(
                  height: context.height * 0.001,
                  color: context.colors.primaryFixedDim,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.width * 0.04,
                    vertical: context.height * 0.015,
                  ),
                  child: FollowListSearchField(
                    onChanged: (value) {
                      context.read<FollowListCubit>().search(value);
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

  Widget _buildHeader(BuildContext context) {
    final title = widget.listType == FollowListType.followers
        ? AppStrings.PROFILE_FOLLOWER.tr()
        : AppStrings.PROFILE_FOLLOWING.tr();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.height * 0.015),
      child: TextComponent(
        text: title,
        tr: false,
        size: FontSizeConstants.X_LARGE,
        weight: FontWeight.w600,
        color: context.colors.primary,
      ),
    );
  }

  Widget _buildUserList(BuildContext context, FollowListState state) {
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
