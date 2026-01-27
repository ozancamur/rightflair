import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../extensions/context.dart';

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
      style: _textStyle(context),
      keyboardType: keyboardType,
      cursorColor: context.colors.primary,
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
        fillColor: context.colors.shadow,
        hintText: hintText.tr(),
        hintStyle: _hintStyle(context),
        enabledBorder: _buildBorderField(color: context.colors.secondaryFixed),
        focusedBorder: _buildBorderField(
          color: context.colors.onSecondaryFixed,
        ),
        errorBorder: _buildBorderField(color: Colors.red),
        focusedErrorBorder: _buildBorderField(color: context.colors.error),
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

  TextStyle _textStyle(BuildContext context) {
    return TextStyle(
      color: context.colors.primary,
      fontSize: 14,
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

  TextStyle _hintStyle(BuildContext context) {
    return TextStyle(
      color: context.colors.primaryContainer,
      fontSize: 13,
      fontWeight: FontWeight.w400,
    );
  }

  OutlineInputBorder _buildBorderField({required Color color}) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color),
      borderRadius: BorderRadius.circular(18),
    );
  }
}
