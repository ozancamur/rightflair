import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/core/constants/dark_color.dart';
import 'package:rightflair/core/constants/string.dart';
import 'package:rightflair/core/extensions/context.dart';
import 'package:rightflair/core/components/profile/profile_header_widget.dart';
import 'package:rightflair/core/components/profile/profile_photo_grid_widget.dart';

import '../../../core/components/profile/profile_tab_item.dart';
import '../cubit/user_cubit.dart';
import '../widgets/user_appbar.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String url =
        "https://media.istockphoto.com/id/1495088043/tr/vekt%C3%B6r/user-profile-icon-avatar-or-person-icon-profile-picture-portrait-symbol-default-portrait.jpg?s=1024x1024&w=is&k=20&c=gKLAWzRAE77Y213dcbWWxa_l3I4FqKoUNTX1gPk363E=";

    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        return Scaffold(
          appBar: const UserAppbarWidget(),
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
                    ProfileTabItemWidget(text: AppStrings.PROFILE_PHOTOS),
                    ProfilePhotoGridWidget(photos: state.photos),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
