import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/core/components/loading.dart';
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

  RefreshIndicator _body(BuildContext context, ProfileState state) {
    return RefreshIndicator(
      onRefresh: () async => context.read<ProfileCubit>().refresh(),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: context.width * 0.05),
            child: state.isLoading ? _loading(context) : _user(context, state),
          ),
        ),
      ),
    );
  }

  Column _user(BuildContext context, ProfileState state) {
    return Column(
      spacing: context.height * 0.025,
      children: [
        ProfileHeaderWidget(
          isCanEdit: true,
          user: state.user,
          tags: state.tags?.styleTags ?? [],
          onEditPhoto: () => context.read<ProfileCubit>().changePhotoDialog(
            context,
            userId: state.user.id,
          ),
        ),
        ProfileTabBarsWidget(),
        ProfileTabViewsWidget(
          photos: state.photos,
          saves: state.saves,
          drafts: state.drafts,
        ),
      ],
    );
  }

  SizedBox _loading(BuildContext context) {
    return SizedBox(
      height: context.height * .7,
      width: context.width,
      child: const LoadingComponent(),
    );
  }
}
