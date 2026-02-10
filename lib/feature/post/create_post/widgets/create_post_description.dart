import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rightflair/core/constants/string.dart';
import 'package:rightflair/core/extensions/context.dart';

import '../cubit/create_post_cubit.dart';
import '../model/mention_user.dart';
import 'create_post_describe_buttons.dart';
import 'mention_user_dialog.dart';

class CreatePostDescription extends StatefulWidget {
  final TextEditingController controller;
  const CreatePostDescription({super.key, required this.controller});

  @override
  State<CreatePostDescription> createState() => _CreatePostDescriptionState();
}

class _CreatePostDescriptionState extends State<CreatePostDescription> {
  String _lastText = '';
  bool _isProcessing = false;
  final Set<String> _mentions = {}; // tracked usernames
  final Set<String> _tags = {}; // tracked tags

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    if (_isProcessing) return;

    final text = widget.controller.text;
    final cursorPosition = widget.controller.selection.baseOffset;

    // Check if text was deleted
    if (text.length < _lastText.length) {
      _checkAndRemoveBrokenMentionsAndTags(text);
    }

    if (cursorPosition > 0 && cursorPosition <= text.length) {
      // Check if "@" was just typed
      if (text.length > _lastText.length &&
          cursorPosition > 0 &&
          text[cursorPosition - 1] == '@') {
        _showMentionDialog();
      }

      // Check if "#" was just typed and extract the tag
      if (text.length > _lastText.length &&
          cursorPosition > 0 &&
          text[cursorPosition - 1] == ' ') {
        // Check if there's a hashtag before the space
        _extractAndAddTag(text, cursorPosition);
      }
    }

