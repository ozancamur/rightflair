import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/components/text/text.dart';
import '../../../../core/constants/font/font_size.dart';
import '../../../../core/constants/icons.dart';
import '../../../../core/constants/string.dart';
import '../../../../core/extensions/context.dart';
import '../cubit/new_followers_cubit.dart';
import '../model/new_follower.dart';
import 'follower/follower_item.dart';

class NewFollowersListWidget extends StatelessWidget {
  final List<NewFollowerModel> notifications;
  final bool isLoadingMore;
  final bool? hasNext;
  const NewFollowersListWidget({
    super.key,
    required this.notifications,
    required this.isLoadingMore,
    this.hasNext = false,
  });

  @override
  Widget build(BuildContext context) {
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
        if (hasNext == true)
          Center(
            child: TextButton(
              onPressed: () {
                context.read<NewFollowersCubit>().loadMoreFollowers();
              },
              child: isLoadingMore
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
}
