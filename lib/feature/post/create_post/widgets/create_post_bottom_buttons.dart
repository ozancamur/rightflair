import 'package:flutter/material.dart';
import 'package:rightflair/core/extensions/context.dart';

import 'buttons/draft_button.dart';
import 'buttons/post_button.dart';

class CreatePostBottomButtons extends StatelessWidget {
  final VoidCallback onDraft;
  final VoidCallback onPost;

  const CreatePostBottomButtons({
    super.key,
    required this.onDraft,
    required this.onPost,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.height * 0.02),
      child: Row(
        children: [
          Expanded(child: CreateDraftButtonWidget(onDraft: onDraft)),
          SizedBox(width: context.width * 0.04),
          Expanded(child: CreatePostButtonWidget(onPost: onPost)),
        ],
      ),
    );
  }
}