    _lastText = text;
  }

  void _checkAndRemoveBrokenMentionsAndTags(String currentText) {
    _isProcessing = true;

    String modifiedText = currentText;
    bool textChanged = false;

    // Check mentions - if a mention doesn't fully exist, remove broken parts
    final mentionsToRemove = <String>[];
    for (var username in _mentions) {
      final mention = '@$username';

      // Check if full mention exists in text
      if (!modifiedText.contains(mention)) {
        // Find partial match and remove it (looking for @ followed by start of username)
        if (username.isNotEmpty) {
          final partialPattern = RegExp(
            '@${RegExp.escape(username.substring(0, 1))}[a-zA-Z0-9_]*',
          );
          modifiedText = modifiedText.replaceAll(partialPattern, '');
          textChanged = true;
        }
        mentionsToRemove.add(username);
      }
    }

    for (var username in mentionsToRemove) {
      _mentions.remove(username);
    }

    // Check tags - if a tag doesn't fully exist, remove broken parts
    final tagsToRemove = <String>[];
    for (var tag in _tags) {
      final tagWithHash = '#$tag';

      // Check if full tag exists in text
      if (!modifiedText.contains(tagWithHash)) {
        // Find partial match and remove it (looking for # followed by start of tag)
        if (tag.isNotEmpty) {
          final partialPattern = RegExp(
            '#${RegExp.escape(tag.substring(0, 1))}[a-zA-Z0-9_]*',
          );
          modifiedText = modifiedText.replaceAll(partialPattern, '');
          textChanged = true;
        }
        tagsToRemove.add(tag);

        // Remove from cubit
        context.read<CreatePostCubit>().removeTag(tag);
      }
    }

    for (var tag in tagsToRemove) {
      _tags.remove(tag);
    }

    if (textChanged) {
      final cursorPos = widget.controller.selection.baseOffset;
      widget.controller.text = modifiedText;
      _lastText = modifiedText;

      // Adjust cursor position
      final newCursorPos = cursorPos.clamp(0, modifiedText.length);
      widget.controller.selection = TextSelection.fromPosition(
        TextPosition(offset: newCursorPos),
      );
    }

    _isProcessing = false;
  }

  void _extractAndAddTag(String text, int cursorPosition) {
    // Find the last # before cursor
    final textBeforeCursor = text.substring(0, cursorPosition);
    final lastHashIndex = textBeforeCursor.lastIndexOf('#');

    if (lastHashIndex != -1) {
      final potentialTag = textBeforeCursor.substring(lastHashIndex + 1).trim();

      // Check if it's a valid tag (no spaces, not empty)
      if (potentialTag.isNotEmpty && !potentialTag.contains(' ')) {
        context.read<CreatePostCubit>().addTag(potentialTag);
        // Track tag
        _tags.add(potentialTag);
      }
    }
  }

  Future<void> _showMentionDialog() async {
    _isProcessing = true;
    final result = await showDialog<MentionUserModel>(
      context: context,
      builder: (context) => BlocProvider.value(
        value: context.read<CreatePostCubit>(),
        child: const MentionUserDialog(),
      ),
    );

    if (result != null && mounted) {
      // Add mention to cubit
      if (result.id != null) {
        context.read<CreatePostCubit>().addMention(result.id!);
      }

      // Insert username into text
      final currentText = widget.controller.text;
      var cursorPosition = widget.controller.selection.baseOffset;

      // Ensure cursor position is valid
      if (cursorPosition < 0 || cursorPosition > currentText.length) {
        cursorPosition = currentText.length;
      }

      final username = result.username ?? '';
      final mention = '@$username';

      // Check if @ is already at cursor position
      final hasAtSign =
          cursorPosition > 0 &&
          currentText.length > cursorPosition - 1 &&
          currentText[cursorPosition - 1] == '@';

      final String newText;
      final int newCursorPosition;

      if (hasAtSign) {
        // Remove @ since it's already there and replace with full mention + space
        newText =
            currentText.substring(0, cursorPosition) +
            username +
            ' ' +
            currentText.substring(cursorPosition);
        newCursorPosition = cursorPosition + username.length + 1;
      } else {
        // Add full mention with @ + space
        newText =
            currentText.substring(0, cursorPosition) +
            mention +
            ' ' +
            currentText.substring(cursorPosition);
        newCursorPosition = cursorPosition + mention.length + 1;
      }

      // Track mention
      _mentions.add(username);

      widget.controller.text = newText;
      _lastText = newText;
      widget.controller.selection = TextSelection.fromPosition(
        TextPosition(offset: newCursorPosition),
      );
    }
    _isProcessing = false;
  }

  void _insertHashTag() {
    final currentText = widget.controller.text;
    var cursorPosition = widget.controller.selection.baseOffset;

    // Ensure cursor position is valid
    if (cursorPosition < 0 || cursorPosition > currentText.length) {
      cursorPosition = currentText.length;
    }

    _isProcessing = true;
    final newText =
        currentText.substring(0, cursorPosition) +
        '#' +
        currentText.substring(cursorPosition);

    widget.controller.text = newText;
    _lastText = newText;
    widget.controller.selection = TextSelection.fromPosition(
      TextPosition(offset: cursorPosition + 1),
    );
    _isProcessing = false;
  }

  void _insertMention() {
    final currentText = widget.controller.text;
    var cursorPosition = widget.controller.selection.baseOffset;

    // Ensure cursor position is valid
    if (cursorPosition < 0 || cursorPosition > currentText.length) {
      cursorPosition = currentText.length;
    }

    _isProcessing = true;
    final newText =
        currentText.substring(0, cursorPosition) +
        '@' +
        currentText.substring(cursorPosition);

    widget.controller.text = newText;
    _lastText = newText;
    widget.controller.selection = TextSelection.fromPosition(
      TextPosition(offset: cursorPosition + 1),
    );
    _isProcessing = false;

    // Trigger mention dialog
    Future.microtask(() => _showMentionDialog());
  }

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
        children: [
          _field(context),
          CreatePostDescribeButtonsWidget(
            onHashtagTap: _insertHashTag,
            onMentionTap: _insertMention,
          ),
        ],
      ),
    );
  }

  Expanded _field(BuildContext context) {
    return Expanded(
      child: TextField(
        controller: widget.controller,
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
