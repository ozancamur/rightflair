import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rightflair/core/components/text.dart';
import 'package:rightflair/core/constants/font_size.dart';
import 'package:rightflair/core/extensions/context.dart';

import '../../../../../core/base/base_scaffold.dart';
import '../../../../../core/components/appbar.dart';
import '../../../../../core/components/back_button.dart';
import '../../../../../core/components/settings_button.dart';
import '../../../../../core/constants/icons.dart';
import '../widgets/follower/follower_item.dart';
import '../widgets/suggested_account/suggested_account_item.dart';

class NewFollowersPage extends StatefulWidget {
  const NewFollowersPage({super.key});

  @override
  State<NewFollowersPage> createState() => _NewFollowersPageState();
}

class _NewFollowersPageState extends State<NewFollowersPage> {
  bool isViewMore = false;
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: _appbar(context),
      body: _body(context),
    );
  }

  AppBarComponent _appbar(BuildContext context) {
    return AppBarComponent(
      leading: BackButtonComponent(),
      title: "New Followers",
      actions: [
        Padding(
          padding: EdgeInsets.only(right: context.width * .04),
          child: SettingsButtonComponent(),
        ),
      ],
    );
  }

  Widget _body(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.width * .05),
        child: Column(children: [_request(context), _suggested(context)]),
      ),
    );
  }

  Widget _request(BuildContext context) {
    final itemCount = isViewMore ? 10 : 2;
    return Column(
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: context.height * .015),
          itemCount: itemCount,
          separatorBuilder: (context, index) =>
              SizedBox(height: context.height * .015),
          itemBuilder: (context, index) {
            return FollowerItemWidget(
              username: 'angi',
              subtitle: 'started following you.',
              timeAgo: '4h',
              profileImage: 'https://i.pravatar.cc/150?img=2',
            );
          },
        ),
        Center(
          child: TextButton(
            onPressed: () => setState(() => isViewMore = !isViewMore),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: context.width * .02,
              children: [
                TextComponent(
                  text: isViewMore ? 'hide' : 'view more',
                  size: FontSizeConstants.SMALL,
                  color: Colors.white,
                  tr: false,
                ),
                SvgPicture.asset(
                  isViewMore ? AppIcons.ARROW_UP : AppIcons.ARROW_DOWN,
                  color: Colors.white,
                  height: context.height * .02,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _suggested(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: context.height * .015),
      itemCount: 10,
      separatorBuilder: (context, index) =>
          SizedBox(height: context.height * .015),
      itemBuilder: (context, index) {
        return SuggestedAccountItemWidget(
          username: 'USER',
          handle: '@user32489',
          profileImage: 'https://i.pravatar.cc/150?img=5',
        );
      },
    );
  }
}
