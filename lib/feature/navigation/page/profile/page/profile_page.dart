import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/core/components/loading.dart';
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
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return DefaultTabController(
          length: 3,
          child: BaseScaffold(
            appBar: const ProfileAppbarWidget(),
            body: _body(context, state),
          ),
        );
      },
    );
  }

  SafeArea _body(BuildContext context, ProfileState state) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.width * 0.05),
          child: Column(
            spacing: context.height * 0.025,
            children: [
              state.isLoading
                  ? const LoadingComponent()
                  : ProfileHeaderWidget(
                      isCanEdit: true,
                      user: state.user,
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
    );
  }
}
