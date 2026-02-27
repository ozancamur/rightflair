import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rightflair/core/constants/font/font_family.dart';
import 'package:rightflair/core/constants/route.dart';
import 'package:rightflair/core/extensions/context.dart';

import '../bloc/feed_bloc.dart';
import '../models/suggested_user.dart';

class SuggestedUsersList extends StatelessWidget {
  final List<SuggestedUserModel> suggestedUsers;

  const SuggestedUsersList({super.key, required this.suggestedUsers});

  @override
  Widget build(BuildContext context) {
    if (suggestedUsers.isEmpty) return const SizedBox.shrink();

    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: context.width * .02,
        vertical: context.height * .01,
      ),
      itemCount: suggestedUsers.length,
      itemBuilder: (context, index) {
        final user = suggestedUsers[index];
        return _SuggestedUserCard(user: user);
      },
    );
  }
}

class _SuggestedUserCard extends StatelessWidget {
  final SuggestedUserModel user;

  const _SuggestedUserCard({required this.user});

  String _getSubtitle() {
    switch (user.reason) {
      case 'followed_by_friends':
        if (user.mutualFriendsCount != null && user.mutualFriendsCount! > 0) {
          return 'Followed by ${user.mutualFriendsCount} friends';
        }
        return 'People you may know';
      case 'similar_tags':
        return 'Similar style to you';
      default:
        return 'People you may know';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.height * .012),
      child: Row(
        children: [
          // Avatar
          _buildAvatar(context),
          SizedBox(width: context.width * .035),
          // Name & subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.username ?? '',
                  style: TextStyle(
                    color: context.colors.primary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    fontFamily: FontFamilyConstants.POPPINS,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  _getSubtitle(),
                  style: TextStyle(
                    color: context.colors.primary.withValues(alpha: 0.6),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    fontFamily: FontFamilyConstants.POPPINS,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: context.height * .01),
                // Buttons
                Row(
                  children: [
                    _buildRemoveButton(context),
                    SizedBox(width: context.width * .025),
                    _buildFollowBackButton(context),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    final size = context.width * .17;
    return GestureDetector(
      onTap: () {
        if (user.id != null) {
          context.push(RouteConstants.USER, extra: user.id);
        }
      },
      child: ClipOval(
        child: SizedBox(
          width: size,
          height: size,
          child:
              user.profilePhotoUrl != null && user.profilePhotoUrl!.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: user.profilePhotoUrl!,
                  fit: BoxFit.cover,
                  placeholder: (_, _) => Container(
                    color: context.colors.surfaceContainerHighest,
                    child: Icon(
                      Icons.person,
                      color: context.colors.primary.withValues(alpha: 0.4),
                      size: size * 0.5,
                    ),
                  ),
                  errorWidget: (_, _, _) => Container(
                    color: context.colors.surfaceContainerHighest,
                    child: Icon(
                      Icons.person,
                      color: context.colors.primary.withValues(alpha: 0.4),
                      size: size * 0.5,
                    ),
                  ),
                )
              : Container(
                  color: context.colors.surfaceContainerHighest,
                  child: Icon(
                    Icons.person,
                    color: context.colors.primary.withValues(alpha: 0.4),
                    size: size * 0.5,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildRemoveButton(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (user.id != null) {
            context.read<FeedBloc>().add(
              RemoveSuggestedUserEvent(userId: user.id!),
            );
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: context.height * .012),
          decoration: BoxDecoration(
            color: Colors.grey.shade800,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Center(
            child: Text(
              'Remove',
              style: TextStyle(
                color: context.colors.primary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                fontFamily: FontFamilyConstants.POPPINS,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFollowBackButton(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (user.id != null) {
            context.read<FeedBloc>().add(
              FollowSuggestedUserEvent(userId: user.id!),
            );
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: context.height * .012),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.orange, Colors.yellow],
              begin: Alignment.topCenter,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Center(
            child: Text(
              'Follow',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                fontFamily: FontFamilyConstants.POPPINS,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
