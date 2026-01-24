import 'package:flutter/material.dart';

import '../../../../../core/components/profile/profile_post_grid.dart';
import '../../../../create_post/model/post.dart';

class ProfileTabViewsWidget extends StatefulWidget {
  final TabController? tabController;
  final List<PostModel>? posts;
  final bool isPostsLoading;
  final List<PostModel>? saves;
  final bool isSavesLoading;
  final List<PostModel>? drafts;
  final bool isDraftsLoading;
  const ProfileTabViewsWidget({
    super.key,
    this.tabController,
    required this.posts,
    required this.saves,
    required this.drafts,
    required this.isPostsLoading,
    required this.isSavesLoading,
    required this.isDraftsLoading,
  });

  @override
  State<ProfileTabViewsWidget> createState() => _ProfileTabViewsWidgetState();
}

class _ProfileTabViewsWidgetState extends State<ProfileTabViewsWidget> {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    if (widget.tabController != null) {
      _tabController = widget.tabController;
      _tabController?.addListener(_handleTabSelection);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.tabController == null) {
      final newController = DefaultTabController.of(context);
      if (newController != _tabController) {
        _tabController?.removeListener(_handleTabSelection);
        _tabController = newController;
        _tabController?.addListener(_handleTabSelection);
      }
    }
  }

  @override
  void didUpdateWidget(ProfileTabViewsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.tabController != oldWidget.tabController) {
      if (oldWidget.tabController != null) {
        oldWidget.tabController!.removeListener(_handleTabSelection);
      }
      if (widget.tabController != null) {
        _tabController = widget.tabController;
        _tabController!.addListener(_handleTabSelection);
      }
    }
  }

  @override
  void dispose() {
    _tabController?.removeListener(_handleTabSelection);
    super.dispose();
  }

  void _handleTabSelection() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final index = _tabController?.index ?? 0;
    switch (index) {
      case 0:
        return ProfilePostGridComponent(
          posts: widget.posts,
          isLoading: widget.isPostsLoading,
        );
      case 1:
        return ProfilePostGridComponent(
          posts: widget.saves,
          isLoading: widget.isSavesLoading,
        );
      case 2:
        return ProfilePostGridComponent(
          posts: widget.drafts,
          isLoading: widget.isDraftsLoading,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
