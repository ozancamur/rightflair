import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/core/constants/string.dart';
import 'package:rightflair/core/extensions/context.dart';
import 'package:rightflair/core/components/profile/profile_header_widget.dart';

import '../../../../../core/base/page/base_scaffold.dart';
import '../widgets/profile_appbar.dart';
import '../cubit/profile_cubit.dart';
import '../widgets/profile_tab_bars.dart';
import '../widgets/profile_tab_views.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    
    final String url = "https://media.istockphoto.com/id/1495088043/tr/vekt%C3%B6r/user-profile-icon-avatar-or-person-icon-profile-picture-portrait-symbol-default-portrait.jpg?s=1024x1024&w=is&k=20&c=gKLAWzRAE77Y213dcbWWxa_l3I4FqKoUNTX1gPk363E=";

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return DefaultTabController(
          length: 3,
          child: BaseScaffold(
            appBar: const ProfileAppbarWidget(),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.width * 0.05,
                  ),
                  child: Column(
                    spacing: context.height * 0.025,
                    children: [
                      ProfileHeaderWidget(
                        isCanEdit: true,
                        profileImage: url,
                        name: 'Lorem Ipsum',
                        username: '@loremipsum',
                        followerCount: 17,
                        followingCount: 270,
                        bio: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry',
                        tags: [
                          AppStrings.PROFILE_OVERSIZED,
                          AppStrings.PROFILE_STREETWEAR,
                          AppStrings.PROFILE_MODELING,
                        ],
                      ),
                      ProfileTabBarsWidget(),
                      ProfileTabViewsWidget(
                        photos: state.photos,
                        saves: state.saves,
                        drafts: state.drafts,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
