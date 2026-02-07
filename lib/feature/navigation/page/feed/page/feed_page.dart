import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/core/base/page/base_scaffold.dart';
import 'package:rightflair/core/extensions/context.dart';

import '../bloc/feed_bloc.dart';
import '../widgets/feed_appbar.dart';
import '../widgets/feed_tab_views.dart';
import '../widgets/feed_tab_bars.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  void initState() {
    super.initState();
    // Initialize feed only once when page is first created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final feedBloc = context.read<FeedBloc>();
      if (feedBloc.state.posts == null || feedBloc.state.posts!.isEmpty) {
        feedBloc.add(FeedInitializeEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: BaseScaffold(
        appBar: FeedAppbarWidget(),
        body: Padding(
          padding: EdgeInsets.only(
            right: context.width * .05,
            left: context.width * .05,
            bottom: context.height * .02,
          ),
          child: _body(context),
        ),
      ),
    );
  }

  Column _body(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [const FeedTabBars(), const FeedTabViews()],
    );
  }
}
