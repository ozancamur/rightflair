import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rightflair/core/constants/dark_color.dart';
import 'package:rightflair/core/constants/font_size.dart';
import 'package:rightflair/core/extensions/context.dart';

class ProfileEditTextFieldWidget extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final int? maxLength;
  final int maxLines;
  final Widget? suffix;

  const ProfileEditTextFieldWidget({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.maxLength,
    this.maxLines = 1,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: context.height * 0.01,
      children: [_label(), _textField(context)],
    );
  }

  Widget _label() {
    return Text(
      label.tr(),
      style: TextStyle(
        color: AppDarkColors.PRIMARY,
        fontSize: FontSizeConstants.NORMAL.first,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _textField(BuildContext context) {
    return TextField(
      controller: controller,
      maxLength: maxLength,
      maxLines: maxLines,
      style: TextStyle(
        color: AppDarkColors.PRIMARY,
        fontSize: FontSizeConstants.NORMAL.first,
        fontWeight: FontWeight.w400,
      ),
      cursorColor: AppDarkColors.PRIMARY,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: AppDarkColors.WHITE50,
          fontSize: FontSizeConstants.NORMAL.first,
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: AppDarkColors.INACTIVE,
        counterText: maxLines > 1 ? null : "",
        counterStyle: TextStyle(
          color: AppDarkColors.WHITE60,
          fontSize: FontSizeConstants.X_SMALL.first,
        ),
        suffix: suffix,
        contentPadding: EdgeInsets.symmetric(
          horizontal: context.width * 0.045,
          vertical: context.height * 0.015,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.width * 0.03),
          borderSide: BorderSide(color: AppDarkColors.WHITE16),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.width * 0.03),
          borderSide: BorderSide(color: AppDarkColors.WHITE16),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.width * 0.03),
          borderSide: BorderSide(color: AppDarkColors.WHITE32),
        ),
      ),
    );
  }
}
