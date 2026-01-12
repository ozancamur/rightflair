import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/dark_color.dart';
import '../../../core/constants/font_size.dart';
import '../../../core/constants/string.dart';
import '../../../core/extensions/context.dart';

class AddCommentWidget extends StatelessWidget {
  final Function(String) onAddComment;
  AddCommentWidget({super.key, required this.onAddComment});

  final TextEditingController _commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.width * 0.04),
      decoration: BoxDecoration(
        color: AppDarkColors.INACTIVE,
        border: Border(
          top: BorderSide(
            color: AppDarkColors.WHITE16,
            width: context.height * 0.001,
          ),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: context.width * 0.045,
            backgroundColor: AppDarkColors.DARK_BUTTON,
          ),
          SizedBox(width: context.width * 0.03),

          // Text Input
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.width * 0.04,
                vertical: context.height * 0.012,
              ),
              decoration: BoxDecoration(
                color: AppDarkColors.WHITE16,
                borderRadius: BorderRadius.circular(context.width * 0.05),
              ),
              child: TextField(
                controller: _commentController,
                style: TextStyle(
                  color: AppDarkColors.PRIMARY,
                  fontSize: FontSizeConstants.SMALL[1],
                ),
                decoration: InputDecoration(
                  hintText: AppStrings.COMMENTS_ADD_PLACEHOLDER.tr(),
                  hintStyle: TextStyle(
                    color: AppDarkColors.WHITE50,
                    fontSize: FontSizeConstants.SMALL[1],
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                maxLines: null,
              ),
            ),
          ),
          SizedBox(width: context.width * 0.03),

          // Send Button
          GestureDetector(
            onTap: () {
              if (_commentController.text.trim().isNotEmpty) {
                onAddComment(_commentController.text.trim());
                _commentController.clear();
              }
            },
            child: Container(
              width: context.width * 0.1,
              height: context.width * 0.1,
              decoration: BoxDecoration(
                color: AppDarkColors.ORANGE,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.send,
                color: AppDarkColors.PRIMARY,
                size: context.width * 0.05,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
