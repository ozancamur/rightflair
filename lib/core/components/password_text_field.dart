import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rightflair/core/constants/icons.dart';

import '../extensions/context.dart';

class PasswordTextFieldComponent extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final RegExp regExp;
  final String errorText;
  final FocusNode? focusNode;
  final Function()? onTap;
  final TextInputType? keyboardType;
  final TextCapitalization? textCapitalization;
  final Function(String)? onFieldSubmitted;
  final int? maxLength;
  final String? Function(String?)? customValidator;
  const PasswordTextFieldComponent({
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
    this.maxLength,
    this.customValidator,
  });

  @override
  State<PasswordTextFieldComponent> createState() =>
      _PasswordTextFieldComponentState();
}

class _PasswordTextFieldComponentState
    extends State<PasswordTextFieldComponent> {
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: widget.focusNode,
      controller: widget.controller,
      onTap: widget.onTap,
      maxLength: widget.maxLength,
      style: _textStyle(),
      keyboardType: widget.keyboardType,
      cursorColor: context.colors.primary,
      onFieldSubmitted: widget.onFieldSubmitted,
      textCapitalization: widget.textCapitalization ?? TextCapitalization.none,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: context.width * .075,
          vertical: context.height * .021,
        ),
        errorMaxLines: 2,
        errorStyle: _errorStyle(),
        filled: true,
        fillColor: context.colors.shadow,
        hintText: widget.hintText.tr(),
        hintStyle: _hintStyle(),
        enabledBorder: _buildBorderField(color: context.colors.secondaryFixed),
        focusedBorder: _buildBorderField(color: context.colors.onSecondaryFixed),
        errorBorder: _buildBorderField(color: Colors.red),
        focusedErrorBorder: _buildBorderField(color: context.colors.error),
        counterText: "",

        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              obscureText = !obscureText;
            });
          },
          child: Container(
            width: context.width * .15,
            padding: EdgeInsets.only(
              top: context.height * .0125,
              bottom: context.height * .0125,
              right: context.width * .02,
            ),
            child: SvgPicture.asset(
              obscureText ? AppIcons.PASSWORD_HIDE : AppIcons.PASSWORD_SHOW,
              color: context.colors.primaryContainer,
              height: context.height * .01,
            ),
          ),
        ),
      ),
      obscureText: obscureText,
      validator: (value) {
        if (widget.customValidator != null) {
          return widget.customValidator!(value);
        }
        if (value == null || value.trim().isEmpty) {
          return widget.errorText.tr();
        } else if (!widget.regExp.hasMatch(value)) {
          return widget.errorText.tr();
        }
        return null;
      },
    );
  }

  TextStyle _textStyle() {
    return TextStyle(
      color: context.colors.primary,
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
