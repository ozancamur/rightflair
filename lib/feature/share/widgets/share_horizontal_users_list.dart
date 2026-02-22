import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/color/color.dart';
import '../../../core/constants/icons.dart';
import '../../../core/extensions/context.dart';
import '../cubit/share_cubit.dart';
import '../model/share.dart';

class ShareHorizontalUsersListWidget extends StatelessWidget {
  const ShareHorizontalUsersListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShareCubit, ShareState>(
      buildWhen: (prev, curr) =>
          prev.users != curr.users ||
          prev.isLoading != curr.isLoading ||
          prev.selectedUser != curr.selectedUser,
      builder: (context, state) {
        if (state.isLoading && state.users.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: context.height * 0.03),
            child: SizedBox(
              width: context.width * 0.05,
              height: context.width * 0.05,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: context.colors.primary,
              ),
            ),
          );
        }

        if (state.users.isEmpty) {
          return SizedBox(height: context.height * 0.12);
        }

        return SizedBox(
          height: context.height * 0.12,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: context.width * 0.03),
            itemCount: state.users.length,
            itemBuilder: (context, index) {
              final user = state.users[index];
              final isSelected = state.selectedUser?.id == user.id;
              return _UserItem(user: user, isSelected: isSelected);
            },
          ),
        );
      },
    );
  }
}

class _UserItem extends StatelessWidget {
  final SearchUserModel user;
  final bool isSelected;
  const _UserItem({required this.user, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final size = context.width * 0.15;

    return GestureDetector(
      onTap: () => context.read<ShareCubit>().toggleUserSelection(user),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.width * 0.02),
        child: SizedBox(
          width: size,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.ORANGE
                            : Colors.transparent,
                        width: 2.5,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: _buildAvatar(context, size - 9),
                    ),
                  ),
                  if (isSelected)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: size * 0.3,
                        height: size * 0.3,
                        decoration: BoxDecoration(
                          color: AppColors.ORANGE,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: context.colors.secondary,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: size * 0.17,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: context.height * 0.005),
              Text(
                user.fullName ?? user.username ?? '',
                style: TextStyle(
                  color: context.colors.primary,
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, double diameter) {
    if (user.profilePhotoUrl == null || user.profilePhotoUrl!.isEmpty) {
      return CircleAvatar(
        radius: diameter / 2,
        backgroundColor: Colors.grey.shade200,
        child: SvgPicture.asset(
          AppIcons.NON_PROFILE_PHOTO,
          height: diameter * 0.6,
          colorFilter: ColorFilter.mode(Colors.grey.shade500, BlendMode.srcIn),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: user.profilePhotoUrl!,
      imageBuilder: (_, imageProvider) => CircleAvatar(
        radius: diameter / 2,
        backgroundImage: imageProvider,
        backgroundColor: Colors.grey.shade200,
      ),
      placeholder: (_, __) => CircleAvatar(
        radius: diameter / 2,
        backgroundColor: Colors.grey.shade200,
      ),
      errorWidget: (_, __, ___) => CircleAvatar(
        radius: diameter / 2,
        backgroundColor: Colors.grey.shade200,
        child: SvgPicture.asset(
          AppIcons.NON_PROFILE_PHOTO,
          height: diameter * 0.6,
          colorFilter: ColorFilter.mode(Colors.grey.shade500, BlendMode.srcIn),
        ),
      ),
    );
  }
}
