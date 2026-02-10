import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/font/font_size.dart';
import '../../../../core/constants/string.dart';
import '../../../../core/extensions/context.dart';

class AddCommentWidget extends StatefulWidget {
  final bool isReply;
  final Function(String text) onAddComment;
  const AddCommentWidget({
    super.key,
    required this.isReply,
    required this.onAddComment,
  });

  @override
  State<AddCommentWidget> createState() => _AddCommentWidgetState();
}

class _AddCommentWidgetState extends State<AddCommentWidget> {
  late final TextEditingController _commentController;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.unfocus();
    _focusNode.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.height * .1,
      padding: EdgeInsets.symmetric(horizontal: context.width * 0.04),
      decoration: BoxDecoration(
        color: context.colors.secondary,
        border: Border(
          top: BorderSide(
            color: context.colors.primaryFixedDim,
            width: context.height * 0.001,
          ),
        ),
      ),
      child: Row(
        children: [
          widget.isReply
              ? Padding(
                  padding: EdgeInsets.only(right: context.width * 0.01),
                  child: Icon(
                    Icons.subdirectory_arrow_right_rounded,
                    color: context.colors.primaryFixed,
                    size: context.width * 0.06,
                  ),
                )
              : SizedBox.shrink(),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.width * 0.04,
                vertical: context.height * 0.012,
              ),
              decoration: BoxDecoration(
                color: context.colors.primaryFixedDim,
                borderRadius: BorderRadius.circular(context.width * 0.05),
              ),
              child: TextField(
                controller: _commentController,
                focusNode: _focusNode,
                style: TextStyle(
                  color: context.colors.primary,
                  fontSize: FontSizeConstants.SMALL[1],
                ),
                decoration: InputDecoration(
                  hintText: AppStrings.COMMENTS_ADD_PLACEHOLDER.tr(),
                  hintStyle: TextStyle(
                    color: context.colors.primaryFixed,
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
                widget.onAddComment(_commentController.text.trim());
                _commentController.clear();
              }
            },
            child: Container(
              width: context.width * 0.1,
              height: context.width * 0.1,
              decoration: BoxDecoration(
                color: context.colors.scrim,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.send,
                color: context.colors.primary,
                size: context.width * 0.05,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
