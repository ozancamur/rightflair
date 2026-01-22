import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rightflair/core/constants/font/font_size.dart';
import 'package:rightflair/core/extensions/context.dart';

class ProfileEditTextFieldWidget extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final int? maxLength;
  final int maxLines;
  final Widget? suffix;
  final String? prefixText;

  const ProfileEditTextFieldWidget({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.maxLength,
    this.maxLines = 1,
    this.suffix,
    this.prefixText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: context.height * 0.01,
      children: [_label(context), _textField(context)],
    );
  }

  Widget _label(BuildContext context) {
    return Text(
      label.tr(),
      style: TextStyle(
        color: context.colors.primary,
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
        color: context.colors.primary,
        fontSize: FontSizeConstants.NORMAL.first,
        fontWeight: FontWeight.w400,
      ),
      cursorColor: context.colors.primary,
      decoration: InputDecoration(
        prefixText: prefixText,
        prefixStyle: TextStyle(
          color: context.colors.primary,
          fontSize: FontSizeConstants.NORMAL.first,
          fontWeight: FontWeight.w400,
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          color: context.colors.primaryFixed,
          fontSize: FontSizeConstants.NORMAL.first,
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: context.colors.secondary,
        counterText: maxLines > 1 ? null : "",
        counterStyle: TextStyle(
          color: context.colors.onPrimary,
          fontSize: FontSizeConstants.X_SMALL.first,
        ),
        suffix: suffix,
        contentPadding: EdgeInsets.symmetric(
          horizontal: context.width * 0.045,
          vertical: context.height * 0.015,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.width * 0.03),
          borderSide: BorderSide(color: context.colors.primaryFixedDim),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.width * 0.03),
          borderSide: BorderSide(color: context.colors.primaryFixedDim),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.width * 0.03),
          borderSide: BorderSide(color: context.colors.onPrimaryFixed),
        ),
      ),
    );
  }
}
