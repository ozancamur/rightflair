import 'package:flutter/material.dart';

import '../../../../core/components/text/text.dart';
import '../../../../core/constants/font/font_size.dart';
import '../../../../core/constants/string.dart';
import '../../../../core/extensions/context.dart';
import '../../../main/inbox/model/notification_sender.dart';
import 'suggested_account/suggested_account_item.dart';

class NewFollowersSuggestedListWidget extends StatelessWidget {
  final List<NotificationSenderModel> users;
  final bool isLoadingMore;
  const NewFollowersSuggestedListWidget({
    super.key,
    required this.users,
    required this.isLoadingMore,
  });

  @override
  Widget build(BuildContext context) {
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
        if (isLoadingMore)
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
