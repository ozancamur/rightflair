import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/icons.dart';
import '../../../core/constants/string.dart';
import '../../../core/extensions/context.dart';

class FindFriendsSearchField extends StatelessWidget {
  final Function(String) onChanged;
  final TextEditingController? controller;
  final VoidCallback? onClear;
  final bool showClear;

  const FindFriendsSearchField({
    super.key,
    required this.onChanged,
    this.controller,
    this.onClear,
    this.showClear = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
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
        hintText: AppStrings.FIND_FRIENDS_SEARCH_HINT.tr(),
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
        suffixIcon: showClear
            ? GestureDetector(
                onTap: onClear,
                child: Padding(
                  padding: EdgeInsets.only(right: context.width * 0.02),
                  child: Icon(
                    Icons.close,
                    size: context.width * 0.05,
                    color: context.colors.primaryContainer,
                  ),
                ),
              )
            : null,
        suffixIconConstraints: BoxConstraints(maxHeight: context.height * 0.05),
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
