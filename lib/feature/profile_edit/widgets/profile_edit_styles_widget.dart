import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rightflair/core/components/text.dart';
import 'package:rightflair/core/constants/font/font_size.dart';
import 'package:rightflair/core/constants/string.dart';
import 'package:rightflair/core/extensions/context.dart';
import 'profile_edit_style_tag_widget.dart';

class ProfileEditStylesWidget extends StatelessWidget {
  final List<String> currentTags;
  final Function(String) onRemoveStyle;
  final VoidCallback onAddNew;
  final bool canAddMore;

  const ProfileEditStylesWidget({
    super.key,
    required this.currentTags,
    required this.onRemoveStyle,
    required this.onAddNew,
    required this.canAddMore,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: context.height * 0.015,
      children: [_header(context), _stylesList(context)],
    );
  }

  Widget _header(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          spacing: context.width * 0.02,
          children: [
            TextComponent(
              text: AppStrings.PROFILE_EDIT_MY_STYLES,
              color: context.colors.primary,
              size: FontSizeConstants.NORMAL,
              weight: FontWeight.w600,
            ),
            TextComponent(
              text: '${currentTags.length}/3',
              tr: false,
              color: context.colors.onPrimary,
              size: FontSizeConstants.SMALL,
              weight: FontWeight.w500,
            ),
          ],
        ),
        if (canAddMore)
          GestureDetector(
            onTap: onAddNew,
            child: Text(
              AppStrings.PROFILE_EDIT_ADD_NEW.tr(),
              style: TextStyle(
                color: context.colors.scrim,
                fontSize: FontSizeConstants.SMALL.first,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _stylesList(BuildContext context) {
    return Wrap(
      spacing: context.width * 0.025,
      runSpacing: context.height * 0.012,
      children: currentTags
          .map(
            (style) => ProfileEditStyleTagWidget(
              text: style,
              onRemove: () => onRemoveStyle(style),
            ),
          )
          .toList(),
    );
  }
}
