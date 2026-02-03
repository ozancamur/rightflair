import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/icons.dart';
import '../../../core/constants/string.dart';
import '../../../core/extensions/context.dart';

class FollowListSearchField extends StatelessWidget {
  final Function(String) onChanged;
  const FollowListSearchField({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      style: TextStyle(
        color: context.colors.primary,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: context.width * 0.04,
          vertical: context.height * 0.015,
        ),
        filled: true,
        fillColor: context.colors.shadow,
        hintText: AppStrings.FOLLOW_LIST_SEARCH.tr(),
        hintStyle: TextStyle(
          color: context.colors.primaryContainer,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: Padding(
          padding: EdgeInsets.only(
            left: context.width * 0.04,
            right: context.width * 0.02,
          ),
          child: SvgPicture.asset(
            AppIcons.SEARCH_FILLED,
            height: context.height * 0.02,
            colorFilter: ColorFilter.mode(
              context.colors.primaryContainer,
              BlendMode.srcIn,
            ),
          ),
        ),
        prefixIconConstraints: BoxConstraints(maxHeight: context.height * 0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.width * 0.03),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.width * 0.03),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.width * 0.03),
          borderSide: BorderSide(
            color: context.colors.onSecondaryFixed,
            width: 1,
          ),
        ),
      ),
    );
  }
}
