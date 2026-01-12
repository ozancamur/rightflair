import 'package:flutter/material.dart';
import 'package:rightflair/core/constants/dark_color.dart';
import 'package:rightflair/core/constants/string.dart';
import 'package:rightflair/core/extensions/context.dart';
import 'package:rightflair/feature/profile/widgets/profile_header_widget.dart';
import 'package:rightflair/feature/profile/widgets/profile_photo_grid_widget.dart';

import '../widgets/profile_appbar.dart';
import '../widgets/profile_tab_bars.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final String url =
        "https://media.istockphoto.com/id/1495088043/tr/vekt%C3%B6r/user-profile-icon-avatar-or-person-icon-profile-picture-portrait-symbol-default-portrait.jpg?s=1024x1024&w=is&k=20&c=gKLAWzRAE77Y213dcbWWxa_l3I4FqKoUNTX1gPk363E=";

    return Scaffold(
      appBar: const ProfileAppbarWidget(),
      backgroundColor: AppDarkColors.SECONDARY,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: context.width * 0.05),
            child: Column(
              spacing: context.height * 0.025,
              children: [
                ProfileHeaderWidget(
                  profileImage: url,
                  name: 'Lorem Ipsum',
                  username: '@loremipsum',
                  followerCount: 17,
                  followingCount: 270,
                  bio:
                      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry',
                  tags: [
                    AppStrings.PROFILE_OVERSIZED,
                    AppStrings.PROFILE_STREETWEAR,
                    AppStrings.PROFILE_MODELING,
                  ],
                  onFollowTap: () {},
                  onMessageTap: () {},
                ),
                ProfileTabBarsWidget(),
                ProfilePhotoGridWidget(
                  photos: [
                    'https://media.istockphoto.com/id/1657460312/tr/foto%C4%9Fraf/beautiful-sensual-woman.jpg?s=1024x1024&w=is&k=20&c=mpNuQR920Mv2wZoFr-J13OOjS_rjcNNVZmusAvqMYV8=',
                    'https://media.istockphoto.com/id/1362588255/tr/foto%C4%9Fraf/beautiful-brunette-woman-walking-on-sunset-beach-in-fashionable-maxi-dress-relaxing-on.jpg?s=1024x1024&w=is&k=20&c=hKza9LJ80QTYijNY1kMKKuRjhA6J00-1x8gh943g0gc=',
                    'https://media.istockphoto.com/id/1311415818/tr/foto%C4%9Fraf/giyindim-ve-hayallerimin-pe%C5%9Finden-gitmeye-haz%C4%B1r.jpg?s=1024x1024&w=is&k=20&c=UMSoGayVya20IjU0AKsGNs1EnFf_HKZ7pX-B5_MliM0=',
                    'https://media.istockphoto.com/id/1462655622/tr/foto%C4%9Fraf/beautiful-woman-in-a-leather-suit-looking-masculine.jpg?s=1024x1024&w=is&k=20&c=z3rSRE4jNYtQ0lD2Lzn0_idWA-o9SElixR-qwY3M4Ss=',
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
