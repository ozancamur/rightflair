import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rightflair/core/constants/string.dart';
import 'package:rightflair/core/extensions/context.dart';

import 'create_post_describe_buttons.dart';

class CreatePostDescription extends StatelessWidget {
  final TextEditingController controller;
  const CreatePostDescription({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.height * 0.2,
      padding: EdgeInsets.all(context.width * 0.04),
      decoration: BoxDecoration(
        color: context.colors.shadow,
        borderRadius: BorderRadius.circular(context.width * 0.04),
        border: Border.all(color: context.colors.primaryFixedDim),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_field(context), const CreatePostDescribeButtonsWidget()],
      ),
    );
  }

  Expanded _field(BuildContext context) {
    return Expanded(
      child: TextField(
        controller: controller,
        maxLines: null,
        expands: true,
        style: TextStyle(color: context.colors.primary),
        decoration: InputDecoration(
          hintText: AppStrings.CREATE_POST_DESCRIPTION_PLACEHOLDER.tr(),
          hintStyle: TextStyle(color: context.colors.onPrimary),
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
