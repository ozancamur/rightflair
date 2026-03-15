import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/context.dart';
import '../bloc/feed_bloc.dart';
import 'swipeable_post_stack.dart';

class FeedTabViews extends StatelessWidget {
  const FeedTabViews({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _RefreshableTab(tabIndex: 0),
          _RefreshableTab(tabIndex: 1),
          _RefreshableTab(tabIndex: 2),
        ],
      ),
    );
  }
}

class _RefreshableTab extends StatelessWidget {
  final int tabIndex;
  const _RefreshableTab({required this.tabIndex});

  Future<void> _onRefresh(BuildContext context) async {
    final bloc = context.read<FeedBloc>();
    bloc.add(RefreshTabEvent(tabIndex));

    // Wait until loading finishes for this tab
    await bloc.stream
        .firstWhere((state) => !state.isLoadingForTab(tabIndex))
        .timeout(const Duration(seconds: 10), onTimeout: () => bloc.state);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: context.colors.primary,
      backgroundColor: context.colors.secondary,
      onRefresh: () => _onRefresh(context),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            hasScrollBody: true,
            child: SwipeablePostStack(tabIndex: tabIndex),
          ),
        ],
      ),
    );
  }
}
