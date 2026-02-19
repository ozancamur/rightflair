import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/constants/icons.dart';
import '../../../core/constants/string.dart';
import '../../../core/extensions/context.dart';
import '../cubit/share_cubit.dart';

class ShareSearchBarWidget extends StatelessWidget {
  const ShareSearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ShareCubit>();
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.width * 0.04),
      child: Container(
        height: context.height * 0.055,
        decoration: BoxDecoration(
          color: context.colors.shadow,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          controller: cubit.searchController,
          focusNode: cubit.searchFocusNode,
          style: TextStyle(
            color: context.colors.primary,
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
          cursorColor: context.colors.primary,
          onChanged: (query) => cubit.searchUsers(query),
          decoration: InputDecoration(
            fillColor: context.colors.onSecondary,
            filled: true,
            hintText: AppStrings.SEARCH_PLACEHOLDER.tr(),
            hintStyle: TextStyle(
              color: context.colors.onPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: Padding(
              padding: EdgeInsets.only(
                left: context.width * 0.04,
                right: context.width * 0.035,
              ),
              child: SvgPicture.asset(
                AppIcons.SEARCH_FILLED,
                width: context.width * 0.01,
                height: context.width * 0.01,
                colorFilter: ColorFilter.mode(
                  context.colors.primaryContainer,
                  BlendMode.srcIn,
                ),
              ),
            ),
            border: border,
            enabledBorder: border,
            focusedBorder: border,
            contentPadding: EdgeInsets.symmetric(
              horizontal: context.width * 0.04,
              vertical: context.height * 0.018,
            ),
          ),
        ),
      ),
    );
  }
}
