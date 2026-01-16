import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rightflair/core/constants/dark_color.dart';

import '../extensions/context.dart';

class TextFieldComponent extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final RegExp regExp;
  final String errorText;
  final FocusNode? focusNode;
  final Function()? onTap;
  final TextInputType? keyboardType;
  final TextCapitalization? textCapitalization;
  final Function(String)? onFieldSubmitted;
  final int maxLines;
  final int? maxLength;
  const TextFieldComponent({
    super.key,
    required this.controller,
    required this.hintText,
    required this.regExp,
    required this.errorText,
    this.focusNode,
    this.onTap,
    this.keyboardType,
    this.textCapitalization,
    this.onFieldSubmitted,
    this.maxLines = 1,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: false,
      focusNode: focusNode,
      controller: controller,
      onTap: onTap,
      maxLength: maxLength,
      maxLines: maxLines,
      style: _textStyle(),
      keyboardType: keyboardType,
      cursorColor: AppDarkColors.PRIMARY,
      onFieldSubmitted: onFieldSubmitted,
      textCapitalization: textCapitalization ?? TextCapitalization.none,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: context.width * .075,
          vertical: maxLines == 1
              ? context.height * .021
              : context.height * .01,
        ),
        errorMaxLines: 2,
        errorStyle: _errorStyle(),
        filled: true,
        fillColor: AppDarkColors.INACTIVE,
        hintText: hintText.tr(),
        hintStyle: _hintStyle(),
        enabledBorder: _buildBorderField(),
        focusedBorder: _buildBorderField(),
        errorBorder: _buildBorderField(color: Colors.red),
        focusedErrorBorder: _buildBorderField(),
        counterText: "",
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return errorText.tr();
        } else if (!regExp.hasMatch(value)) {
          return errorText.tr();
        }
        return null;
      },
    );
  }

  TextStyle _textStyle() {
    return TextStyle(
      color: AppDarkColors.PRIMARY,
      fontSize: 17,
      fontWeight: FontWeight.w500,
    );
  }

  TextStyle _errorStyle() {
    return TextStyle(
      color: Colors.red,
      fontSize: 12,
      fontWeight: FontWeight.w400,
    );
  }

  TextStyle _hintStyle() {
    return TextStyle(
      color: AppDarkColors.WHITE75,
      fontSize: 13,
      fontWeight: FontWeight.w400,
    );
  }

  OutlineInputBorder _buildBorderField({Color color = Colors.grey}) {
    return OutlineInputBorder(borderRadius: BorderRadius.circular(18));
  }
}
