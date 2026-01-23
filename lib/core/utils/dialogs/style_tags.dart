import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../feature/profile_edit/cubit/profile_edit_cubit.dart';
import '../../components/text.dart';
import '../../constants/font/font_size.dart';
import '../../constants/string.dart';
import '../../extensions/context.dart';

void dialogStyleTags(BuildContext context) {
  final profileEditCubit = context.read<ProfileEditCubit>();
  final styles = [
    AppStrings.OVERSIZED,
    AppStrings.STREETWEAR,
    AppStrings.MODELLING,
    AppStrings.CASUAL,
    AppStrings.FORMAL,
    AppStrings.VINTAGE,
    AppStrings.SPORTY,
    AppStrings.BOHEMIAN,
    AppStrings.Y2K,
    AppStrings.GOTH,
    AppStrings.MINIMALIST,
    AppStrings.TECHWEAR,
    AppStrings.SKATER,
    AppStrings.RETRO,
    AppStrings.CLEAN,
    AppStrings.GIRL,
  ];

  showModalBottomSheet(
    context: context,
    backgroundColor: context.colors.secondary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(context.width * 0.05),
      ),
    ),
    builder: (context) => Container(
      padding: EdgeInsets.all(context.width * 0.05),
      child: SizedBox(
        height: context.height * .5,
        width: context.width,
        child: ListView.separated(
          separatorBuilder: (context, index) => Divider(
            color: context.colors.tertiary,
            thickness: .25,
            height: .25,
          ),
          itemCount: styles.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: TextComponent(
                text: styles[index],
                color: context.colors.primary,
                weight: FontWeight.w500,
                size: FontSizeConstants.LARGE,
              ),
              onTap: () {
                profileEditCubit.addStyle(styles[index].tr());
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
    ),
  );
}
