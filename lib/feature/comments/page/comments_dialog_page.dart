import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/core/components/loading.dart';
import 'package:rightflair/feature/comments/cubit/comments_cubit.dart';

import '../../../core/components/drag_handle.dart';
import '../../../core/extensions/context.dart';
import '../widgets/add_comment.dart';
import '../widgets/comments_header.dart';
import '../widgets/comments_list.dart';

class CommentsDialogPage extends StatefulWidget {
  final String postId;
  final VoidCallback onAddComment;
  const CommentsDialogPage({
    super.key,
    required this.postId,
    required this.onAddComment,
  });

  @override
  State<CommentsDialogPage> createState() => _CommentsDialogPageState();
}

class _CommentsDialogPageState extends State<CommentsDialogPage> {
  bool _isReply = false;
  String? _commentId;
  @override
  void initState() {
    super.initState();
    context.read<CommentsCubit>().init(pId: widget.postId);
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardOpen = keyboardHeight > 0;

    return BlocBuilder<CommentsCubit, CommentsState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(
            top: isKeyboardOpen ? context.height * 0.15 : context.height * 0.4,
            bottom: keyboardHeight,
          ),
          child: Container(
            height: context.height * 0.85,
            decoration: BoxDecoration(
              color: context.colors.secondary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(context.width * 0.05),
                topRight: Radius.circular(context.width * 0.05),
              ),
            ),
            child: state.isLoading
                ? LoadingComponent()
                : Column(
                    children: [
                      const DragHandleComponent(),
                      CommentsHeaderWidget(
                        commentCount: state.comments?.length ?? 0,
                      ),
                      Container(
                        height: context.height * 0.001,
                        color: context.colors.primaryFixedDim,
                      ),
                      CommentsListWidget(
                        comments: state.comments ?? [],
                        onReply: (String commentId) {
                          setState(() {
                            if (_commentId == commentId) {
                              _isReply = !_isReply;
                            } else {
                              _commentId = commentId;
                              _isReply = true;
                            }
                          });
                        },
                      ),
                      AddCommentWidget(
                        isReply: _isReply,
                        onAddComment: (text) {
                          widget.onAddComment();
                          context.read<CommentsCubit>().addComment(
                            postId: widget.postId,
                            content: text,
                            parentId: _isReply ? _commentId : null,
                          );
                        },
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
