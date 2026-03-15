import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:translator/translator.dart';

import '../../../../core/extensions/context.dart';
import '../../../main/feed/models/comment.dart';
import 'comment_avatar.dart';
import 'comment_content.dart';
import 'comment_like_button.dart';
import 'comment_options_popup.dart';
import 'comment_report_page.dart';

class CommentWidget extends StatefulWidget {
  final CommentModel comment;
  final Function(String commentId) onReply;
  final VoidCallback? onLike;
  final bool canReply;
  const CommentWidget({
    super.key,
    required this.comment,
    required this.onReply,
    this.onLike,
    this.canReply = true,
  });

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  String? _translatedText;
  bool _isTranslating = false;
  bool _showTranslated = false;
  bool _isEnglish = true;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
    _detectLanguage();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (_) {
        _animController.forward();
        HapticFeedback.mediumImpact();
      },
      onLongPress: () {
        _animController.reverse();
        _showOptions(context);
      },
      onLongPressCancel: () => _animController.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) =>
            Transform.scale(scale: _scaleAnimation.value, child: child),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommentAvatarWidget(
                    avatar: widget.comment.user?.profilePhotoUrl,
                    username:
                        widget.comment.user?.username ?? "rightflair_user",
                  ),
                  SizedBox(width: context.width * 0.03),
                  CommentContentWidget(
                    comment: widget.comment,
                    displayText: _displayText,
                    isTranslating: _isTranslating,
                    showTranslated: _showTranslated,
                    onTranslate: _isEnglish ? null : _translateComment,
                    onReply: widget.onReply,
                    onLike: widget.onLike != null && widget.comment.id != null
                        ? (_) => widget.onLike!()
                        : null,
                    canReply: widget.canReply,
                  ),
                  CommentLikeButtonWidget(
                    isLiked: widget.comment.isLiked ?? false,
                    likeCount: widget.comment.likesCount ?? 0,
                    onLike: widget.onLike,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String get _displayText {
    if (_showTranslated && _translatedText != null) {
      return _translatedText!;
    }
    return widget.comment.content ?? '';
  }

  Future<void> _detectLanguage() async {
    final text = widget.comment.content ?? '';
    if (text.isEmpty) return;
    try {
      final translator = GoogleTranslator();
      final result = await translator.translate(text, to: 'en');
      if (mounted) {
        final original = text.trim().toLowerCase();
        final translated = result.text.trim().toLowerCase();
        setState(() {
          _isEnglish = original == translated;
        });
      }
    } catch (_) {}
  }

  Future<void> _translateComment() async {
    if (_showTranslated) {
      setState(() => _showTranslated = false);
      return;
    }
    if (_translatedText != null) {
      setState(() => _showTranslated = true);
      return;
    }
    final text = widget.comment.content ?? '';
    if (text.isEmpty) return;
    setState(() => _isTranslating = true);
    try {
      final translator = GoogleTranslator();
      final result = await translator.translate(text, to: 'en');
      if (mounted) {
        setState(() {
          _translatedText = result.text;
          _showTranslated = true;
          _isTranslating = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isTranslating = false);
    }
  }

  void _showOptions(BuildContext context) {
    CommentOptionsPopup.show(
      context,
      onReport: () {
        if (widget.comment.id != null) {
          CommentReportPage.show(context, commentId: widget.comment.id!);
        }
      },
    );
  }
}
