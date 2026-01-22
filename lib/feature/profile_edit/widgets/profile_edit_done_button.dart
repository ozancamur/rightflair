import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/core/components/text.dart';
import 'package:rightflair/core/constants/font/font_size.dart';

import '../../../core/constants/string.dart';
import '../../../core/extensions/context.dart';
import '../../authentication/model/user.dart';
import '../cubit/profile_edit_cubit.dart';

class ProfileEditDoneButtonWidget extends StatelessWidget {
  final UserModel user;
  const ProfileEditDoneButtonWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<ProfileEditCubit>().saveProfile(user);
        Navigator.pop(context);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: context.height * 0.0125),
        padding: EdgeInsets.symmetric(horizontal: context.width * 0.04),
        decoration: BoxDecoration(
          color: context.colors.onPrimaryContainer,
          border: Border.all(width: .5, color: context.colors.primaryFixedDim),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: TextComponent(
            text: AppStrings.PROFILE_EDIT_DONE,
            color: context.colors.primary,
            size: FontSizeConstants.SMALL,
            weight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
