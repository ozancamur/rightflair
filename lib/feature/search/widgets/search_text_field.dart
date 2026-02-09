import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rightflair/core/constants/icons.dart';
import 'package:rightflair/core/extensions/context.dart';

class SearchTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final Function(String)? onSubmitted;
  final Function(String)? onChanged;
  final double borderRadius;

  const SearchTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hintText,
    this.onSubmitted,
    this.onChanged,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide.none,
    );

    return Container(
      height: context.height * 0.055,
      decoration: BoxDecoration(
        color: context.colors.shadow,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        style: _textStyle(context),
        cursorColor: context.colors.primary,
        onSubmitted: onSubmitted,
        onChanged: onChanged,
        decoration: InputDecoration(
          fillColor: context.colors.onSecondary,
          filled: true,
          hintText: hintText.tr(),
          hintStyle: _hintStyle(context),
          prefixIcon: _searchIcon(context),
          border: border,
          enabledBorder: border,
          focusedBorder: border,
          contentPadding: EdgeInsets.symmetric(
            horizontal: context.width * 0.04,
            vertical: context.height * 0.018,
          ),
        ),
      ),
    );
  }

  Widget _searchIcon(BuildContext context) {
    return Padding(
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
    );
  }

  TextStyle _textStyle(BuildContext context) {
    return TextStyle(
      color: context.colors.primary,
      fontSize: 13,
      fontWeight: FontWeight.w400,
    );
  }

  TextStyle _hintStyle(BuildContext context) {
    return TextStyle(
      color: context.colors.onPrimary,
      fontSize: 13,
      fontWeight: FontWeight.w400,
    );
  }
}
