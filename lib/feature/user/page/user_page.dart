import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/core/constants/string.dart';
import 'package:rightflair/core/extensions/context.dart';
import 'package:rightflair/core/components/profile/profile_header_widget.dart';
import 'package:rightflair/core/components/profile/profile_photo_grid_widget.dart';
import 'package:rightflair/feature/authentication/model/user.dart';

import '../../../core/base/page/base_scaffold.dart';
import '../../../core/components/profile/profile_tab_item.dart';
import '../cubit/user_cubit.dart';
import '../widgets/user_appbar.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        return BaseScaffold(
          appBar: const UserAppbarWidget(),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: context.width * 0.05),
                child: Column(
                  spacing: context.height * 0.025,
                  children: [
                    ProfileHeaderWidget(
                      user: UserModel(),
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
