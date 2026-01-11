import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/constants/dark_color.dart';
import '../../../core/constants/icons.dart';
import '../../../core/constants/string.dart';
import '../../../core/extensions/context.dart';
import '../cubit/create_post_cubit.dart';
import 'create_post_option_tile.dart';

import '../../location/page/location_page.dart';

class CreatePostOptionsWidget extends StatelessWidget {
  final bool isAnonymous;
  final bool allowComments;
  final String? selectedLocation;

  const CreatePostOptionsWidget({
    super.key,
    required this.isAnonymous,
    required this.allowComments,
    this.selectedLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildLocationTile(context),
        _buildAnonymousTile(context),
        _buildCommentsTile(context),
      ],
    );
  }

  Widget _buildLocationTile(BuildContext context) {
    return CreatePostOptionTile(
      title: AppStrings.CREATE_POST_LOCATION,
      subtitle: selectedLocation,
      iconPath: AppIcons.LOCATION,
      trailing: SvgPicture.asset(
        AppIcons.ARROW_RIGHT,
        colorFilter: ColorFilter.mode(AppDarkColors.WHITE60, BlendMode.srcIn),
        height: context.height * 0.015,
      ),
      onTap: () async {
        final result = await Navigator.push<String>(
          context,
          MaterialPageRoute(builder: (context) => LocationPage()),
        );
        if (result != null && context.mounted) {
          context.read<CreatePostCubit>().updateLocation(result);
        }
      },
    );
  }

  Widget _buildAnonymousTile(BuildContext context) {
    return CreatePostOptionTile(
      title: AppStrings.CREATE_POST_ANONYMOUSLY,
      subtitle: AppStrings.CREATE_POST_ANONYMOUSLY_SUBTITLE,
      iconPath: AppIcons.ANONYMOUS,
      trailing: Switch.adaptive(
        value: isAnonymous,
        activeColor: AppDarkColors.GREEN,
        onChanged: (value) =>
            context.read<CreatePostCubit>().toggleAnonymous(value),
      ),
    );
  }

  Widget _buildCommentsTile(BuildContext context) {
    return CreatePostOptionTile(
      title: AppStrings.CREATE_POST_ALLOW_COMMENTS,
      iconPath: AppIcons.COMMENTS,
      trailing: Switch.adaptive(
        padding: EdgeInsets.zero,
        value: allowComments,
        activeColor: AppDarkColors.GREEN,
        onChanged: (value) =>
            context.read<CreatePostCubit>().toggleAllowComments(value),
      ),
    );
  }
}
