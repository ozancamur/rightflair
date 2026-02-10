
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:rightflair/core/components/text/text.dart';
import 'package:rightflair/core/constants/font/font_size.dart';
import 'package:rightflair/core/constants/icons.dart';
import 'package:rightflair/core/constants/string.dart';
import 'package:rightflair/core/extensions/context.dart';

import '../cubit/user_cubit.dart';
import '../cubit/user_state.dart';

class UserNotificationPage extends StatefulWidget {
  final String id;
  final String name;
  final bool isNotificationEnabled;
  final bool isFollowing;
  const UserNotificationPage({
    super.key,
    required this.id,
    required this.name,
    required this.isNotificationEnabled,
    required this.isFollowing,
  });

  @override
  State<UserNotificationPage> createState() => _UserNotificationPageState();
}

class _UserNotificationPageState extends State<UserNotificationPage> {
  late String selectedOption;

  @override
  void initState() {
    super.initState();
    final currentState = context.read<UserCubit>().state;
    selectedOption = currentState.isNotificationEnabled
        ? AppStrings.NOTIFICATION_SETTINGS_OPTION_ALL
        : AppStrings.NOTIFICATION_SETTINGS_OPTION_NONE;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
      listener: (context, state) {
        setState(() {
          selectedOption = state.isNotificationEnabled
              ? AppStrings.NOTIFICATION_SETTINGS_OPTION_ALL
              : AppStrings.NOTIFICATION_SETTINGS_OPTION_NONE;
        });
      },
      child: Container(
        height: context.height * .325,
        width: context.width,
        padding: EdgeInsets.symmetric(
          horizontal: context.width * 0.05,
          vertical: context.height * 0.02,
        ),
        decoration: BoxDecoration(
          color: context.colors.secondary,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(context.width * 0.05),
            topRight: Radius.circular(context.width * 0.05),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _appbar(context),
            SizedBox(height: context.height * 0.02),
            _description(context),
            SizedBox(height: context.height * 0.02),
            _optionItem(
              context,
              option: AppStrings.NOTIFICATION_SETTINGS_OPTION_ALL,
              onTap: () {
                if (widget.isFollowing) {
                  context.read<UserCubit>().updateUserNotification(
                    uid: widget.id,
                    notification: true,
                  );
                }
              },
            ),
            SizedBox(height: context.height * 0.01),
            _optionItem(
              context,
              option: AppStrings.NOTIFICATION_SETTINGS_OPTION_NONE,
              onTap: () {
                if (widget.isFollowing) {
                  context.read<UserCubit>().updateUserNotification(
                    uid: widget.id,
                    notification: false,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Row _appbar(BuildContext context) {
    return Row(
      children: [
        Spacer(),
        TextComponent(
          text: AppStrings.NOTIFICATION_SETTINGS_TITLE.tr(),
          size: FontSizeConstants.LARGE,
          color: context.colors.primary,
        ),
        Expanded(
          child: Align(
            alignment: AlignmentGeometry.centerRight,
            child: GestureDetector(
              onTap: () => context.pop(),
              child: SvgPicture.asset(
                AppIcons.CLOSE,
                color: context.colors.primary,
                height: context.height * .015,
              ),
            ),
          ),
        ),
      ],
    );
  }

  TextComponent _description(BuildContext context) {
    return TextComponent(
      text: AppStrings.NOTIFICATION_SETTINGS_DESCRIPTION.tr(
        args: [widget.name],
      ),
      size: FontSizeConstants.NORMAL,
      color: context.colors.onPrimary,
    );
  }

  Widget _optionItem(
    BuildContext context, {
    required String option,
    required VoidCallback onTap,
  }) {
    final isSelected = selectedOption == option;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: context.height * 0.015),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextComponent(
              text: option.tr(),
              size: FontSizeConstants.LARGE,
              color: context.colors.primary,
            ),
            Container(
              width: context.width * 0.06,
              height: context.width * 0.06,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? context.colors.scrim
                      : context.colors.onPrimary.withOpacity(0.3),
                  width: 2,
                ),
                color: isSelected ? context.colors.scrim : Colors.transparent,
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: context.width * 0.025,
                        height: context.width * 0.025,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: context.colors.primary,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
