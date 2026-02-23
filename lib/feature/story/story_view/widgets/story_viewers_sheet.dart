import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/core/extensions/context.dart';
import 'package:rightflair/core/helpers/date.dart';
import 'package:rightflair/feature/main/feed/models/my_story_viewers.dart';
import 'package:rightflair/feature/story/story_view/cubit/story_view_cubit.dart';

class StoryViewersSheet extends StatefulWidget {
  const StoryViewersSheet({super.key});

  @override
  State<StoryViewersSheet> createState() => _StoryViewersSheetState();
}

class _StoryViewersSheetState extends State<StoryViewersSheet> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<StoryViewCubit>().loadMoreViewers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoryViewCubit, StoryViewState>(
      builder: (context, state) {
        return Container(
          height: context.height * 0.55,
          decoration: BoxDecoration(
            color: context.colors.shadow,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(context.width * 0.05),
            ),
          ),
          child: Column(
            children: [
              _handle(),
              _header(state),
              Divider(color: context.colors.primaryFixedDim, height: 1),
              Expanded(child: _viewersList(state)),
            ],
          ),
        );
      },
    );
  }

  Widget _handle() {
    return Padding(
      padding: EdgeInsets.only(
        top: context.height * 0.012,
        bottom: context.height * 0.007,
      ),
      child: Container(
        width: context.width * 0.09,
        height: context.height * 0.005,
        decoration: BoxDecoration(
          color: context.colors.onPrimaryFixed,
          borderRadius: BorderRadius.circular(context.width * 0.005),
        ),
      ),
    );
  }

  Widget _header(StoryViewState state) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.width * 0.04,
        vertical: context.height * 0.012,
      ),
      child: Row(
        children: [
          Icon(
            Icons.visibility_outlined,
            color: context.colors.primary,
            size: context.width * 0.05,
          ),
          SizedBox(width: context.width * 0.02),
          Text(
            '${state.totalViewCount}',
            style: TextStyle(
              color: context.colors.primary,
              fontSize: context.width * 0.04,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.close,
              color: context.colors.primaryContainer,
              size: context.width * 0.055,
            ),
          ),
        ],
      ),
    );
  }

  Widget _viewersList(StoryViewState state) {
    if (state.isViewersLoading && state.viewers.isEmpty) {
      return Center(
        child: CircularProgressIndicator(color: context.colors.primary),
      );
    }

    if (state.viewers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.visibility_off_outlined,
              color: context.colors.onPrimaryFixed,
              size: context.width * 0.12,
            ),
            SizedBox(height: context.height * 0.015),
            Text(
              'Henüz kimse görüntülemedi',
              style: TextStyle(
                color: context.colors.onPrimaryFixed,
                fontSize: context.width * 0.035,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(horizontal: context.width * 0.04),
      itemCount: state.viewers.length + (state.isViewersLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == state.viewers.length) {
          return Padding(
            padding: EdgeInsets.all(context.width * 0.04),
            child: Center(
              child: CircularProgressIndicator(
                color: context.colors.primary,
                strokeWidth: 2,
              ),
            ),
          );
        }

        final viewer = state.viewers[index];
        return _viewerTile(viewer);
      },
    );
  }

  Widget _viewerTile(MyStoryViewersModel viewer) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.height * 0.007),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: context.width * 0.055,
            backgroundColor: context.colors.primaryFixedDim,
            backgroundImage: viewer.profilePhotoUrl != null
                ? NetworkImage(viewer.profilePhotoUrl!)
                : null,
            child: viewer.profilePhotoUrl == null
                ? Icon(
                    Icons.person,
                    color: context.colors.primaryFixed,
                    size: context.width * 0.055,
                  )
                : null,
          ),
          SizedBox(width: context.width * 0.03),
          // Username + Full name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  viewer.username ?? '',
                  style: TextStyle(
                    color: context.colors.primary,
                    fontSize: context.width * 0.035,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (viewer.fullName != null && viewer.fullName!.isNotEmpty)
                  Text(
                    viewer.fullName!,
                    style: TextStyle(
                      color: context.colors.primaryFixed,
                      fontSize: context.width * 0.03,
                    ),
                  ),
              ],
            ),
          ),
          // Viewed time
          if (viewer.viewedAt != null)
            Text(
              DateHelper.timeAgo(viewer.viewedAt),
              style: TextStyle(
                color: context.colors.onPrimaryFixed,
                fontSize: context.width * 0.028,
              ),
            ),
        ],
      ),
    );
  }
}
